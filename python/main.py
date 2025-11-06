from PIL import Image
from brief import test_matching, visualize_matches, simple_motion_check
from ransac import ransac


if __name__ == "__main__":
    # test brief + ransac
    image1 = Image.open('../../img/frame1.png').convert('L')
    image2 = Image.open('../../img/frame2.png').convert('L')
    image1 = image1.resize((1280, 720))
    image2 = image2.resize((1280, 720))
    corners1, corners2, desc1, desc2, matches = test_matching()

    matF, matches_ransac = ransac(corners1, corners2, matches)
    print("Fundamental Matrix:")
    print(matF)

    print("\nPure BRIEF:")
    visualize_matches(image1, image2, corners1, corners2, matches, max_display=100)
    simple_motion_check(corners1, corners2, matches)
    print("Inliers:", len(matches))

    print("\nBRIEF+RANSAC:")
    visualize_matches(image1, image2, corners1, corners2, matches_ransac, max_display=100)
    simple_motion_check(corners1, corners2, matches_ransac)
    print("Inliers:", len(matches_ransac))