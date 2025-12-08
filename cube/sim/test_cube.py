import cocotb
import os
import random
import sys
import math
from math import log
import numpy
import logging
from pathlib import Path
from cocotb.clock import Clock
from cocotb.triggers import Timer, ClockCycles, RisingEdge, FallingEdge, ReadOnly,with_timeout
from cocotb.utils import get_sim_time as gst
from cocotb.runner import get_runner
from cocotb_bus.bus import Bus
from cocotb_bus.drivers import BusDriver
from cocotb_bus.monitors import Monitor
from cocotb_bus.monitors import BusMonitor
from cocotb_bus.scoreboard import Scoreboard
import numpy as np
from PIL import Image
from model_cube import *
test_file = os.path.basename(__file__).replace(".py","")
test_dir = os.path.dirname(os.path.abspath(__file__))

random.seed(42)

class AXIS_Monitor(BusMonitor):
    """
    monitors axi streaming bus
    """
    transactions = 0 #use this variable to track good ready/valid handshakes
    def __init__(self, dut, name, clk, callback=None):
        self._signals = ['axis_tvalid','axis_tready','axis_tlast','axis_tdata','axis_tstrb']
        BusMonitor.__init__(self, dut, name, clk, callback=callback)
        self.clock = clk
        self.transactions = 0
        self.dut = dut
    async def _monitor_recv(self):
        """
        Monitor receiver
        """
        rising_edge = RisingEdge(self.clock) # make these coroutines once and reuse
        falling_edge = FallingEdge(self.clock)
        read_only = ReadOnly() #This is
        while True:
            #await rising_edge #can either wait for just edge...
            #or you can also wait for falling edge/read_only (see note in lab)
            await falling_edge #sometimes see in AXI shit
            await read_only  #readonly (the postline)
            valid = self.bus.axis_tvalid.value
            ready = self.bus.axis_tready.value
            last = self.bus.axis_tlast.value
            data = self.bus.axis_tdata.value #.signed_integer
            if valid and ready:
                self.transactions+=1
                thing = dict(data=data,last=last,
                             name=self.name,count=self.transactions)
                #self.dut._log.info(f"{self.name}: {thing}")
                self._recv((data, last))

class AXIS_Driver(BusDriver):
    def __init__(self, dut, name, clk, role="M"):
        self._signals = ['axis_tvalid', 'axis_tready', 'axis_tlast', 'axis_tdata','axis_tstrb']
        BusDriver.__init__(self, dut, name, clk)
        self.clock = clk
        self.dut = dut

class M_AXIS_Driver(AXIS_Driver):
    def __init__(self, dut, name, clk):
        super().__init__(dut,name,clk)
        self.bus.axis_tdata.value = 0
        self.bus.axis_tstrb.value = 0xF
        self.bus.axis_tlast.value = 0
        self.bus.axis_tvalid.value = 0

    async def _driver_send(self, value, sync=True):
        rising_edge = RisingEdge(self.clock) # make these coroutines once and reuse
        falling_edge = FallingEdge(self.clock)
        read_only = ReadOnly() #This is
        if value.get("type") == "pause":
            await falling_edge
            self.bus.axis_tdata.value = 0
            self.bus.axis_tvalid.value = 0 #set to 0 and be done.
            self.bus.axis_tlast.value = 0 #set to 0 and be done.
            for i in range(value.get("duration",1)):
                await rising_edge
        elif value.get("type") == "write_single":
            await falling_edge
            self.bus.axis_tvalid.value = 1
            self.bus.axis_tdata.value = value.get("contents").get("data")
            self.bus.axis_tlast.value = value.get("contents").get("last")
            await rising_edge
        elif value.get("type") == "write_burst":
            await falling_edge
            self.bus.axis_tvalid.value = 1
            for i in range(len(value.get("contents").get("data"))):
                self.bus.axis_tdata.value = int(value.get("contents").get("data")[i])
                self.bus.axis_tlast.value = 1 if i == len(value.get("contents").get("data"))-1 else 0
                await rising_edge
        elif value.get("type") == "write_burst_proper":
            #print("write proper", value.get("contents").get("data"))
            await falling_edge
            i = 0
            #print("\nNEXT i", i, "\n")
            while i in range(len(value.get("contents").get("data"))):
                self.bus.axis_tvalid.value = 1
                self.bus.axis_tdata.value = int(value.get("contents").get("data")[i])
                self.bus.axis_tlast.value = 1 if i == len(value.get("contents").get("data"))-1 else 0
                await ReadOnly()
                if self.bus.axis_tready.value:
                    i += 1
                    #print("")
                    #print(int(value.get("contents").get("data")[i-1]))
                    #print("NEXT i", i, "\n")
                await rising_edge
        else:
            pass

