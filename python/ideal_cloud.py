import numpy as np
import cv2
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from PIL import Image
from brief import test_matching, visualize_matches, simple_motion_check
from ransac import ransac
from post import *




def project_points_to_second_image(pts1, depths, K, R, t, img2):
    pts1_h = np.hstack([pts1, np.ones((len(pts1), 1))])  # (N,3)
    K_inv = np.linalg.inv(K)

    # Backproject to 3D in cam1 coords
    pts3D_cam1 = (K_inv @ pts1_h.T) * depths  # (3,N)

    # Transform to cam2
    pts3D_cam2 = R @ pts3D_cam1 + t  # (3,N)

    # Project back to image2
    pts2_h = K @ pts3D_cam2
    pts2 = (pts2_h[:2, :] / pts2_h[2, :]).T  # (N,2)

    # Visualize
    img_out = img2.copy()
    for (x, y) in pts2.astype(int):
        if 0 <= x < img_out.shape[1] and 0 <= y < img_out.shape[0]:
            cv2.circle(img_out, (x, y), 3, (0, 255, 0), -1)
    return img_out, pts2








def warp_image_with_pose(img, depth, K, R, t):
    h, w = img.shape[:2]
    fx, fy = K[0, 0], K[1, 1]
    cx, cy = K[0, 2], K[1, 2]

    # Create pixel grid
    u, v = np.meshgrid(np.arange(w), np.arange(h))
    Z = depth
    X = (u - cx) * Z / fx
    Y = (v - cy) * Z / fy

    pts3D = np.stack((X, Y, Z), axis=-1).reshape(-1, 3)
    pts3D_new = (R @ pts3D.T + t).T  # apply camera motion

    x_new = (pts3D_new[:, 0] * fx / pts3D_new[:, 2]) + cx
    y_new = (pts3D_new[:, 1] * fy / pts3D_new[:, 2]) + cy

    map_x = x_new.reshape(h, w).astype(np.float32)
    map_y = y_new.reshape(h, w).astype(np.float32)

    warped = cv2.remap(img, map_x, map_y, interpolation=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT)
    return warped



def ORB_ideal(query_img, train_img):
    query_img_bw = cv2.cvtColor(query_img, cv2.COLOR_BGR2GRAY)
    train_img_bw = cv2.cvtColor(train_img, cv2.COLOR_BGR2GRAY)

    orb = cv2.ORB_create()

    queryKeypoints, queryDescriptors = orb.detectAndCompute(query_img_bw, None)
    trainKeypoints, trainDescriptors = orb.detectAndCompute(train_img_bw, None)

    matcher = cv2.BFMatcher()
    matches = matcher.match(queryDescriptors, trainDescriptors)

    matches = sorted(matches, key=lambda x: x.distance)

    final_img = cv2.drawMatches(query_img, queryKeypoints, 
                                train_img, trainKeypoints, matches[:], None)
    final_img = cv2.resize(final_img, (1000, 650))

    #print("Matches:")
    #print(matches)
    #print("Points1:")
    #print(queryKeypoints)
    #print("Points2:")
    #print(trainKeypoints)

    #plt.figure(figsize=(10, 6))
    #plt.imshow(cv2.cvtColor(final_img, cv2.COLOR_BGR2RGB)) 
    #plt.title("Feature Matches")
    #plt.axis('off')  
    #plt.show()

    return queryKeypoints, trainKeypoints, matches





def RANSAC_ideal(query_img, train_img, queryKeypoints, trainKeypoints, matches):
    src_pts = np.float32([queryKeypoints[m.queryIdx].pt for m in matches]).reshape(-1, 1, 2)
    dst_pts = np.float32([trainKeypoints[m.trainIdx].pt for m in matches]).reshape(-1, 1, 2)

    #H, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC, 5.0)
    H, mask = cv2.findFundamentalMat(src_pts, dst_pts, cv2.FM_RANSAC, 5.0)

    ransac_matches = []
    for m, present in zip(matches, mask):
        if present:
            ransac_matches.append(m)

    ransac_img = cv2.drawMatches(query_img, queryKeypoints, 
                                train_img, trainKeypoints, ransac_matches, None)
    ransac_img = cv2.resize(ransac_img, (1000, 650))

    #plt.figure(figsize=(10, 6))
    #plt.imshow(cv2.cvtColor(ransac_img, cv2.COLOR_BGR2RGB)) 
    #plt.title("RANSAC Feature Matches")
    #plt.axis('off')  
    #plt.show()

    return H, ransac_matches


