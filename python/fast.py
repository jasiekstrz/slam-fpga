from PIL import Image
import matplotlib.pyplot as plt
import numpy as np
import math
import time

def bresenham_circle_3(xc, yc):
    points = []
    points.append((xc + 3, yc + 0)) 
    points.append((xc + 3, yc + 1)) 
    points.append((xc + 2, yc + 2)) 
    points.append((xc + 1, yc + 3)) 
    points.append((xc + 0, yc + 3)) 
    points.append((xc - 1, yc + 3))
    points.append((xc - 2, yc + 2))
    points.append((xc - 3, yc + 1))
    points.append((xc - 3, yc + 0))
    points.append((xc - 3, yc - 1))
    points.append((xc - 2, yc - 2))
    points.append((xc - 1, yc - 3))
    points.append((xc + 0, yc - 3))
    points.append((xc + 1, yc - 3))
    points.append((xc + 2, yc - 2))
    points.append((xc + 3, yc - 1)) 
    return points




def is_corner(x, y, image, threshold=20):
    # Get bresenham's circle radius 3 points
    circle_points = bresenham_circle_3(x, y)
    
    # Filter valid points
    valid_points = [(px, py) for px, py in circle_points if 0 <= px < image.width and 0 <= py < image.height]
    
    if len(valid_points) < 12:
        return False
    
    center_pixel = image.getpixel((x, y))
    pixel_values = [image.getpixel((px, py)) for px, py in valid_points]
    
    # Check for 12 contiguous pixels (handling wrap-around)
    n = len(pixel_values)

    


    #check if contiguous pixels are possible
    edges = 0
    for i in range(4):
        if abs(pixel_values[i*4] - center_pixel) > threshold:
            edges += 1

    if edges < 3:
        return False

    # Check for 9 contiguous pixels
    for start in range(n):
        darker_count = 0
        brighter_count = 0
        
        for i in range(9): 
            idx = (start + i) % n 
            diff = pixel_values[idx] - center_pixel
            
            if diff <= -threshold:
                darker_count += 1
                brighter_count = 0
            elif diff >= threshold:
                brighter_count += 1
                darker_count = 0
            else:
                # Sequence broken, no point continuing this starting position
                break
        
        if darker_count >= 9 or brighter_count >= 9:
            return True

    return False

def fast_corner_detection(image, threshold=30):
    corners = []
    width, height = image.size

    for y in range(height):
        for x in range(width):
            if is_corner(x, y, image, threshold):
                corners.append((x, y))

    return corners






def main():
    image1 = Image.open('./final_project/image.jpg')

    # Convert image to RGB
    image = image1.convert('RGB')

    # Convert image to gray scale
    gray = image1.convert('L')

    corners = fast_corner_detection(gray, threshold=30)

    # Convert grayscale to RGB so we can mark corners in red
    gray_rgb = gray.convert('RGB')
    
    # Draw corners on the grayscale image
    for x, y in corners:
        gray_rgb.putpixel((x-1, y), (255, 0, 0))
        gray_rgb.putpixel((x, y), (255, 0, 0))  # Mark corners in red
        gray_rgb.putpixel((x+1, y), (255, 0, 0))
        gray_rgb.putpixel((x, y-1), (255, 0, 0)) 
        gray_rgb.putpixel((x, y+1), (255, 0, 0)) 

    # Display the result
    plt.figure(figsize=(10, 10))
    plt.imshow(gray_rgb)
    plt.title(f"Corners Detected ({len(corners)} corners)")
    plt.show()

if __name__ == "__main__":
    main()

