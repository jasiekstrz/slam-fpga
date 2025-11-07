import numpy as np
import scipy.ndimage as ndimage
from PIL import Image
from fast import fast_corner_detection
import time
from PIL import ImageDraw

class BRIEFDescriptor:
    def __init__(self, n_bits=256, patch_size=31, smoothing=True):
        """
        BRIEF descriptor extractor
        
        Args:
            n_bits: Number of bits in descriptor (default 256)
            patch_size: Size of patch around keypoint (default 31x31)
            smoothing: Apply Gaussian smoothing before sampling (reduces noise)
        """
        self.n_bits = n_bits
        self.patch_size = patch_size
        self.smoothing = smoothing
        
        # Generate sampling pattern (done once and reused for all keypoints)
        self.pattern = self.generate_pattern()
        
    def generate_pattern(self):
        """
        Generate random sampling pattern
        
        Returns:
            pattern: (n_bits, 4) array where each row is (x1, y1, x2, y2)
        """
        np.random.seed(0)  # Fixed seed
        
        # Sample from Gaussian distribution centered at patch center
        # Standard deviation = patch_size / 5 keeps most samples in patch
        half_patch = self.patch_size // 2
        sigma = self.patch_size / 5.0
        
        pattern = np.zeros((self.n_bits, 4), dtype=np.int32)
        
        for i in range(self.n_bits):
            # Sample two points from Gaussian distribution
            x1 = int(np.random.normal(0, sigma))
            y1 = int(np.random.normal(0, sigma))
            x2 = int(np.random.normal(0, sigma))
            y2 = int(np.random.normal(0, sigma))
            
            # Clip to patch boundaries
            x1 = np.clip(x1, -half_patch, half_patch)
            y1 = np.clip(y1, -half_patch, half_patch)
            x2 = np.clip(x2, -half_patch, half_patch)
            y2 = np.clip(y2, -half_patch, half_patch)
            
            pattern[i] = [x1, y1, x2, y2]
        
        return pattern
    
    def compute(self, image, keypoints):
        """
        Compute BRIEF descriptors for keypoints
        
        Args:
            image: Grayscale image
            keypoints: List of (x, y) tuples or Nx2 array
            
        Returns:
            descriptors: (N, 32) uint8 array (256 bits packed into 32 bytes)
        """
        if len(keypoints) == 0:
            return np.array([])
        
        keypoints = np.array(keypoints)
        
        # Apply Gaussian smoothing to reduce noise sensitivity
        if self.smoothing:
            image_smooth = ndimage.gaussian_filter(image, sigma=2, order=0)
        else:
            image_smooth = image
    
        
        half_patch = self.patch_size // 2
        print(image_smooth.shape)
        h, w = image_smooth.shape
        
        valid_descriptors = []
        valid_indices = []
        
        for idx, (x, y) in enumerate(keypoints):
            x, y = int(x), int(y)
            
            # Check if patch is within image bounds
            if (x - half_patch < 0 or x + half_patch >= w or y - half_patch < 0 or y + half_patch >= h):
                continue
            
            # Extract patch
            patch = image_smooth[y - half_patch : y + half_patch + 1, 
                                 x - half_patch : x + half_patch + 1]
            
            # Compute descriptor bits
            descriptor_bits = np.zeros(self.n_bits, dtype=np.uint8)
            
            for i, (dx1, dy1, dx2, dy2) in enumerate(self.pattern):
                # Get pixel values at sampled locations
                # Center of patch is at (half_patch, half_patch)
                p1 = patch[half_patch + dy1, half_patch + dx1]
                p2 = patch[half_patch + dy2, half_patch + dx2]
                
                # Compare intensities
                descriptor_bits[i] = 1 if p1 > p2 else 0
            
            # Pack bits into bytes
            descriptor_bytes = np.packbits(descriptor_bits)
            valid_descriptors.append(descriptor_bytes)
            valid_indices.append(idx)
        
        descriptors_out = np.array(valid_descriptors)
        
        return descriptors_out, valid_indices