def draw_camera(ax, R, t, scale=0.1, color='r'):
    """
    Draw a simple pyramid frustum for a camera.
    - R: 3x3 rotation of camera
    - t: 3x1 translation of camera (camera origin in world frame)
    - scale: size of the frustum
    """
    # Camera origin
    C = t.flatten()
    
    # Frustum points in camera frame (Z forward)
    frustum_points = np.array([
        [0, 0, 0],  # camera center
        [scale, scale, scale*1.5],
        [scale, -scale, scale*1.5],
        [-scale, -scale, scale*1.5],
        [-scale, scale, scale*1.5]
    ]).T  # 3x5

    # Rotate and translate to world frame
    frustum_world = (R @ frustum_points) + C[:, None]  # 3x5
    print(frustum_world[:,0])

    # Draw lines from camera center to corners
    for i in range(1, 5):
        ax.plot(
            [frustum_world[0,0], frustum_world[0,i]],
            [frustum_world[1,0], frustum_world[1,i]],
            [frustum_world[2,0], frustum_world[2,i]],
            c=color
        )
    # Draw frustum base
    for i in range(1, 5):
        j = i+1 if i < 4 else 1
        ax.plot(
            [frustum_world[0,i], frustum_world[0,j]],
            [frustum_world[1,i], frustum_world[1,j]],
            [frustum_world[2,i], frustum_world[2,j]],
            c=color
        )

    ax.plot(
        frustum_world[0,0],frustum_world[1,0],frustum_world[2,0],
        c='b',
        marker='o', markersize=5,
    )





def draw_camera_line(ax, R1, t1, R2, t2, scale=0.1, color='r'):
    """
    Draw a simple pyramid frustum for a camera.
    - R: 3x3 rotation of camera
    - t: 3x1 translation of camera (camera origin in world frame)
    - scale: size of the frustum
    """
    # Camera origin
    C1 = t1.flatten()
    C2 = t2.flatten()
    
    # Frustum points in camera frame (Z forward)
    frustum_points = np.array([
        [0, 0, 0],  # camera center
        [scale, scale, scale*1.5],
        [scale, -scale, scale*1.5],
        [-scale, -scale, scale*1.5],
        [-scale, scale, scale*1.5]
    ]).T  # 3x5

    # Rotate and translate to world frame
    frustum_world1 = (R1 @ frustum_points) + C1[:, None]  # 3x5
    frustum_world2 = (R2 @ frustum_points) + C2[:, None]  # 3x5
    #print(frustum_world[:,0])

    # Draw lines from camera center to corners
    ax.plot(
        [frustum_world1[0,0], frustum_world2[0,0]],
        [frustum_world1[1,0], frustum_world2[1,0]],
        [frustum_world1[2,0], frustum_world2[2,0]],
        c=color
    )




#image1 = Image.open('../../img/rec3/frames/frame_0020.png').convert('L')
#image2 = Image.open('../../img/rec3/frames/frame_0025.png').convert('L')
#image1 = image1.resize((1080, 1920))
#image2 = image2.resize((1080, 1920))
#
##corners1, corners2, desc1, desc2, matches = test_matching()
#corners1, corners2, desc1, desc2, matches = test_matching(image1, image2)
#
#matK = make_matK(image1)
#
#matF, matches_ransac = ransac(corners1, corners2, matches)
##matE, matches_ransac = essential_matrix(matK, corners1, corners2, matches)


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.set_xlabel('X axis')
ax.set_ylabel('Y axis')
ax.set_zlabel('Z axis')
ax.view_init(elev=90, azim=90)

