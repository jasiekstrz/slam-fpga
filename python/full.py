import numpy as np
import cv2
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from PIL import Image
from brief import test_matching, visualize_matches, simple_motion_check
from ransac import ransac
from post import *


IMG = False
WORKLOAD = 5
MAX_IMG = 300



#orb = cv2.ORB_create(3500)
orb = cv2.ORB_create(3700)
matcher = cv2.BFMatcher()
def ORB_ideal(query_img, train_img):
    query_img = np.array(query_img)
    train_img = np.array(train_img)

    queryKeypoints, queryDescriptors = orb.detectAndCompute(query_img, None)
    trainKeypoints, trainDescriptors = orb.detectAndCompute(train_img, None)

    matches = matcher.match(queryDescriptors, trainDescriptors)
    matches = sorted(matches, key=lambda x: x.distance)

    return queryKeypoints, trainKeypoints, matches


def RANSAC_ideal(src_pts, dst_pts):
    F, mask = cv2.findFundamentalMat(src_pts, dst_pts, cv2.FM_RANSAC, 4)

    ransac_matches = []
    for i, present in enumerate(mask):
        if present:
            ransac_matches.append(i)

    return F, ransac_matches


def RANSAC_my(src_pts, dst_pts):
    _matches = [(i, i, 0) for i in len(src_pts)]
    F, inliers = ransac(src_pts, dst_pts, _matches)

    ransac_matches = [cv2.DMatch(_queryIdx=q, _trainIdx=t, _imgIdx=0, _distance=d) for (q, t, d) in inliers]

    return F, ransac_matches







images = [Image.open(f"../../img/KITTI_sequence_{WORKLOAD}/image_l/{i:06d}.png").convert('L') for i in range(MAX_IMG+1)]

with open(f"../../img/KITTI_sequence_{WORKLOAD}/calib.txt", 'r') as f:
    K = np.fromstring(f.readline(), dtype=np.float64, sep=' ').reshape((3,4))[0:3,0:3]
    P1 = np.fromstring(f.readline(), dtype=np.float64, sep=' ').reshape((3,4))

R_cur = np.eye(3, dtype=np.float64)
t_cur = np.zeros(3, dtype=np.float64)

camera_pos = [np.zeros(3)]

#sprite_pos = [[np.array([[40,0,15]]).T, np.array([[40,0,14]]).T]]
#sprite_pos = [[np.array([[20,0,10]]).T, np.array([[20,0,12]]).T, np.array([[20,-1,11]]).T]]

#sprite_pos = [[np.array([[x,y,z]]).T for x in [20,21] for y in [-1,-2] for z in [10,11]]]
sprite_pos = [[np.array([[x,y,z]]).T for x in [16,17] for y in [-1,-2] for z in [34,35]]]
#sprite_pos = [[np.array([[x,y,z]]).T for x in [6,7] for y in [-1,-2] for z in [34,35]]]
edges = [(0,1,'blue'), (2,3,'blue'), (4,5,'red'), (6,7,'red'), 
         (0,2,'blue'), (1,3,'blue'), (4,6,'red'), (5,7,'green'), 
         (0,4,'red'), (1,5,'green'), (2,6,'red'), (3,7,'green')]

for i in range(MAX_IMG):
    corners1, corners2, matches = ORB_ideal(images[i], images[i+1])
    points1 = np.float32([corners1[m.queryIdx].pt for m in matches])
    points2 = np.float32([corners2[m.trainIdx].pt for m in matches])

    F, matches_ransac = RANSAC_ideal(points1, points2)
    points1 = points1[matches_ransac]
    points2 = points2[matches_ransac]
    E = K.T @ F @ K

    _, R, t, mask_pose = cv2.recoverPose(E, points1, points2, K)
    points1 = points1[mask_pose.ravel().astype(bool)]
    points2 = points2[mask_pose.ravel().astype(bool)]

    new_sprite = [R @ X + t for X in sprite_pos[-1]]
    for si in range(len(new_sprite)):
        new_sprite[si][1] = sprite_pos[-1][si][1]
    sprite_pos.append(new_sprite)

    R_cur = R_cur @ R.T
    t_cur = t_cur - (R_cur @ np.ndarray.flatten(t))

    camera_pos.append(t_cur)


if IMG:
    images = [mpimg.imread(f"../../img/KITTI_sequence_{WORKLOAD}/image_l/{i:06d}.png") for i in range(MAX_IMG+1)]
    
    for i in range(len(images)):
        plt.imshow(images[i])

        sprite_x = []
        sprite_y = []
        for X in sprite_pos[i]:
            X = K @ X
            sprite_x.append(X[0,0]/X[2,0])
            sprite_y.append(X[1,0]/X[2,0])

        plt.scatter(sprite_x, sprite_y, c='red', s=20)
        for e0, e1, color in edges:
            plt.plot([sprite_x[e0], sprite_x[e1]], [sprite_y[e0], sprite_y[e1]], linewidth=1, color=color)

        plt.axis('off')
        plt.show(block=False)
        plt.pause(1)   
        plt.clf()

else:
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.set_xlabel('X axis')
    ax.set_ylabel('Y axis')
    ax.set_zlabel('Z axis')
    ax.view_init(elev=0, azim=-90)
    plt.ion()
    plt.show()

    print(np.round(camera_pos[0], 3).tolist())
    for i in range(1, len(camera_pos)):
        p1 = camera_pos[i-1]
        p2 = camera_pos[i]
        print(np.round(p2, 3).tolist())
        ax.plot(
            [p1[0], p2[0]],
            [p1[1], p2[1]],
            [p1[2], p2[2]],
            c='g'
        )
        plt.draw()
        plt.pause(0.2)

    plt.pause(1000)