class S_AXIS_Driver(BusDriver):
    def __init__(self, dut, name, clk):
        self._signals = ['axis_tvalid', 'axis_tready', 'axis_tlast', 'axis_tdata','axis_tstrb']
        AXIS_Driver.__init__(self, dut, name, clk)
        self.bus.axis_tready.value = 0

    async def _driver_send(self, value, sync=True):
        rising_edge = RisingEdge(self.clock) # make these coroutines once and reuse
        falling_edge = FallingEdge(self.clock)
        read_only = ReadOnly() #This is
        if value.get("type") == "pause":
            await falling_edge
            self.bus.axis_tready.value = 0 #set to 0 and be done.
            for i in range(value.get("duration",1)):
                await rising_edge
        if value.get("type") == "read":
            await falling_edge
            self.bus.axis_tready.value = 1
            for i in range(value.get("duration",1)):
                await rising_edge
        else:
            pass

async def reset(clk,rst, cycles_held = 3,polarity=1):
    rst.value = polarity
    await ClockCycles(clk, cycles_held)
    rst.value = not polarity

def write_cube(driver, cube_pts):
    msg = np.array([(x | (y << 11)) for x,y in cube_pts])
    driver.append({'type':'write_burst_proper', 'contents':{'data': msg}})

def write_frame(driver, img):
    img = np.array(img.convert("RGB"))
    pixels_24bit = (img[:, :, 0].astype(np.uint32) << 16) | \
                   (img[:, :, 1].astype(np.uint32) << 8)  | \
                   (img[:, :, 2].astype(np.uint32))
    msg = pixels_24bit.flatten()
    driver.append({'type':'write_burst_proper', 'contents':{'data': msg}})





def display_from_stream(arr):
    arr = np.array(arr, dtype=np.uint32).reshape((MAX_Y,MAX_X))
    r = (arr >> 16) & 0xFF
    g = (arr >> 8) & 0xFF
    b = arr & 0xFF

    stacked_arr = np.stack([r, g, b], axis=-1).astype(np.uint8)
    img = Image.fromarray(stacked_arr, mode="RGB")
    img.show()







sig_in = []
sig_out_act = [] #contains list of actual outputs (Growing)



@cocotb.test()
async def test_a(dut):
    """cocotb test for AXIS cube no backpressure"""

    cube_model = CubeModel()

    inm0 = AXIS_Monitor(dut,'s00',dut.s00_axis_aclk,callback=cube_model.cube_model0)
    inm1 = AXIS_Monitor(dut,'s01',dut.s00_axis_aclk,callback=cube_model.cube_model1)
    outm = AXIS_Monitor(dut,'m00',dut.s00_axis_aclk,callback=lambda x: sig_out_act.append(x))
    ind0 = M_AXIS_Driver(dut,'s00',dut.s00_axis_aclk) #M driver for S port
    ind1 = M_AXIS_Driver(dut,'s01',dut.s00_axis_aclk) #M driver for S port
    outd = S_AXIS_Driver(dut,'m00',dut.s00_axis_aclk) #S driver for M port

    # Create a scoreboard on the stream_out bus
    scoreboard = Scoreboard(dut,fail_immediately=True)
    scoreboard.add_interface(outm, sig_out_exp)
    cocotb.start_soon(Clock(dut.s00_axis_aclk, 10, units="ns").start())
    await reset(dut.s00_axis_aclk, dut.s00_axis_aresetn,2,0)

    write_cube(ind0, [(600+10*dx,150+10*dy) for dd in [0,1] for dy in [-dd,-dd-2] for dx in [dd,dd+2]])
    write_frame(ind1, Image.open(f"{test_dir}/../../../img/KITTI_sequence_1/image_l/000000.png"))
    write_cube(ind0, [(200+10*dx,250+10*dy) for dd in [0,1] for dy in [-dd,-dd-2] for dx in [dd,dd+2]])
    write_frame(ind1, Image.open(f"{test_dir}/../../../img/KITTI_sequence_1/image_l/000000.png"))
    ind0.append({"type":"pause","duration":1000000})
    ind1.append({"type":"pause","duration":1000000})

    #feed the driver on the S Side:
    #always be ready to receive data:
    outd.append({'type':'read', "duration":1000000})

    await ClockCycles(dut.s00_axis_aclk, 1000000)
    display_from_stream(pixels)
    assert inm1.transactions==outm.transactions, f"Transaction Count doesn't match! :-/ {inm1.transactions} vs {outm.transactions}"


def cube_runner():
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sys.path.append(str(proj_path / "sim" / "model"))
    sys.path.append(str(proj_path / "hdl" ))
    sources = [proj_path / "hdl" / "cube.sv"]
    build_test_args = ["-Wall", "-g2012"]
    parameters = {} #!!!
    sys.path.append(str(proj_path / "sim"))
    runner = get_runner(sim)
    hdl_toplevel = "cube"
    runner.build(
        sources=sources,
        hdl_toplevel=hdl_toplevel, 
        always=True,
        build_args=build_test_args,
        parameters=parameters,
        timescale = ('1ns','1ps'),
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
    cube_runner()