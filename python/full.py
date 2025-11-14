import numpy as np
import cv2
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from PIL import Image
from brief import test_matching, visualize_matches, simple_motion_check
from ransac import ransac
from post import *




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







images = [Image.open(f"../../img/KITTI_sequence_1/image_l/{i:06d}.png").convert('L') for i in range(51)]

with open('../../img/KITTI_sequence_1/calib.txt', 'r') as f:
    K = np.fromstring(f.readline(), dtype=np.float64, sep=' ').reshape((3,4))[0:3,0:3]
    P1 = np.fromstring(f.readline(), dtype=np.float64, sep=' ').reshape((3,4))

R_cur = np.eye(3, dtype=np.float64)
t_cur = np.zeros(3, dtype=np.float64)

camera_pos = [np.zeros(3)]

for i in range(50):
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

    R_cur = R_cur @ R.T
    t_cur = t_cur - (R_cur @ np.ndarray.flatten(t))

    camera_pos.append(t_cur)


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.set_xlabel('X axis')
ax.set_ylabel('Y axis')
ax.set_zlabel('Z axis')
ax.view_init(elev=0, azim=90)
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
    plt.pause(0.5)

plt.pause(1000)
