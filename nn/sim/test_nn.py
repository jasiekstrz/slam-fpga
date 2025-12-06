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
test_file = os.path.basename(__file__).replace(".py","")

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
                self._recv((data.signed_integer, last))

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









NUM_BITS = 8
KEY_SIZE = math.ceil(math.log2(NUM_BITS))+1

class Corner:
    def __init__(self, desc):
        self.desc = desc

    @classmethod
    def random(cls):
        desc = random.getrandbits(NUM_BITS)
        return cls(desc)

    @classmethod
    def from_int(cls, val):
        desc = int(val)
        return cls(desc)

    @classmethod
    def size(cls):
        return NUM_BITS

    def to_int(self):
        return self.desc

class Match:
    def __init__(self, dist, dist2, a, b):
        self.dist = dist
        self.dist2 = dist2
        self.a = a
        self.b = b

    @classmethod
    def from_int(cls, val):
        b     = Corner.from_int((int(val) >> 0) & ((1<<Corner.size())-1))
        a     = Corner.from_int((int(val) >> Corner.size()) & ((1<<Corner.size())-1))
        dist2 = (int(val) >> (2*Corner.size())) & ((1<<KEY_SIZE)-1)
        dist  = (int(val) >> (2*Corner.size()+KEY_SIZE)) & ((1<<KEY_SIZE)-1)
        return cls(dist, dist2, a, b)

    def to_int(self):
        return (self.dist << (2*Corner.size()+KEY_SIZE)) | (self.dist2 << (2*Corner.size())) | (self.a.to_int() << Corner.size()) | (self.b.to_int() << 0)





sig_in = []
sig_out_exp = [] #contains list of expected outputs (Growing)
sig_out_act = [] #contains list of expected outputs (Growing)
def make_nn_model():
    a_vals = []
    #b_vals = [Corner(desc=0), Corner(desc=0)]
    b_vals = []
    def nn_model(val):
        nonlocal a_vals, b_vals
        a, last = val
        #print("model", a, last)
        a = Corner.from_int(a)
        sig_in.append(a)
        a_vals = [a] + a_vals

        best_match = Match(NUM_BITS, NUM_BITS, Corner.from_int(0), Corner.from_int(0))
        for b in b_vals:
            dist = int(np.bitwise_count(a.desc ^ b.desc))
            if dist < best_match.dist:
                best_match.dist2 = best_match.dist
                best_match.dist = dist
                best_match.a = a
                best_match.b = b
            elif dist < best_match.dist2:
                best_match.dist2 = dist
        #print("EXP:", best_match.dist, best_match.dist2, best_match.a.to_int(), best_match.b.to_int())
        #print("EXP_BIT:", bin(best_match.to_int()))
        sig_out_exp.append((best_match.to_int(), last))

        if last:
            b_vals = a_vals.copy()
            a_vals = []
    return nn_model


