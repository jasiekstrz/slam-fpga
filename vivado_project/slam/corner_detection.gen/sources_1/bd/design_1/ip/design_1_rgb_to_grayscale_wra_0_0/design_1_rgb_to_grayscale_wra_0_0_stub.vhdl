-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
-- Date        : Mon Dec  8 21:19:22 2025
-- Host        : eecs-digital-47 running 64-bit Ubuntu 24.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/jstrz/slam/corner_detection.gen/sources_1/bd/design_1/ip/design_1_rgb_to_grayscale_wra_0_0/design_1_rgb_to_grayscale_wra_0_0_stub.vhdl
-- Design      : design_1_rgb_to_grayscale_wra_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_rgb_to_grayscale_wra_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    pixel_data : in STD_LOGIC_VECTOR ( 23 downto 0 );
    hsync_in : in STD_LOGIC;
    vsync_in : in STD_LOGIC;
    vde_in : in STD_LOGIC;
    grayscale : out STD_LOGIC_VECTOR ( 7 downto 0 );
    hsync_out : out STD_LOGIC;
    vsync_out : out STD_LOGIC;
    vde_out : out STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_rgb_to_grayscale_wra_0_0 : entity is "design_1_rgb_to_grayscale_wra_0_0,rgb_to_grayscale_wrapper,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1_rgb_to_grayscale_wra_0_0 : entity is "design_1_rgb_to_grayscale_wra_0_0,rgb_to_grayscale_wrapper,{x_ipProduct=Vivado 2025.1,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=rgb_to_grayscale_wrapper,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_rgb_to_grayscale_wra_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_1_rgb_to_grayscale_wra_0_0 : entity is "module_ref";
end design_1_rgb_to_grayscale_wra_0_0;

architecture stub of design_1_rgb_to_grayscale_wra_0_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "clk,pixel_data[23:0],hsync_in,vsync_in,vde_in,grayscale[7:0],hsync_out,vsync_out,vde_out";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_dvi2rgb_0_0_PixelClk, INSERT_VIP 0";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "rgb_to_grayscale_wrapper,Vivado 2025.1";
begin
end;