def hamming_distance(desc1, desc2):
    """
    Compute Hamming distance between two binary descriptors
    
    Args:
        desc1, desc2: Binary descriptors (uint8 arrays)
        
    Returns:
        distance: Number of differing bits
    """
    # XOR gives 1 where bits differ
    xor = np.bitwise_xor(desc1, desc2)
    
    # Count number of 1s
    return np.sum(np.unpackbits(xor))


def test_brief():
    # Load test image
    image1 = Image.open('./final_project/image.jpg')

    # Convert image to RGB
    image = image1.convert('RGB')

    # Convert image to gray scale
    gray = image1.convert('L')

    corners = fast_corner_detection(gray, threshold=30)



    # Compute BRIEF descriptors
    brief = BRIEFDescriptor(n_bits=256, patch_size=31)
    descriptors, valid_indices = brief.compute(gray, corners)
    
    print(f"Computed {len(descriptors)} valid descriptors")
    print(f"Descriptor shape: {descriptors.shape}")  # Should be (N, 32)
    
    # Test Hamming distance
    if len(descriptors) >= 2:
        dist = hamming_distance(descriptors[0], descriptors[1])
        print(f"Hamming distance between first two descriptors: {dist}")
    
    return corners, descriptors


def apply_nms(corners, image, window_size=10):
    """
    Non-maximum suppression to keep only strongest corners
    """
    if len(corners) == 0:
        return corners
    
    corners = np.array(corners)
    
    # Compute corner response for each point
    responses = np.ones(len(corners))
    
    # Sort by response (strongest first)
    sorted_indices = np.argsort(-responses)
    
    kept_corners = []
    suppressed = np.zeros(len(corners), dtype=bool)
    
    for idx in sorted_indices:
        if suppressed[idx]:
            continue
        
        kept_corners.append(corners[idx])
        
        # Suppress nearby corners
        distances = np.linalg.norm(corners - corners[idx], axis=1)
        suppressed[distances < window_size] = True
    
    return np.array(kept_corners)



def adaptive_nms(corners, image, num_features=2000, min_distance=10):
    """
    Keep features that are well-distributed across the image
    """
    if len(corners) <= num_features:
        return corners
    
    corners = np.array(corners)
    h, w = image.shape
    
    # Divide image into grid
    grid_size = int(np.sqrt(num_features))  # e.g., 45x45 for 2000 features
    cell_h = h // grid_size
    cell_w = w // grid_size
    
    selected_corners = []
    
    for i in range(grid_size):
        for j in range(grid_size):
            # Get corners in this cell
            y_min, y_max = i * cell_h, (i + 1) * cell_h
            x_min, x_max = j * cell_w, (j + 1) * cell_w
            
            mask = ((corners[:, 0] >= x_min) & (corners[:, 0] < x_max) &
                    (corners[:, 1] >= y_min) & (corners[:, 1] < y_max))
            
            cell_corners = corners[mask]
            
            if len(cell_corners) > 0:
                # Take first corner (could use strength)
                selected_corners.append(cell_corners[0])
    
    return np.array(selected_corners)

def simple_motion_check(corners1, corners2, matches):
    motions = []
    
    for idx1, idx2, _ in matches:
        p1 = corners1[idx1]
        p2 = corners2[idx2]
        motion = p2 - p1
        motions.append(motion)
    
    motions = np.array(motions)
    
    mean_motion = np.mean(motions, axis=0)
    std_motion = np.std(motions, axis=0)
    
    print(f"\nMotion Statistics:")
    print(f"Average motion: ({mean_motion[0]:.1f}, {mean_motion[1]:.1f}) pixels")
    print(f"Std deviation: ({std_motion[0]:.1f}, {std_motion[1]:.1f}) pixels")
    return mean_motion, std_motion

