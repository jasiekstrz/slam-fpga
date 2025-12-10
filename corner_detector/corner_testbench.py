import cocotb
import os
import random
import sys
from math import log
import logging
from pathlib import Path
from cocotb.clock import Clock
from cocotb.triggers import Timer, ClockCycles, RisingEdge, FallingEdge, ReadOnly, with_timeout, First, Join, ReadWrite, Edge
from cocotb.utils import get_sim_time as gst
from cocotb.runner import get_runner

import matplotlib.pyplot as plt
import numpy as np
from PIL import Image

test_file = os.path.basename(__file__).replace(".py","")


async def reset(dut, rst_wire):
    rst_wire.value = 0
    await ClockCycles(dut.clk, 3)
    rst_wire.value = 1
    await ClockCycles(dut.clk, 1)
    return


def generate_test_image(width, height):
    """Generate a simple test image with known corners"""
    img = np.ones((height, width), dtype=np.uint8) * 128  # Gray background
    
    # Add some squares
    if height > 30 and width > 30:
        img[10:25, 10:25] = 255  # Top-left bright square
    
    if height > 50 and width > 50:
        img[35:50, 35:50] = 30   # Dark square
    
    plt.figure(figsize=(6, 6))
    plt.imshow(img, cmap='gray', vmin=0, vmax=255)
    plt.title('Generated Test Image')
    plt.colorbar()
    plt.savefig('test_image_generated.png')
    plt.close()
    
    return img


def python_corner_detection(img, threshold=30):
    height, width = img.shape
    corners = []
    
    # Circle offsets (same as hardware)
    circle_offsets = [
        (3, 0), (3, 1), (2, 2), (1, 3), (0, 3), (-1, 3), (-2, 2), (-3, 1),
        (-3, 0), (-3, -1), (-2, -2), (-1, -3), (0, -3), (1, -3), (2, -2), (3, -1)
    ]
    
    for y in range(3, height - 3):
        for x in range(3, width - 3):
            center = int(img[y, x])
            
            # Get circle pixel values
            pixel_values = []
            for dx, dy in circle_offsets:
                pixel_values.append(int(img[y + dy, x + dx]))
            
            # Quick rejection test (4 compass points)
            test_indices = [0, 4, 8, 12]
            bright_count = sum(1 for i in test_indices if pixel_values[i] - center >= threshold)
            dark_count = sum(1 for i in test_indices if center - pixel_values[i] >= threshold)

            if bright_count < 1 and dark_count < 1:
                continue
            
            # Check for 9 contiguous pixels
            found = False
            for start in range(16):
                all_brighter = True
                all_darker = True
                
                for i in range(9):
                    idx = (start + i) % 16
                    diff = pixel_values[idx] - center
                    all_brighter = all_brighter and (diff >= threshold)
                    all_darker = all_darker and (diff <= -threshold)
                
                if all_brighter or all_darker:
                    found = True
                    break
            
            if found:
                corners.append((x, y))
    
    return corners


# @cocotb.test()
async def test_line_buffers(dut):
    
    WIDTH = 32  # Small test image
    HEIGHT = 16
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start(start_high=False))
    await reset(dut, dut.rst_n)

    test_image = np.zeros((HEIGHT, WIDTH), dtype=np.uint8)
    for y in range(HEIGHT):
        for x in range(WIDTH):
            test_image[y, x] = (y * WIDTH + x) % 256
    
    # Send pixels into line buffer
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 2)
    
    for y in range(HEIGHT):
        for x in range(WIDTH):
            dut.pixel_in.value = int(test_image[y, x])
            dut.valid_in.value = 1
            await RisingEdge(dut.clk)
    
    dut.valid_in.value = 0
    
    await ClockCycles(dut.clk, 10)


