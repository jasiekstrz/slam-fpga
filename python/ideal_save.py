import numpy as np
import cv2
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from PIL import Image
from brief import test_matching, visualize_matches, simple_motion_check
from ransac import ransac
from post import *




orb = cv2.ORB_create(3000)
#matcher = cv2.BFMatcher()
flann = cv2.FlannBasedMatcher(indexParams=dict(algorithm=6, table_number=6, key_size=12, multi_probe_level=1), searchParams=dict(checks=50))
def ORB_ideal(query_img, train_img):
    #query_img = np.array(query_img)
    #train_img = np.array(train_img)

    queryKeypoints, queryDescriptors = orb.detectAndCompute(query_img, None)
    trainKeypoints, trainDescriptors = orb.detectAndCompute(train_img, None)

    #matches = matcher.match(queryDescriptors, trainDescriptors)
    #matches = sorted(matches, key=lambda x: x.distance)
    matches = flann.knnMatch(queryDescriptors, trainDescriptors, k=2)

    good_matches = []
    for m, n in matches:
        if m.distance < 0.8 * n.distance:
            good_matches.append(m)

    return queryKeypoints, trainKeypoints, good_matches


def RANSAC_ideal(src_pts, dst_pts):
    F, mask = cv2.findFundamentalMat(src_pts, dst_pts, cv2.FM_RANSAC, 5.0)

    ransac_matches = []
    for i, present in enumerate(mask):
        if present:
            ransac_matches.append(i)

    return F, ransac_matches


def recoverPose(E, points1, points2, K, P1):
    R1, R2, t0 = cv2.decomposeEssentialMat(E)
    sol = [(R1, t0), (R2, t0), (R1, -t0), (R2, -t0)]
    vals = []

    for R, t in sol:
        T = np.eye(4, dtype=np.float64)
        T[:3,:3] = R
        T[:3,3] = np.ndarray.flatten(t)
        #P2 = K @ np.hstack([R, t])
        P2 = np.concatenate(( K, np.zeros((3,1)) ), axis = 1) @ T
        Q1 = cv2.triangulatePoints(P1, P2, points1.T, points2.T)
        Q2 = T @ Q1
        Q1 = Q1[:3,:] / Q1[3,:]
        Q2 = Q2[:3,:] / Q2[3,:]

        total_sum = sum(Q2[2,:] > 0) + sum(Q1[2,:] > 0)
        relative_scale = np.mean(np.linalg.norm(Q1.T[:-1] - Q1.T[1:], axis=-1)/
                                 np.linalg.norm(Q2.T[:-1] - Q2.T[1:], axis=-1))
        vals.append(total_sum + relative_scale)
    
    return sol[np.argmax(vals)]





#images = [Image.open(f"../../img/KITTI_sequence_1/image_l/{i:06d}.png").convert('L') for i in range(51)]
images = [cv2.imread(f"../../img/KITTI_sequence_1/image_l/{i:06d}.png", cv2.IMREAD_GRAYSCALE) for i in range(51)]

with open('../../img/KITTI_sequence_1/calib.txt', 'r') as f:
    K = np.fromstring(f.readline(), dtype=np.float64, sep=' ').reshape((3,4))[0:3,0:3]
    P1 = np.fromstring(f.readline(), dtype=np.float64, sep=' ').reshape((3,4))

R_cur = np.eye(3, dtype=np.float64)
t_cur = np.zeros(3, dtype=np.float64)
#T_cur = np.eye(4, dtype=np.float64)
T_cur = np.array([[1.0, 1.197625e-11, 1.704638e-10, 0.0], [1.197625e-11, 1.0, 3.562503e-10, -1.110223e-16], [1.704638e-10, 3.562503e-10, 1.0, 2.220446e-16], [0.0, 0.0, 0.0, 1.0]], dtype=np.float64)

camera_pos = [np.zeros(3)]
camera_pos.append(T_cur[:3,3])

for i in range(50):
    corners1, corners2, matches = ORB_ideal(images[i], images[i+1])
    points1 = np.float32([corners1[m.queryIdx].pt for m in matches])#.reshape(-1, 1, 2)
    points2 = np.float32([corners2[m.trainIdx].pt for m in matches])#.reshape(-1, 1, 2)
    #print(str(points1.shape) + str(points2.shape) + "\n")

    #F, matches_ransac = RANSAC_ideal(points1, points2)
    #points1 = points1[matches_ransac]
    #points2 = points2[matches_ransac]
    #E = K.T @ F @ K
    E, matches_ransac = cv2.findEssentialMat(points1, points2, K)
    #print ("Essential matrix:\n" + str(E))

    #_, R, t, mask_pose = cv2.recoverPose(E, points1, points2, K)
    #points1 = points1[mask_pose.ravel().astype(bool)]
    #points2 = points2[mask_pose.ravel().astype(bool)]
    R, t = recoverPose(E, points1, points2, K, P1)

    R_cur = R_cur @ R.T
    t_cur = t_cur - (R_cur @ np.ndarray.flatten(t))
    transf = np.eye(4, dtype=np.float64)
    transf[:3,:3] = R
    transf[:3,3] = np.ndarray.flatten(t)
    T_cur = np.matmul(T_cur, np.linalg.inv(transf))
    print ("transf:\n" + str(transf))
    print ("T_cur:\n" + str(T_cur))

    #camera_pos.append(-R_cur.T @ t_cur)
    camera_pos.append(t_cur)
    camera_pos.append(T_cur[:3,3])

for p in camera_pos:
    print(np.round(p, 3).tolist())