def test_matching():
    # Load two consecutive frames
    image1 = Image.open('./final_project/frame1.png').convert('L')
    image2 = Image.open('./final_project/frame2.png').convert('L')

    gray1 = image1
    gray2 = image2

    gray1 = gray1.resize((1280, 720))
    gray2 = gray2.resize((1280, 720))

    # Extract features from both frames
    corners1 = fast_corner_detection(gray1, threshold=50)
    corners2 = fast_corner_detection(gray2, threshold=50)

    corners1 = adaptive_nms(corners1, np.array(gray1), num_features=2000, min_distance=10)
    corners2 = adaptive_nms(corners2, np.array(gray2), num_features=2000, min_distance=10)

    brief = BRIEFDescriptor(n_bits=256, patch_size=31)
    desc1, valid_idx1 = brief.compute(gray1, corners1)
    desc2, valid_idx2 = brief.compute(gray2, corners2)
    
    corners1 = corners1[valid_idx1]
    corners2 = corners2[valid_idx2]
    
    print(f"Frame 1: {len(corners1)} features")
    print(f"Frame 2: {len(corners2)} features")
    
    # Match features
    matches = match_features(desc1, desc2, ratio_threshold=0.75, max_distance=50)


    print(f"Found {len(matches)} matches")
    
    # Analyze match quality
    if len(matches) > 0:
        distances = [m[2] for m in matches]
        print(f"Average Hamming distance: {np.mean(distances):.1f}")
        print(f"Min distance: {np.min(distances)}")
        print(f"Max distance: {np.max(distances)}")
    
    return corners1, corners2, desc1, desc2, matches


def match_features(desc1, desc2, ratio_threshold=0.75, max_distance=50):
    """
    Match BRIEF descriptors using ratio test
    
    Args:
        desc1: (N, 32) descriptors from image 1
        desc2: (M, 32) descriptors from image 2
        ratio_threshold: Lowe's ratio test threshold (0.75 is standard)
        max_distance: Maximum Hamming distance for valid match
        
    Returns:
        matches: List of (idx1, idx2, distance) tuples
    """
    matches = []
    
    for i, d1 in enumerate(desc1):
        # Find two best matches
        distances = np.array([hamming_distance(d1, d2) for d2 in desc2])
        
        if len(distances) < 2:
            continue
        
        sorted_indices = np.argsort(distances)
        best_idx = sorted_indices[0]
        second_best_idx = sorted_indices[1]
        
        best_dist = distances[best_idx]
        second_best_dist = distances[second_best_idx]
        
        # Lowe's ratio test: best must be significantly better than second best
        if best_dist < max_distance and best_dist < ratio_threshold * second_best_dist:
            matches.append((i, best_idx, best_dist))
    
    return matches



def visualize_matches(img1, img2, kp1, kp2, matches, max_display=50):
    """
    Create side-by-side visualization of feature matches
    """
    
    # Convert to RGB
    img1 = img1.convert('RGB')
    img2 = img2.convert('RGB')
    
    # Create side-by-side image
    w1, h1 = img1.size
    w2, h2 = img2.size
    combined = Image.new('RGB', (w1 + w2, max(h1, h2)), color='black')
    combined.paste(img1, (0, 0))
    combined.paste(img2, (w1, 0))
    
    draw = ImageDraw.Draw(combined)
    
    # Sort matches by distance (best first)
    matches_sorted = sorted(matches, key=lambda x: x[2])[:max_display]
    
    # Draw matches
    for idx1, idx2, dist in matches_sorted:
        x1, y1 = kp1[idx1]
        x2, y2 = kp2[idx2]
        
        # Color based on quality: green (good) to yellow (ok) to red (poor)
        if dist < 10:
            color = (0, 255, 0)  # Green
        elif dist < 16:
            color = (255, 255, 0)  # Yellow
        else:
            color = (255, 128, 0)  # Orange
        
        # Draw line connecting matches
        draw.line([(x1, y1), (x2 + w1, y2)], fill=color, width=1)
        
        # Draw keypoint circles
        r = 3
        draw.ellipse([x1-r, y1-r, x1+r, y1+r], fill=(255, 0, 0))
        draw.ellipse([x2+w1-r, y2-r, x2+w1+r, y2+r], fill=(255, 0, 0))
    
    combined.show()
    return combined



if __name__ == "__main__":
    # test_brief()
    image1 = Image.open('./final_project/frame1.png').convert('L')
    image2 = Image.open('./final_project/frame2.png').convert('L')
    image1 = image1.resize((1280, 720))
    image2 = image2.resize((1280, 720))
    corners1, corners2, desc1, desc2, matches = test_matching()
    visualize_matches(image1, image2, corners1, corners2, matches, max_display=100)
    simple_motion_check(corners1, corners2, matches)
