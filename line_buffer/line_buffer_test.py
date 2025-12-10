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



def read_row_array(dut, array_name, num_elements, data_width=8):
    """
    Read an unpacked array from SystemVerilog into Python list
    
    In SystemVerilog: logic [7:0] fast_rows [0:6]
    This creates separate signals: fast_rows[0], fast_rows[1], etc.
    """
    values = []
    for i in range(num_elements):
        try:
            # Try to access as an array element
            signal = getattr(dut, f"{array_name}[{i}]")
            values.append(int(signal.value))
        except AttributeError:
            # If that fails, some simulators flatten the name differently
            try:
                signal = getattr(dut, f"{array_name}_{i}")
                values.append(int(signal.value))
            except AttributeError:
                dut._log.warning(f"Could not read {array_name}[{i}]")
                values.append(0)
    return values


@cocotb.test()
async def test_line_buffers_basic(dut):
    """Test line buffers with a simple incremental pattern"""
    dut._log.info("Starting basic line buffer test...")
    
    WIDTH = 64  # Match your parameter
    HEIGHT = 40  # Enough rows to test both FAST and BRIEF
    FAST_LINES = 7
    TOTAL_LINES = 31
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start(start_high=False))
    await reset(dut, dut.rst_n)
    
    # Create a simple test pattern: each pixel value = row_number
    # This makes it easy to verify which row is in which buffer
    test_image = np.zeros((HEIGHT, WIDTH), dtype=np.uint8)
    for y in range(HEIGHT):
        for x in range(WIDTH):
            test_image[y, x] = y  # All pixels in row Y have value Y
    
    # Disable input initially
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 2)
    
    # Track what we expect to see
    rows_sent = 0
    
    for y in range(HEIGHT):
        for x in range(WIDTH):
            # Send pixel
            dut.pixel_in.value = int(test_image[y, x])
            dut.valid_in.value = 1
            
            await RisingEdge(dut.clk)
            
            # After completing each row, check outputs
            if x == WIDTH - 1:
                rows_sent += 1
                
                # Check FAST rows (should have 7 oldest rows)
                if rows_sent >= 19:
                    fast_rows = read_row_array(dut, "fast_rows", FAST_LINES)
                    
                    # Expected: rows from (rows_sent - FAST_LINES) to (rows_sent - 1)
                    # But they're centered in the 31-line buffer
                    # So we expect rows starting from (rows_sent - (TOTAL_LINES - FAST_LINES//2 - 1))
                    
                    dut._log.info(f"Row {rows_sent}: FAST rows = {fast_rows}")
                    
                    # Simple check: all values in fast_rows should be reasonable
                    for i, val in enumerate(fast_rows):
                        if val > rows_sent or val < 0:
                            dut._log.error(f"FAST row {i} has unexpected value {val}")
                
                # Check BRIEF rows (should have 31 oldest rows)
                if rows_sent >= 32:
                    brief_rows = read_row_array(dut, "brief_rows", TOTAL_LINES)
                    
                    # Expected: oldest 31 rows
                    expected_oldest = rows_sent - TOTAL_LINES
                    expected_newest = (rows_sent - 1) % TOTAL_LINES
                    
                    dut._log.info(f"Row {rows_sent}: BRIEF rows = {brief_rows[:5]}...{brief_rows[-5:]}")
                    
                    # Check first and last values
                    if brief_rows[0] != expected_oldest:
                        dut._log.error(f"BRIEF oldest row: expected {expected_oldest}, got {brief_rows[0]}")
                    if brief_rows[-1] != expected_newest:
                        dut._log.error(f"BRIEF newest row: expected {expected_newest}, got {brief_rows[-1]}")
                        
    
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 10)
    
    dut._log.info("Basic line buffer test complete!")


@cocotb.test()
async def test_line_buffers_checker(dut):
    """Test with a checkerboard pattern to verify spatial alignment"""
    dut._log.info("Starting checkerboard test...")
    
    WIDTH = 64
    HEIGHT = 40
    FAST_LINES = 7
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start(start_high=False))
    await reset(dut, dut.rst_n)
    
    # Create checkerboard: alternating 0 and 255
    test_image = np.zeros((HEIGHT, WIDTH), dtype=np.uint8)
    for y in range(HEIGHT):
        for x in range(WIDTH):
            test_image[y, x] = 255 if (x + y) % 2 == 0 else 0
    
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 2)
    
    # Store received patterns for visualization
    fast_window = np.zeros((FAST_LINES, WIDTH), dtype=np.uint8)
    
    for y in range(HEIGHT):
        for x in range(WIDTH):
            dut.pixel_in.value = int(test_image[y, x])
            dut.valid_in.value = 1
            
            await RisingEdge(dut.clk)
            
            # Capture FAST window at center of image
            if y == HEIGHT // 2 and x == WIDTH - 1:
                fast_rows = read_row_array(dut, "fast_rows", FAST_LINES)
                
                for i in range(FAST_LINES):
                    fast_window[i, :] = fast_rows[i]
                
                dut._log.info(f"Captured FAST window at row {y}:")
                dut._log.info(f"  Pattern: {fast_rows}")
    
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 5)
    
    dut._log.info("Checkerboard test complete!")


