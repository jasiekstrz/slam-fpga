import cocotb
import os
import random
import sys
from pathlib import Path
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge
from cocotb.utils import get_sim_time as gst
from cocotb.runner import get_runner

test_file = os.path.basename(__file__).replace(".py","")

async def reset(dut, rst_wire):
    """Reset the DUT"""
    rst_wire.value = 0
    await ClockCycles(dut.clk, 3)
    rst_wire.value = 1
    await ClockCycles(dut.clk, 1)

def get_brief_patterns():
    patterns = [
        (10, 2, 6, 13), (11, -6, 5, 0), (0, 2, 0, 9), (4, 0, 2, 2),
        (9, -1, 1, -5), (-15, 4, 5, -4), (14, -9, 0, -1), (9, 9, 0, 2),
        (-5, -12, -2, 0), (7, 7, -2, -1), (-6, -8, -10, 12), (-3, -2, -7, 4),
        (-10, -1, -5, 2), (-3, -7, 0, 2), (0, 1, -3, -2), (-4, -2, -5, -10),
        (1, -2, -10, 2), (-5, 0, 4, 0), (7, -7, 2, -4), (-5, -3, -1, 0),
        (-7, 5, 2, -9), (9, 11, 7, -1), (-6, 6, -2, 7), (1, 6, 2, 4),
        (0, 11, 0, 2), (11, -8, -7, 6), (-7, 12, -2, -4), (11, 9, 11, 5),
        (-5, 11, -1, 4), (5, 0, 3, 5), (2, -6, 1, 8), (-4, 0, -2, 11),
        (4, 2, -4, 3), (-4, 0, -3, 4), (3, -1, 2, -6), (-9, 2, 1, 3),
        (14, 5, -5, 6), (-8, -2, 0, 10), (-4, -5, 0, -4), (6, -6, -7, -2),
        (-3, 11, 5, 0), (-7, 5, -6, -9), (7, 1, 5, 1), (5, -4, -6, 4),
        (-4, -4, -2, 0), (-2, -8, -3, -13), (3, -9, -6, 0), (-4, 9, -8, 1),
        (0, -7, 3, -1), (4, 5, 13, 8), (-2, -1, 6, 4), (3, -10, 0, -4),
        (1, 0, 5, 1), (4, -2, -5, -2), (0, 2, 14, 0), (-5, -2, -2, 2),
        (-9, 0, 0, 1), (-3, -1, -8, -3), (-3, 2, -7, 4), (9, -12, 2, 4),
        (-3, -2, 0, -1), (-1, -10, 7, 6), (-5, -9, 3, -3), (0, -1, 4, 4),
        (-4, -8, -9, 3), (-7, -3, -3, 0), (-12, 1, 3, 0), (-1, 0, 2, -15),
        (12, 2, -4, -2), (3, 0, -12, 12), (0, 6, -4, 9), (1, 3, -6, 7),
        (4, 8, -3, -2), (14, -6, 0, 7), (0, 3, -2, 2), (-8, 10, 0, -4),
        (4, -2, -8, -8), (4, 0, 0, 6), (-6, -4, -2, 0), (0, -1, 0, 0),
        (-4, -5, 1, -5), (-7, -1, 0, 13), (-4, 5, 4, -7), (4, -7, -15, 3),
        (-10, 2, -4, 10), (6, -2, -4, -7), (-2, -1, -2, 0), (3, 2, -4, -8),
        (8, -4, -4, -3), (-11, -2, -2, 3), (4, 0, 5, 2), (0, 0, -1, -2),
        (-1, -6, 1, -6), (5, -1, 0, 3), (3, -9, -1, 5), (-10, 2, -13, -6),
        (0, -10, -6, -9), (10, 1, 3, -1), (-2, -10, -1, -4), (5, 7, 9, 5),
        (-3, -6, 4, 2), (-10, 2, 5, 0), (-1, -5, -8, 4), (-1, -1, 10, 4),
        (2, 0, 9, 10), (5, 3, -12, 0), (0, 0, 5, -15), (-3, 1, -2, -8),
        (5, 1, -6, 1), (5, 0, 4, 0), (-2, -7, 0, 1), (5, 0, 2, -5),
        (-4, 0, -6, 5), (2, 1, 2, 12), (-2, -13, 1, 0), (-3, -6, -2, 1),
        (-3, 14, -5, -4), (-14, 1, -12, -3), (-1, -4, 10, 6), (8, -5, 6, 3),
        (4, 6, -5, -2), (5, -15, 9, 3), (0, 1, -6, -2), (6, 8, 15, 0),
        (-4, -3, -6, 0), (2, 0, 6, -1), (-2, -3, -10, -9), (-7, 8, 5, 8),
        (-8, -12, -4, 1), (3, 6, 1, 10), (-1, -5, -10, -5), (1, -5, 5, 8),
        (-14, 5, -13, 2), (7, 0, -7, -3), (-1, -1, -1, 0), (1, -7, -1, 9),
        (-2, -2, 6, -15), (7, -3, 1, 0), (5, -1, -4, 8), (-14, 0, -8, -4),
        (12, 0, 1, -11), (-4, 1, 2, 3), (0, 3, 2, -11), (0, 4, 3, -2),
        (-4, -6, 0, 7), (-12, -4, -7, 4), (-3, -2, -1, 2), (-2, -15, 3, 2),
        (-1, -6, 2, 2), (-2, -1, -5, -1), (-9, 2, -5, 1), (-8, -3, 0, -10),
        (0, -2, -10, -8), (3, 5, 0, 2), (1, 2, 7, -9), (4, -2, -1, -1),
        (-2, -7, 1, 10), (0, 0, -4, 0), (2, -2, -2, 2), (-5, 1, 5, 8),
        (0, 8, 6, -6), (-7, -1, 6, 0), (-3, 9, 1, -14), (1, 3, 1, 2),
        (0, -8, -2, -5), (-5, -7, 2, 0), (-2, -4, 0, 6), (-12, 2, -3, -11),
        (-12, -5, 1, 2), (-5, 6, 8, 2), (-3, 6, 4, 5), (-4, -15, 13, -9),
        (0, 14, 2, 5), (-9, -11, -3, 6), (-2, -4, 1, 6), (-8, -7, -4, 6),
        (1, 13, 5, 0), (7, 1, -4, 4), (-4, -1, 8, 0), (-4, -2, 6, -3),
        (-2, -3, 1, -2), (-9, -5, -5, 7), (5, 3, -3, -5), (-3, -6, 15, -13),
        (3, -7, 0, -6), (-7, -7, 10, 0), (-4, 3, 0, 4), (-11, 1, 4, -10),
        (2, 10, 0, 5), (4, -4, 0, -9), (-2, 1, 4, 0), (4, -6, 0, 0),
        (11, -1, -3, 0), (-5, 1, -2, -11), (0, -1, -10, 0), (9, 3, 3, -8),
        (2, 0, 3, 2), (-8, 0, -4, 0), (-5, 8, -5, -5), (0, -6, -2, -5),
        (8, 4, 0, -2), (5, 2, 3, 0), (-10, 0, -3, 3), (6, -4, 2, 10),
        (-4, 10, -5, 0), (0, 0, -5, -3), (-4, 2, 2, 13), (8, -3, 2, 6),
        (0, 0, 0, 5), (-5, -2, 2, 1), (1, -2, 6, 13), (2, -1, 4, -3),
        (-4, 0, -15, -7), (-2, -8, -6, -2), (-10, -2, -3, 0), (7, 1, 0, 0),
        (1, -6, 0, 1), (-8, 5, 6, -3), (-1, -5, 4, -6), (-1, -5, 0, -11),
        (8, -5, 0, -1), (-4, -5, 5, -3), (1, -4, -4, 2), (5, -1, -8, 12),
        (-5, -9, 15, -2), (-9, -4, 2, 1), (-5, 11, -3, -7), (5, 8, -5, -8),
        (6, -12, -7, 5), (0, -1, 2, 0), (-8, 7, 8, 1), (0, 14, -1, -1),
        (2, 9, 9, -1), (1, -8, -1, -5), (-6, 10, -4, -3), (2, 8, 2, 15),
        (0, 1, 1, 8), (3, 0, -5, 1), (8, -2, 3, 1), (5, -4, 14, -7),
        (-2, 5, 1, 5), (-3, 0, 0, 9), (4, 4, -4, 6), (1, 8, 12, -1),
        (-2, -5, 0, -2), (2, 0, -2, 6), (-5, 2, -2, 4), (8, -1, 2, 1),
        (-4, 1, 1, 2), (-1, 0, -7, -2), (3, 5, -2, 0), (1, 1, 3, -11),
        (0, 1, -6, 10), (1, 9, -4, -5), (1, -10, 1, 0), (6, 4, -2, -6),
    ]
    return patterns

