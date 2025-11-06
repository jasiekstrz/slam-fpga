import numpy as np
import random


def fit_fundamental_matrix(sample_corners1, sample_corners2):
    S = len(sample_corners1) # number of samples

    # create the matrix A to use for solving Af = 0
    matA = []
    for i in range(S):
        x1, y1 = sample_corners1[i]
        x2, y2 = sample_corners2[i]
        matA.append((np.outer([x2,y2,1], [x1,y1,1])).flatten())

    # solve Af = 0 for f using SVD
    _, _, matVt = np.linalg.svd(matA)
    matF = matVt[-1].reshape(3, 3)

    # force F to have rank 2
    matU, matD, matVt = np.linalg.svd(matF)
    matD[-1] = 0
    matF = matU @ np.diag(matD) @ matVt
    return matF


def find_inliers(matF, corners1, corners2, matches, threshold):
    inliers = []
    for idx1, idx2, dist in matches:
        x1, y1 = corners1[idx1]
        x2, y2 = corners2[idx2]
        error = abs(np.array([x2,y2,1]) @ matF @ np.array([x1,y1,1]))
        if error < threshold:
            inliers.append((idx1,idx2,dist))
    return inliers


def ransac(corners1, corners2, matches, threshold=0.1, iterations=100):
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