@cocotb.test()
async def test_line_buffers_random(dut):
    """Test with random image data"""
    dut._log.info("Starting random image test...")
    
    WIDTH = 64
    HEIGHT = 40
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start(start_high=False))
    await reset(dut, dut.rst_n)
    
    # Create random test image
    np.random.seed(42)
    test_image = np.random.randint(0, 256, (HEIGHT, WIDTH), dtype=np.uint8)
    
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 2)
    
    # Python model: maintain our own line buffers to compare
    python_buffer = []

    for y in range(HEIGHT):
        for x in range(WIDTH):
            if test_image[y, x] == 6:
                dut._log.info(f"At pixel ({x},{y}), input value is 6")
    
    for y in range(HEIGHT):
        current_row = []
        
        for x in range(WIDTH):
            dut.pixel_in.value = int(test_image[y, x])
            dut.valid_in.value = 1
            current_row.append(test_image[y, x])
            
            await RisingEdge(dut.clk)
        
        # Add completed row to our Python model
        python_buffer.append(current_row)
        if len(python_buffer) > 31:
            python_buffer.pop(0)
        
        # After we have enough rows, compare with DUT
        if y >= 30:  # Have at least 32 rows
            # Read BRIEF rows from DUT
            brief_rows = read_row_array(dut, "brief_rows", 31)
            
            # Compare center pixel of center row (should match)
            center_col = 62
            center_row_dut = brief_rows[15]  # Center of 31 rows
            center_row_python = python_buffer[15][center_col]
            
            if y == 32:  # Log once for debugging
                dut._log.info(f"Center pixel comparison:")
                dut._log.info(f"  DUT brief_rows[15] = {center_row_dut}")
                dut._log.info(f"  Python buffer[15][{center_col}] = {center_row_python}")
                dut._log.info(f"  Input pixel was: {test_image[y-15, center_col]}")
    
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 5)
    
    dut._log.info("Random image test complete!")


@cocotb.test()
async def test_line_buffers_visual(dut):
    """Test and create visual output to verify correctness"""
    dut._log.info("Starting visual verification test...")
    
    WIDTH = 64
    HEIGHT = 40
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start(start_high=False))
    await reset(dut, dut.rst_n)
    
    # Create gradient test pattern
    test_image = np.zeros((HEIGHT, WIDTH), dtype=np.uint8)
    for y in range(HEIGHT):
        for x in range(WIDTH):
            test_image[y, x] = int((y / HEIGHT) * 255)
    
    # Save input image
    plt.figure(figsize=(10, 8))
    plt.subplot(3, 1, 1)
    plt.imshow(test_image, cmap='gray', aspect='auto')
    plt.title('Input Image (Vertical Gradient)')
    plt.colorbar()
    
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 2)
    
    # Capture FAST window at specific point
    capture_row = 25
    fast_capture = None
    
    for y in range(HEIGHT):
        for x in range(WIDTH):
            dut.pixel_in.value = int(test_image[y, x])
            dut.valid_in.value = 1
            
            await RisingEdge(dut.clk)
            # await ReadOnly()
            
            # Capture at end of target row
            if y == capture_row and x == WIDTH - 1:
                fast_rows = read_row_array(dut, "fast_rows", 7)
                fast_capture = np.array(fast_rows)
                dut._log.info(f"Captured FAST window at row {y}: {fast_rows}")
    
    dut.valid_in.value = 0
    await ClockCycles(dut.clk, 5)
    
    # Plot FAST window
    if fast_capture is not None:
        plt.subplot(3, 1, 2)
        plt.plot(fast_capture, 'o-')
        plt.title(f'FAST Row Values at Input Row {capture_row}')
        plt.xlabel('Row Index (0=oldest, 6=newest)')
        plt.ylabel('Pixel Value')
        plt.grid(True)
        

        expected = test_image[7:14, 0]
        plt.subplot(3, 1, 3)
        plt.plot(expected, 's-', label='Expected')
        plt.plot(fast_capture, 'o-', label='DUT Output')
        plt.title('Comparison: Expected vs DUT')
        plt.xlabel('Row Index')
        plt.ylabel('Pixel Value')
        plt.legend()
        plt.grid(True)
    
    plt.tight_layout()
    plt.savefig('line_buffer_test.png')
    dut._log.info("Visual test complete! Check line_buffer_test.png")




def test_runner():
    """Simulate using the Python runner."""
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sys.path.append(str(proj_path / "sim" / "model"))
    sources = [
        proj_path / "hdl" / "better_line_buffer.sv",
    ]
    build_test_args = ["-Wall", "-g2012"]  # Enable SystemVerilog 2012
    sys.path.append(str(proj_path / "sim"))
    
    # Test corner_detector (which instantiates line_buffers)
    hdl_toplevel = "shared_line_buffers"
    
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel=hdl_toplevel,
        always=True,
        build_args=build_test_args,
        parameters={'WIDTH': 64, 'DATA_WIDTH': 8, 'TOTAL_LINES': 31, 'FAST_LINES': 7},  # Small size for faster sim
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