def compute_brief_descriptor_python(patch, patterns):
    descriptor = 0
    HALF_PATCH = 15
    
    for i, (x1, y1, x2, y2) in enumerate(patterns):
        abs_x1 = HALF_PATCH + x1
        abs_y1 = HALF_PATCH + y1
        abs_x2 = HALF_PATCH + x2
        abs_y2 = HALF_PATCH + y2
        
        if (0 <= abs_x1 < 31 and 0 <= abs_y1 < 31 and
            0 <= abs_x2 < 31 and 0 <= abs_y2 < 31):
            pixel1 = patch[abs_y1, abs_x1]
            pixel2 = patch[abs_y2, abs_x2]

            
            if pixel1 > pixel2:
                descriptor |= (1 << i)
    
    return descriptor

@cocotb.test()
async def test_brief_simple_patch(dut):    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut, dut.rst_n)
    
    # Create a simple test patch 
    test_patch = np.zeros((31, 31), dtype=np.uint8)
    
    for y in range(31):
        for x in range(31):
            test_patch[y, x] = (x * 8 + y * 4) % 256
    
    dut.corner_detected.value = 0
    dut.corner_x.value = 0
    dut.corner_y.value = 0
    dut.pixel_valid.value = 0
    
    # Initialize all brief_rows to 0
    for i in range(31):
        getattr(dut, f"brief_rows[{i}]").value = 0

    
    await ClockCycles(dut.clk, 5)
    
    # Feed the patch column-by-column with pixel_valid
    for col in range(31):
        # Set all rows for this column
        for row in range(31):
            getattr(dut, f"brief_rows[{row}]").value = int(test_patch[row, col])
        
        dut.pixel_valid.value = 1
        await RisingEdge(dut.clk)
        

    
    dut.pixel_valid.value = 0
    await ClockCycles(dut.clk, 5)
    
    # Now trigger corner detection
    dut.corner_x.value = 15
    dut.corner_y.value = 15
    dut.corner_detected.value = 1
    await RisingEdge(dut.clk)
    dut.corner_detected.value = 0
    
    
    await RisingEdge(dut.clk)
    

    # Check for valid output
    if int(dut.descriptor_valid.value) == 1:
        hw_descriptor = int(dut.descriptor.value)
        desc_x = int(dut.descriptor_x.value)
        desc_y = int(dut.descriptor_y.value)

        dut._log.info(f"  Position: ({desc_x}, {desc_y})")
        dut._log.info(f"  Descriptor: 0x{hw_descriptor:064x}")
        dut._log.info(f"  Hamming weight: {bin(hw_descriptor).count('1')}/256")
        
        # Compute reference
        patterns = get_brief_patterns()
        ref_descriptor = compute_brief_descriptor_python(test_patch, patterns)
        
        dut._log.info(f"  Reference:  0x{ref_descriptor:064x}")
        dut._log.info(f"  Ref Hamming: {bin(ref_descriptor).count('1')}/256")
        
        # Compare
        if hw_descriptor == ref_descriptor:
            dut._log.info("DESCRIPTORS MATCH")
        else:
            # Count bit differences
            xor = hw_descriptor ^ ref_descriptor
            diff_bits = bin(xor).count('1')
            dut._log.error(f"MISMATCH: {diff_bits} bits different")
            
            # Show first few differences
            dut._log.info("First 10 mismatched bits:")
            count = 0
            for i in range(256):
                if (xor >> i) & 1:
                    hw_bit = (hw_descriptor >> i) & 1
                    ref_bit = (ref_descriptor >> i) & 1
                    dut._log.info(f"  Bit {i}: HW={hw_bit}, Ref={ref_bit}")
                    count += 1
                    if count >= 10:
                        break
            
            assert False, f"Descriptor mismatch: {diff_bits} bits different"
        
    await ClockCycles(dut.clk, 10)