f_min, f_max, f_step = 20, 420, 10
R1 = np.eye(3)
t1 = np.zeros((3,1))
sc = 0.1
pause = 0.5
#draw_camera(ax, R1, t1, scale=sc, color='b')
plt.ion()  # interactive mode ON
plt.show()
for f in range(f_min,f_max,f_step):



    image1 = cv2.imread(f"../../img/rec6/frames/frame_{f:04d}.png")
    image2 = cv2.imread(f"../../img/rec6/frames/frame_{(f+f_step):04d}.png")

    corners1, corners2, matches = ORB_ideal(image1, image2)

    matF, matches_ransac = RANSAC_ideal(image1, image2, corners1, corners2, matches)
    matK = make_matK(image1)
    matches_ransac = [(m.queryIdx, m.trainIdx, m.distance) for m in matches_ransac]



    # Suppose:
    ptsA = []
    ptsB = []
    for idx1,idx2,_ in matches_ransac:
        ptsA.append([corners1[idx1].pt[0], corners1[idx1].pt[1]])
        ptsB.append([corners2[idx2].pt[0], corners2[idx2].pt[1]])
    ptsA = np.array(ptsA, dtype=float)  # shape (N,2)
    ptsB = np.array(ptsB, dtype=float)  # shape (N,2)

    # You have F already:
    F = matF  # shape (3,3)

    # 1) Optionally compute the essential matrix if you know camera intrinsics K:
    K = matK  # 3×3
    E = K.T @ F @ K

    # 2) Recover the relative pose (R, t) between the two cameras:
    _, R, t, mask_pose, points4D = cv2.recoverPose(E, ptsA, ptsB, K, distanceThresh=10)

    #R = cv2.Rodrigues(np.array([0.05, -0.03, 0.01]))[0]  # small rotation
    #t = np.array([[0.1], [0.0], [0.0]])

    # 3) Triangulate the inlier (or filtered) points to 3D
    # Build projection matrices for the two views:
    P0 = K @ np.hstack((np.eye(3), np.zeros((3,1))))
    P1 = K @ np.hstack((R, t))

    # Convert to homogeneous 2×N  and triangulate:
    #ptsA_h = cv2.convertPointsToHomogeneous(ptsA[mask_pose.ravel().astype(bool)]).reshape(-1,3).T
    #ptsB_h = cv2.convertPointsToHomogeneous(ptsB[mask_pose.ravel().astype(bool)]).reshape(-1,3).T
    #ptsA_h = cv2.convertPointsToHomogeneous(ptsA).reshape(-1,3).T
    #ptsB_h = cv2.convertPointsToHomogeneous(ptsB).reshape(-1,3).T

    #points_4d_hom = cv2.triangulatePoints(P0, P1, ptsA_h[:2], ptsB_h[:2])  # 4×M
    points_4d_hom = points4D
    points_3d = (points_4d_hom[:3] / points_4d_hom[3]).T  # shape M×3

    # 4) Visualize the 3D point cloud:
    #fig = plt.figure()
    #ax = fig.add_subplot(111, projection='3d')
    #ax.scatter(points_3d[:,0], points_3d[:,1], points_3d[:,2], s=1)

    #R1 = np.eye(3)
    #t1 = np.zeros((3,1))
    #draw_camera(ax, R1, t1, scale=100, color='r')

    cam_col = ((f_max-f)/(f_max-f_min), (f-f_min)/(f_max-f_min), 0)

    t2 = R @ t1 + t
    R2 = R @ R1

    #draw_camera(ax, R2, t2, scale=sc, color=cam_col)
    draw_camera_line(ax, R1, t1, R2, t2, scale=sc, color=cam_col)

    t1 = t2
    R1 = R2

    plt.draw()
    plt.pause(pause)

#    ax.set_xlabel('X axis')
#    ax.set_ylabel('Y axis')
#    ax.set_zlabel('Z axis')
#
#    plt.show()


    image1 = cv2.cvtColor(np.array(image1), cv2.COLOR_RGB2BGR)
    image2 = cv2.cvtColor(np.array(image2), cv2.COLOR_RGB2BGR)


    #points4D = cv2.triangulatePoints(P0, P1, ptsA.T, ptsB.T)
    points3D = (points4D[:3] / points4D[3]).T
    depths = points3D[:, 2]



    #H = R + (t @ np.array([[0, 0, 1]])) / 1e6  # optional tweak for display only
    n = np.array([0, 0, 1]).reshape(3, 1)  # plane normal
    d = 1.0  # plane distance
    H = K @ (R - t @ n.T / d) @ np.linalg.inv(K)
    #H = K @ R @ np.linalg.inv(K)
    H /= H[2, 2]  # normalize

    # --- Warp img1 using the homography ---
    h2, w2 = image2.shape[:2]
    img1_warped = cv2.warpPerspective(image1, H, (w2, h2))







    ## --- Display both images side by side ---
    #plt.figure(figsize=(12, 6))
    #plt.subplot(1, 2, 1)
    #plt.title("Warped img1 (R applied)")
    #plt.imshow(cv2.cvtColor(img1_warped, cv2.COLOR_BGR2RGB))
    #plt.axis("off")
    #
    #plt.subplot(1, 2, 2)
    #plt.title("Original img2")
    #plt.imshow(cv2.cvtColor(image2, cv2.COLOR_BGR2RGB))
    #plt.axis("off")
    #
    #plt.show()







    #img2_vis, pts2 = project_points_to_second_image(ptsA, depths, K, R, t, image2)
    #plt.imshow(cv2.cvtColor(img2_vis, cv2.COLOR_BGR2RGB))
    #plt.show()








#plt.show()

plt.pause(1e3)
plt.ioff()