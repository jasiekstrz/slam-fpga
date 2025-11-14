import numpy as np
import cv2
import matplotlib.pyplot as plt
import random



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

    plt.figure(figsize=(10, 6))
    plt.imshow(cv2.cvtColor(final_img, cv2.COLOR_BGR2RGB)) 
    plt.title("Feature Matches")
    plt.axis('off')  
    plt.show()

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

    plt.figure(figsize=(10, 6))
    plt.imshow(cv2.cvtColor(ransac_img, cv2.COLOR_BGR2RGB)) 
    plt.title("RANSAC Feature Matches")
    plt.axis('off')  
    plt.show()

    return H, ransac_matches
    


def fit_fundamental_matrix_ideal(sample_corners1, sample_corners2):
    pts1 = np.array([[x,y] for x,y in sample_corners1], dtype=float)
    pts2 = np.array([[x,y] for x,y in sample_corners2], dtype=float)
    F, mask = cv2.findFundamentalMat(pts1,pts2,cv2.FM_8POINT)
    return F

def fit_fundamental_matrix(sample_corners1, sample_corners2):
    #return fit_fundamental_matrix_ideal(sample_corners1, sample_corners2)
    S = len(sample_corners1) # number of samples

    # create the matrix A to use for solving Af = 0
    matA = []
    for i in range(S):
        x1, y1 = sample_corners1[i]
        x2, y2 = sample_corners2[i]
        matA.append((np.outer(np.array([x2,y2,1], dtype=float), np.array([x1,y1,1], dtype=float))).flatten())

    # solve Af = 0 for f using SVD
    _, _, matVt = np.linalg.svd(matA)
    matF = matVt[-1].reshape(3, 3)

    # force F to have rank 2
    matU, matD, matVt = np.linalg.svd(matF)
    matD[-1] = 0
    matF = matU @ np.diag(matD) @ matVt

    matF /= matF[2,2]

    return matF

def find_inliers(matF, corners1, corners2, matches, threshold):
    inliers = []
    for idx1, idx2, dist in matches:
        x1, y1 = corners1[idx1]
        x2, y2 = corners2[idx2]
        proj = matF @ np.array([[x1],[y1],[1]], dtype=float)
        a = proj[0,0]
        b = proj[1,0]
        c = proj[2,0]
        error = (a*x2 + b*y2 + c)**2 / (a**2+b**2)
        proj2 = np.array([[x2,y2,1]], dtype=float) @ matF
        a = proj2[0,0]
        b = proj2[0,1]
        c = proj2[0,2]
        error = max(error, (a*x1 + b*y1 + c)**2 / (a**2+b**2))
        
        if error < threshold**2:
            inliers.append((idx1,idx2,dist))
    return inliers

def ransac(corners1, corners2, matches, threshold=5, iterations=1000):
    """
    Find the Fundamental Matrix and the inliers correspoonding to it
    
    Args:
        corners1: List of (x,y) for corners in the first frame
        corners2: List of (x,y) for corners in the second frame
        matches: List of (idx1, idx2, distance) tuples
        
    Returns:
        F: Fundamental matrix
        inliers: subset of matches - the inliers corresponding to F
    """
    #TODO: what if len(matches) < 8?

    bestF = None
    best_num_inliers = -1

    for _ in range(iterations):
        # pick 8 random pairs of points from matches
        S = 8 # number of samples
        sample = random.sample(matches, S)
        sample_corners1 = [corners1[idx1] for idx1, _, _ in sample]
        sample_corners2 = [corners2[idx2] for _, idx2, _ in sample]

        # fit the fundamental matrix to samples
        matF = fit_fundamental_matrix(sample_corners1, sample_corners2)

        # find corresponding inliers
        num_inliers = len(find_inliers(matF, corners1, corners2, matches, threshold))

        # if current F is better, update best F so far
        if num_inliers > best_num_inliers:
            best_num_inliers = num_inliers
            bestF = matF
    
    # re-fit the fundamental matrix to all inliers
    inliers = find_inliers(bestF, corners1, corners2, matches, threshold)
    sample_corners1 = [corners1[idx1] for idx1, _, _ in inliers]
    sample_corners2 = [corners2[idx2] for _, idx2, _ in inliers]
    bestF = fit_fundamental_matrix(sample_corners1, sample_corners2)

    # recompute inliers
    inliers = find_inliers(bestF, corners1, corners2, matches, threshold)

    return bestF, inliers




# wrapper
def RANSAC_my(query_img, train_img, queryKeypoints, trainKeypoints, matches):
    _queryKeypoints = [(kp.pt[0], kp.pt[1]) for kp in queryKeypoints]
    _trainKeypoints = [(kp.pt[0], kp.pt[1]) for kp in trainKeypoints]
    _matches = [(m.queryIdx, m.trainIdx, m.distance) for m in matches]
    bestF, inliers = ransac(_queryKeypoints, _trainKeypoints, _matches)

    H = bestF.tolist()
    ransac_matches = [cv2.DMatch(_queryIdx=q, _trainIdx=t, _imgIdx=0, _distance=d) for (q, t, d) in inliers]

    ransac_img = cv2.drawMatches(query_img, queryKeypoints, 
                                train_img, trainKeypoints, ransac_matches, None)
    ransac_img = cv2.resize(ransac_img, (1000, 650))

    plt.figure(figsize=(10, 6))
    plt.imshow(cv2.cvtColor(ransac_img, cv2.COLOR_BGR2RGB)) 
    plt.title("RANSAC Feature Matches")
    plt.axis('off')  
    plt.show()

    return H, ransac_matches






query_img = cv2.imread('../../img/rec3/frames/frame_0020.png')
train_img = cv2.imread('../../img/rec3/frames/frame_0025.png')

queryKeypoints, trainKeypoints, matches = ORB_ideal(query_img, train_img)

H, ransac_matches = RANSAC_my(query_img, train_img, queryKeypoints, trainKeypoints, matches)

print("Homography Matrix (H):")
print(np.round(H,4))
print("Matches:")
print(len(matches))
