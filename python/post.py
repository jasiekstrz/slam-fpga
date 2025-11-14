import cv2
import numpy as np
from ransac import ransac
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D



def make_matK(img):
    #x, y = img.size
    #x, y = 1080, 1920
    #f = 0.8 * max(x, y)
    #matK = np.array([[f, 0, x],
    #                 [0, f, y],
    #                 [0, 0, 1]])
    
    matK = np.array([[ 2.78409747e+03, -1.99173092e+01,  1.49866411e+03],
                    [ 0.00000000e+00,  2.87604196e+03,  2.25825727e+03],
                    [ 0.00000000e+00,  0.00000000e+00,  1.00000000e+00]])

    
    #matK = np.array([[3174.54,0,540],[0,3174.54,960],[0,0,1]], dtype=float)

    return matK


def essential_matrix(matK, corners1, corners2, matches, threshold=5, iterations=1000):
    matF, matches_ransac = ransac(corners1, corners2, matches, threshold, iterations)
    matE = matK.T @ matF @ matK
    return matE, matches_ransac


def recover_pose(matE, matK, corners1, corners2, matches):
    points1 = [corners1[idx1] for idx1, _, _ in matches]
    points2 = [corners2[idx2] for _, idx2, _ in matches]
    pts1 = np.array(points1, dtype=np.float64)
    pts2 = np.array(points2, dtype=np.float64)
    _, matR, t, mask_pose = cv2.recoverPose(matE, pts1, pts2, matK)
    return matR, t, (np.array(matches, dtype=object)[mask_pose.astype(bool).ravel()]).tolist()
    #return matR, t, matches


def triangulate(matK, matR, t, corners1, corners2, matches):
    points1 = [[j for j in corners1[idx1]] for idx1, _, _ in matches]
    points2 = [[j for j in corners2[idx2]] for _, idx2, _ in matches]

    pts1 = np.array(points1, dtype=np.float64)
    pts2 = np.array(points2, dtype=np.float64)

    matP1 = matK @ np.hstack((np.eye(3), np.zeros((3,1))))
    matP2 = matK @ np.hstack((matR, t))
    
    points4D_hom = cv2.triangulatePoints(matP1, matP2, pts1.T, pts2.T)
    points3D = points4D_hom[:3, :] / points4D_hom[3, :]
    return points3D


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



def plot_cloud(points3D, matR, t, color_points=False):
    # points3D: 3xN NumPy array from triangulation
    X = points3D[0, :]
    Y = points3D[1, :]
    Z = points3D[2, :]

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    if color_points:
        Z_normalized = (Z - Z.min()) / (Z.max() - Z.min())
        ax.scatter(X, Y, Z, c=Z_normalized, cmap='jet', s=5)
    else:
        ax.scatter(X, Y, Z, c='b', marker='o', s=5)  # blue dots

    # Draw first camera at origin
    R1 = np.eye(3)
    t1 = np.zeros((3,1))
    draw_camera(ax, R1, t1, scale=0.05, color='r')

    # Draw second camera at t with rotation R (from recoverPose)
    draw_camera(ax, matR, t, scale=0.05, color='g')

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')

    # Optionally, set equal aspect ratio for better perspective
    ax.set_box_aspect([1,1,1])

    plt.show()