@cocotb.test()
async def test_brief_all_zeros(dut):
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut, dut.rst_n)
    
    
    dut.corner_detected.value = 0
    dut.pixel_valid.value = 0
    await ClockCycles(dut.clk, 5)
    
    # Feed patch
    for col in range(31):
        for row in range(31):
            getattr(dut, f"brief_rows[{row}]").value = 0

        dut.pixel_valid.value = 1
        await RisingEdge(dut.clk)
    
    dut.pixel_valid.value = 0
    await ClockCycles(dut.clk, 5)
    
    # Trigger
    dut.corner_x.value = 100
    dut.corner_y.value = 100
    dut.corner_detected.value = 1
    await RisingEdge(dut.clk)
    dut.corner_detected.value = 0
    
    # Wait for result
    await RisingEdge(dut.clk)
    if int(dut.descriptor_valid.value) == 1:
        descriptor = int(dut.descriptor.value)
        dut._log.info(f"All-zeros descriptor: 0x{descriptor:064x}")
        # With all equal pixels, pixel1 > pixel2 is always false
        assert descriptor == 0, "Expected all-zero descriptor for uniform patch"
    
    await ClockCycles(dut.clk, 5)

@cocotb.test()
async def test_brief_checkerboard(dut):
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut, dut.rst_n)
    
    # Checkerboard
    test_patch = np.zeros((31, 31), dtype=np.uint8)
    for y in range(31):
        for x in range(31):
            test_patch[y, x] = 255 if (x + y) % 2 == 0 else 0
    
    dut.corner_detected.value = 0
    dut.pixel_valid.value = 0
    await ClockCycles(dut.clk, 5)
    
    # Feed patch
    for col in range(31):
        for row in range(31):
            getattr(dut, f"brief_rows[{row}]").value = int(test_patch[row, col])
        dut.pixel_valid.value = 1
        await RisingEdge(dut.clk)
    
    dut.pixel_valid.value = 0
    await ClockCycles(dut.clk, 5)
    
    # Trigger
    dut.corner_x.value = 50
    dut.corner_y.value = 50
    dut.corner_detected.value = 1
    await RisingEdge(dut.clk)
    dut.corner_detected.value = 0
    
    # Wait and compare
    await RisingEdge(dut.clk)
    if int(dut.descriptor_valid.value) == 1:
        hw_descriptor = int(dut.descriptor.value)
        patterns = get_brief_patterns()
        ref_descriptor = compute_brief_descriptor_python(test_patch, patterns)
        
        dut._log.info(f"Checkerboard HW:  0x{hw_descriptor:064x}")
        dut._log.info(f"Checkerboard Ref: 0x{ref_descriptor:064x}")
        
        assert hw_descriptor == ref_descriptor, "Checkerboard mismatch"
    
    await ClockCycles(dut.clk, 5)


def test_runner():
    """Simulate using the Python runner"""
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sys.path.append(str(proj_path / "sim" / "model"))
    
    sources = [
        proj_path / "hdl" / "brief_descriptor_fast.sv",
        
    ]
    
    build_test_args = ["-Wall", "-g2012"]
    sys.path.append(str(proj_path / "sim"))
    
    hdl_toplevel = "brief_descriptor_fast"
    
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel=hdl_toplevel,
        always=True,
        build_args=build_test_args,
        parameters={
            'PATCH_SIZE': 31,
            'N_BITS': 256,
            # 'PARALLEL_BITS': 256,
            'PIXEL_WIDTH': 8,
            # 'IMG_WIDTH': 1280
        },
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