# @cocotb.test()
async def test_corner_detector_simple(dut):
    
    WIDTH = 64
    HEIGHT = 64
    THRESHOLD = 20
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start(start_high=False))
    await reset(dut, dut.rst_n)
    
    # Generate test image
    test_image = generate_test_image(WIDTH, HEIGHT)
    
    # Get expected corners from python model
    expected_corners = python_corner_detection(test_image, threshold=THRESHOLD)
    dut._log.info(f"Expected {len(expected_corners)} corners from python model")

    if len(expected_corners) == 0:
        dut._log.warning("No expected corners found")
    
    detected_corners = []
    
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 2)
    
    # Track which pixel we're sending
    pixels_sent = 0
    
    for y in range(HEIGHT):
        for x in range(WIDTH):
            # Send pixel
            dut.pixel_in.value = int(test_image[y, x])
            dut.valid_in.value = 1
            
            # Wait for rising edge
            await RisingEdge(dut.clk)
            pixels_sent += 1

            
            evaluated_pixel_idx = pixels_sent - 5 - 1 # Account for pipeline delay
            center_pixel_idx = evaluated_pixel_idx - (WIDTH * 3 + 3)
            
            if center_pixel_idx >= 0:
                center_y = center_pixel_idx // WIDTH
                center_x = center_pixel_idx % WIDTH
                
                # Check for corner detection
                if dut.valid_out.value == 1 and dut.corner_detected.value == 1:
                    # Only count corners in valid region
                    if 3 <= center_x < WIDTH - 3 and 3 <= center_y < HEIGHT - 3:
                        detected_corners.append((center_x, center_y))
                        dut._log.info(f"Corner detected at ({center_x}, {center_y}) on cycle {pixels_sent}")
    
    dut.valid_in.value = 0
    
    # Drain remaining pipeline
    remaining_cycles = WIDTH * 3 + 3 + 5  # Remaining pixels in window + pipeline
    for i in range(remaining_cycles):
        await RisingEdge(dut.clk)
        pixels_sent += 1
        
        evaluated_pixel_idx = pixels_sent - 5 - 1
        center_pixel_idx = evaluated_pixel_idx - (WIDTH * 3 + 3)
        
        if center_pixel_idx >= 0 and center_pixel_idx < WIDTH * HEIGHT:
            center_y = center_pixel_idx // WIDTH
            center_x = center_pixel_idx % WIDTH
            
            if dut.valid_out.value == 1 and dut.corner_detected.value == 1:
                if 3 <= center_x < WIDTH - 3 and 3 <= center_y < HEIGHT - 3:
                    detected_corners.append((center_x, center_y))
                    dut._log.info(f"Corner detected at ({center_x}, {center_y}) during drain")
    
    dut._log.info(f"Hardware detected {len(detected_corners)} corners")

    
    
    # Compare results
    expected_set = set(expected_corners)
    detected_set = set(detected_corners)
    
    matching = expected_set & detected_set
    missing = expected_set - detected_set
    extra = detected_set - expected_set


    
    
    dut._log.info(f"Matching corners: {len(matching)}")
    if missing:
        dut._log.warning(f"Missing {len(missing)} corners: {list(sorted(missing))[:10]}...")
    if extra:
        dut._log.warning(f"Extra {len(extra)} corners: {list(sorted(extra))[:10]}...")
    
    # Visualize results
    fig, axes = plt.subplots(1, 3, figsize=(18, 5))
    
    # Test image
    axes[0].imshow(test_image, cmap='gray', vmin=0, vmax=255)
    axes[0].set_title('Test Image')
    axes[0].grid(True, alpha=0.3)
    
    # Expected corners
    axes[1].imshow(test_image, cmap='gray', vmin=0, vmax=255)
    if expected_corners:
        exp_x, exp_y = zip(*expected_corners)
        axes[1].plot(exp_x, exp_y, 'ro', markersize=10, fillstyle='none', linewidth=2, label='Expected')
    axes[1].set_title(f'Expected Corners ({len(expected_corners)})')
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)
    
    # Detected corners
    axes[2].imshow(test_image, cmap='gray', vmin=0, vmax=255)
    if detected_corners:
        det_x, det_y = zip(*detected_corners)
        axes[2].plot(det_x, det_y, 'go', markersize=10, fillstyle='none', linewidth=2, label='Detected')
    axes[2].set_title(f'Detected Corners ({len(detected_corners)})')
    axes[2].legend()
    axes[2].grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('corner_detection_results.png', dpi=150)
    dut._log.info("Saved visualization to corner_detection_results.png")
    
    # Assert that we got most corners correct
    if len(expected_set) > 0:
        match_ratio = len(matching) / len(expected_set)
        dut._log.info(f"Match ratio: {match_ratio:.2%}")
        assert match_ratio > 0.5, f"Too many mismatched corners: {match_ratio:.2%}" 
    else:
        dut._log.warning("No expected corners")