@cocotb.test()
async def test_a(dut):
    """cocotb test for AXIS fir no backpressure"""

    inm = AXIS_Monitor(dut,'s00',dut.s00_axis_aclk,callback=make_nn_model())
    outm = AXIS_Monitor(dut,'m00',dut.s00_axis_aclk,callback=lambda x: sig_out_act.append(x))
    ind = M_AXIS_Driver(dut,'s00',dut.s00_axis_aclk) #M driver for S port
    outd = S_AXIS_Driver(dut,'m00',dut.s00_axis_aclk) #S driver for M port

    # Create a scoreboard on the stream_out bus
    scoreboard = Scoreboard(dut,fail_immediately=True)
    scoreboard.add_interface(outm, sig_out_exp)
    cocotb.start_soon(Clock(dut.s00_axis_aclk, 10, units="ns").start())
    await reset(dut.s00_axis_aclk, dut.s00_axis_aresetn,2,0)

    #feed the driver on the M Side:
    #for i in range(10):
    #    ind.append({'type':'write_single', "contents":{"data": Corner.random().to_int(),"last":0}})
    #    ind.append({"type":"pause","duration":random.randint(1,6)})
    #for i in range(10):
    #    ind.append({'type':'write_burst', "contents": {"data": np.array([Corner.random().to_int() for _ in range(random.randint(10,20))])}})
    #    ind.append({'type':'pause','duration':2}) #end with pause
    #for i in range(10):
    #    ind.append({'type':'write_single', "contents":{"data": i+1,"last":1}})
    #    ind.append({"type":"pause","duration":5})
    for i in range(10):
        ind.append({'type':'write_burst_proper', "contents":{"data": np.array([Corner.random().to_int() for _ in range(random.randint(10,20))])}})
        ind.append({"type":"pause","duration":5})

    #feed the driver on the S Side:
    #always be ready to receive data:
    outd.append({'type':'read', "duration":1000})

    #for i in range(500):
    #    await ReadOnly()
    #    print("CYCLE", i)
    #    print("cur_idx    = ", dut.cur_idx.value)
    #    print("a_val[0]   = ", dut.a_val[0].value)
    #    print("a_ready    = ", dut.a_ready.value)
    #    print("ready      = ", dut.s00_axis_tready.value)
    #    print("best_match = ", dut.best_match.value)
    #    await ClockCycles(dut.s00_axis_aclk, 1)

    await ClockCycles(dut.s00_axis_aclk, 1000)
    assert inm.transactions==outm.transactions, f"Transaction Count doesn't match! :-/ {inm.transactions} vs {outm.transactions}"

#@cocotb.test()
#async def test_b(dut):
#    """cocotb test for AXIS fir with sporadic backpressure"""
#
#    inm = AXIS_Monitor(dut,'s00',dut.s00_axis_aclk,callback=make_nn_model())
#    outm = AXIS_Monitor(dut,'m00',dut.s00_axis_aclk,callback=lambda x: sig_out_act.append(x))
#    ind = M_AXIS_Driver(dut,'s00',dut.s00_axis_aclk) #M driver for S port
#    outd = S_AXIS_Driver(dut,'m00',dut.s00_axis_aclk) #S driver for M port
#
#    # Create a scoreboard on the stream_out bus
#    scoreboard = Scoreboard(dut,fail_immediately=False)
#    scoreboard.add_interface(outm, sig_out_exp)
#    cocotb.start_soon(Clock(dut.s00_axis_aclk, 10, units="ns").start())
#    await reset(dut.s00_axis_aclk, dut.s00_axis_aresetn,2,0)
#
#    #feed the driver on the M Side:
#    for i in range(50):
#        data = {'type':'write_single', "contents":{"data": Corner.random().to_int(),"last":0}}
#        ind.append(data)
#        pause = {"type":"pause","duration":random.randint(1,6)}
#        ind.append(pause)
#    ind.append({'type':'write_burst', "contents": {"data": np.array([Corner.random().to_int() for _ in range(100)])}})
#    ind.append({'type':'pause','duration':2}) #end with pause
#    #feed the driver on the S Side with on/off backpressure!
#    for i in range(50):
#        outd.append({'type':'read', "duration":random.randint(1,10)})
#        outd.append({'type':'pause', "duration":random.randint(1,10)})
#    await ClockCycles(dut.s00_axis_aclk, 500)
#    assert inm.transactions==outm.transactions, f"Transaction Count doesn't match! :/"

def nn_runner():
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sys.path.append(str(proj_path / "sim" / "model"))
    sys.path.append(str(proj_path / "hdl" ))
    sources = [proj_path / "hdl" / "nn.sv"]
    build_test_args = ["-Wall", "-g2012"]
    parameters = {} #!!!
    sys.path.append(str(proj_path / "sim"))
    runner = get_runner(sim)
    hdl_toplevel = "nn"
    runner.build(
        sources=sources,
        hdl_toplevel=hdl_toplevel, #fir_15
        always=True,
        build_args=build_test_args,
        parameters=parameters,
        timescale = ('1ns','1ps'),
        waves=True
    )
    run_test_args = []
    runner.test(
        hdl_toplevel=hdl_toplevel, #fir_15
        test_module=test_file,
        test_args=run_test_args,
        waves=True
    )
if __name__ == "__main__":
    nn_runner()
