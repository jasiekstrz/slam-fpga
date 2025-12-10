-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
-- Date        : Mon Dec  8 21:19:33 2025
-- Host        : eecs-digital-47 running 64-bit Ubuntu 24.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/jstrz/slam/corner_detection.gen/sources_1/bd/design_1/ip/design_1_tristate_0_1/design_1_tristate_0_1_stub.vhdl
-- Design      : design_1_tristate_0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_tristate_0_1 is
  Port ( 
    i : in STD_LOGIC;
    t : in STD_LOGIC;
    oi : inout STD_LOGIC;
    o : out STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_tristate_0_1 : entity is "design_1_tristate_0_1,tristate,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1_tristate_0_1 : entity is "design_1_tristate_0_1,tristate,{x_ipProduct=Vivado 2025.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=tristate,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_tristate_0_1 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_1_tristate_0_1 : entity is "module_ref";
end design_1_tristate_0_1;

architecture stub of design_1_tristate_0_1 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "i,t,oi,o";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "tristate,Vivado 2025.1";
begin
end;