@cocotb.test()
async def test_corner_detector_real_image(dut):
    """Test with a real grayscale image if available"""
    dut._log.info("Starting real image test...")
    
    # Try to load a real image
    image_path = Path(__file__).parent.parent / "image.jpg"
    
    # Load and convert to grayscale
    img = Image.open(image_path).convert('L')
    img_array = np.array(img)
    HEIGHT, WIDTH = img_array.shape
    
    dut._log.info(f"Testing with real image: {WIDTH}x{HEIGHT}")
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start(start_high=False))
    await reset(dut, dut.rst_n)
    
    # Get expected corners
    expected_corners = python_corner_detection(img_array, threshold=30)
    dut._log.info(f"Expected {len(expected_corners)} corners")
    
    # Stream image through hardware
    detected_corners = []
    pixel_count = 0
    
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 2)
    
    for y in range(HEIGHT):
        for x in range(WIDTH):
            dut.pixel_in.value = int(img_array[y, x])
            dut.valid_in.value = 1
            await RisingEdge(dut.clk)
            
            pixel_count += 1
            evaluated_pixel_idx = pixel_count - 5 - 1
            center_pixel_idx = evaluated_pixel_idx - (WIDTH * 3 + 3)

            if center_pixel_idx >= 0 and center_pixel_idx < WIDTH * HEIGHT:
                center_y = center_pixel_idx // WIDTH
                center_x = center_pixel_idx % WIDTH

                if dut.valid_out.value == 1 and dut.corner_detected.value == 1:
                    if 3 <= center_x < WIDTH - 3 and 3 <= center_y < HEIGHT - 3:
                        detected_corners.append((center_x, center_y))

            
            # Progress indicator
            if pixel_count % 10000 == 0:
                dut._log.info(f"Processed {pixel_count}/{WIDTH*HEIGHT} pixels")
    
    dut.valid_in.value = 0

    remaining_cycles = WIDTH * 3 + 3 + 5  # Remaining pixels in window + pipeline
    for i in range(remaining_cycles):
        await RisingEdge(dut.clk)
        pixel_count += 1

        evaluated_pixel_idx = pixel_count - 5 - 1
        center_pixel_idx = evaluated_pixel_idx - (WIDTH * 3 + 3)
        
        if center_pixel_idx >= 0 and center_pixel_idx < WIDTH * HEIGHT:
            center_y = center_pixel_idx // WIDTH
            center_x = center_pixel_idx % WIDTH
            
            if dut.valid_out.value == 1 and dut.corner_detected.value == 1:
                if 3 <= center_x < WIDTH - 3 and 3 <= center_y < HEIGHT - 3:
                    detected_corners.append((center_x, center_y))


    await ClockCycles(dut.clk, 10)
    
    dut._log.info(f"Hardware detected {len(detected_corners)} corners")

    expected_set = set(expected_corners)
    detected_set = set(detected_corners)
    
    matching = expected_set & detected_set
    missing = expected_set - detected_set
    extra = detected_set - expected_set

    
    dut._log.info(f"Matching corners: {len(matching)}")
    if missing:
        dut._log.warning(f"Missing {len(missing)} corners: {list(sorted(missing))[:10]}...")
    if extra:
        dut._log.warning(f"Extra {len(extra)} corners: {list(sorted(extra))[:10]}...")

    # Visualize results
    fig, axes = plt.subplots(1, 3, figsize=(18, 5))
    
    # Test image
    axes[0].imshow(img_array, cmap='gray', vmin=0, vmax=255)
    axes[0].set_title('Test Image')
    axes[0].grid(True, alpha=0.3)
    
    # Expected corners
    axes[1].imshow(img_array, cmap='gray', vmin=0, vmax=255)
    if matching:
        exp_x, exp_y = zip(*list(matching))
        axes[1].plot(exp_x, exp_y, 'go', markersize=10, fillstyle='none', linewidth=2, label='Expected')
    if missing:
        axes[1].plot(*zip(*list(missing)), 'rx', markersize=10, fillstyle='none', linewidth=2, label='Missing')
    axes[1].set_title(f'Expected Corners ({len(expected_corners)})')
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)
    
    # Detected corners
    axes[2].imshow(img_array, cmap='gray', vmin=0, vmax=255)
    if detected_corners:
        det_x, det_y = zip(*detected_corners)
        axes[2].plot(det_x, det_y, 'go', markersize=10, fillstyle='none', linewidth=2, label='Detected')
    axes[2].set_title(f'Detected Corners ({len(detected_corners)})')
    axes[2].legend()
    axes[2].grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('corner_detection_results.png', dpi=150)


def test_runner():
    """Simulate using the Python runner."""
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sys.path.append(str(proj_path / "sim" / "model"))
    sources = [
        proj_path / "hdl" / "line_buffers.sv",
        proj_path / "hdl" / "corner_detector.sv",
        proj_path / "hdl" / "fast_corner_top.sv"
    ]
    build_test_args = ["-Wall", "-g2012"]
    sys.path.append(str(proj_path / "sim"))
    
    hdl_toplevel = "fast_corner_top"
    
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel=hdl_toplevel,
        always=True,
        build_args=build_test_args,
        parameters={'WIDTH': 1200, 'THRESHOLD': 30},
        timescale=('1ns','1ps'),
        waves=True
    )
    run_test_args = []
    runner.test(
        hdl_toplevel=hdl_toplevel,
        test_module=test_file,
        test_args=run_test_args,
        waves=True
    )
 
if __name__ == "__main__":
    test_runner()