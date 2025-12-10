-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
-- Date        : Mon Dec  8 21:19:22 2025
-- Host        : eecs-digital-47 running 64-bit Ubuntu 24.04.3 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/jstrz/slam/corner_detection.gen/sources_1/bd/design_1/ip/design_1_rgb_to_grayscale_wra_0_0/design_1_rgb_to_grayscale_wra_0_0_sim_netlist.vhdl
-- Design      : design_1_rgb_to_grayscale_wra_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_rgb_to_grayscale_wra_0_0_rgb_to_grayscale_wrapper is
  port (
    grayscale : out STD_LOGIC_VECTOR ( 7 downto 0 );
    hsync_out : out STD_LOGIC;
    vsync_out : out STD_LOGIC;
    vde_out : out STD_LOGIC;
    pixel_data : in STD_LOGIC_VECTOR ( 23 downto 0 );
    clk : in STD_LOGIC;
    hsync_in : in STD_LOGIC;
    vsync_in : in STD_LOGIC;
    vde_in : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_rgb_to_grayscale_wra_0_0_rgb_to_grayscale_wrapper : entity is "rgb_to_grayscale_wrapper";
end design_1_rgb_to_grayscale_wra_0_0_rgb_to_grayscale_wrapper;

architecture STRUCTURE of design_1_rgb_to_grayscale_wra_0_0_rgb_to_grayscale_wrapper is
  signal C : STD_LOGIC_VECTOR ( 14 downto 2 );
  signal b_weighted : STD_LOGIC_VECTOR ( 12 downto 1 );
  signal b_weighted0 : STD_LOGIC_VECTOR ( 12 downto 1 );
  signal \b_weighted[10]_i_11_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_12_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_13_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_2_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_3_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_4_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_5_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_6_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_7_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_8_n_0\ : STD_LOGIC;
  signal \b_weighted[10]_i_9_n_0\ : STD_LOGIC;
  signal \b_weighted[12]_i_2_n_0\ : STD_LOGIC;
  signal \b_weighted[12]_i_3_n_0\ : STD_LOGIC;
  signal \b_weighted[12]_i_4_n_0\ : STD_LOGIC;
  signal \b_weighted[2]_i_2_n_0\ : STD_LOGIC;
  signal \b_weighted[2]_i_3_n_0\ : STD_LOGIC;
  signal \b_weighted[2]_i_4_n_0\ : STD_LOGIC;
  signal \b_weighted[6]_i_2_n_0\ : STD_LOGIC;
  signal \b_weighted[6]_i_3_n_0\ : STD_LOGIC;
  signal \b_weighted[6]_i_4_n_0\ : STD_LOGIC;
  signal \b_weighted[6]_i_5_n_0\ : STD_LOGIC;
  signal \b_weighted[6]_i_6_n_0\ : STD_LOGIC;
  signal \b_weighted[6]_i_7_n_0\ : STD_LOGIC;
  signal \b_weighted[6]_i_8_n_0\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_10_n_0\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_10_n_1\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_10_n_2\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_10_n_3\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_10_n_4\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_10_n_5\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_10_n_6\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_10_n_7\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_1_n_0\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_1_n_1\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_1_n_2\ : STD_LOGIC;
  signal \b_weighted_reg[10]_i_1_n_3\ : STD_LOGIC;
  signal \b_weighted_reg[12]_i_1_n_3\ : STD_LOGIC;
  signal \b_weighted_reg[12]_i_5_n_2\ : STD_LOGIC;
  signal \b_weighted_reg[12]_i_5_n_7\ : STD_LOGIC;
  signal \b_weighted_reg[2]_i_1_n_0\ : STD_LOGIC;
  signal \b_weighted_reg[2]_i_1_n_1\ : STD_LOGIC;
  signal \b_weighted_reg[2]_i_1_n_2\ : STD_LOGIC;
  signal \b_weighted_reg[2]_i_1_n_3\ : STD_LOGIC;
  signal \b_weighted_reg[2]_i_1_n_4\ : STD_LOGIC;
  signal \b_weighted_reg[2]_i_1_n_5\ : STD_LOGIC;
  signal \b_weighted_reg[6]_i_1_n_0\ : STD_LOGIC;
  signal \b_weighted_reg[6]_i_1_n_1\ : STD_LOGIC;
  signal \b_weighted_reg[6]_i_1_n_2\ : STD_LOGIC;
  signal \b_weighted_reg[6]_i_1_n_3\ : STD_LOGIC;
  signal g_weighted : STD_LOGIC_VECTOR ( 15 downto 1 );
  signal g_weighted0 : STD_LOGIC_VECTOR ( 15 downto 1 );
  signal \g_weighted[10]_i_2_n_0\ : STD_LOGIC;
  signal \g_weighted[10]_i_3_n_0\ : STD_LOGIC;
  signal \g_weighted[10]_i_4_n_0\ : STD_LOGIC;
  signal \g_weighted[10]_i_5_n_0\ : STD_LOGIC;
  signal \g_weighted[10]_i_6_n_0\ : STD_LOGIC;
  signal \g_weighted[10]_i_7_n_0\ : STD_LOGIC;
  signal \g_weighted[10]_i_8_n_0\ : STD_LOGIC;
  signal \g_weighted[14]_i_2_n_0\ : STD_LOGIC;
  signal \g_weighted[14]_i_3_n_0\ : STD_LOGIC;
  signal \g_weighted[14]_i_4_n_0\ : STD_LOGIC;
  signal \g_weighted[14]_i_5_n_0\ : STD_LOGIC;
  signal \g_weighted[14]_i_6_n_0\ : STD_LOGIC;
  signal \g_weighted[14]_i_7_n_0\ : STD_LOGIC;
  signal \g_weighted[14]_i_8_n_0\ : STD_LOGIC;
  signal \g_weighted[14]_i_9_n_0\ : STD_LOGIC;
  signal \g_weighted[15]_i_2_n_0\ : STD_LOGIC;
  signal \g_weighted[15]_i_4_n_0\ : STD_LOGIC;
  signal \g_weighted[15]_i_5_n_0\ : STD_LOGIC;
  signal \g_weighted[2]_i_2_n_0\ : STD_LOGIC;
  signal \g_weighted[2]_i_3_n_0\ : STD_LOGIC;
  signal \g_weighted[2]_i_4_n_0\ : STD_LOGIC;
  signal \g_weighted[6]_i_3_n_0\ : STD_LOGIC;
  signal \g_weighted[6]_i_4_n_0\ : STD_LOGIC;
  signal \g_weighted[6]_i_5_n_0\ : STD_LOGIC;
  signal \g_weighted[6]_i_6_n_0\ : STD_LOGIC;
  signal \g_weighted[6]_i_7_n_0\ : STD_LOGIC;
  signal \g_weighted[6]_i_8_n_0\ : STD_LOGIC;
  signal \g_weighted[6]_i_9_n_0\ : STD_LOGIC;
  signal \g_weighted_reg[10]_i_1_n_0\ : STD_LOGIC;
  signal \g_weighted_reg[10]_i_1_n_1\ : STD_LOGIC;
  signal \g_weighted_reg[10]_i_1_n_2\ : STD_LOGIC;
  signal \g_weighted_reg[10]_i_1_n_3\ : STD_LOGIC;
  signal \g_weighted_reg[14]_i_1_n_0\ : STD_LOGIC;
  signal \g_weighted_reg[14]_i_1_n_1\ : STD_LOGIC;
  signal \g_weighted_reg[14]_i_1_n_2\ : STD_LOGIC;
  signal \g_weighted_reg[14]_i_1_n_3\ : STD_LOGIC;
  signal \g_weighted_reg[15]_i_3_n_1\ : STD_LOGIC;
  signal \g_weighted_reg[15]_i_3_n_3\ : STD_LOGIC;
  signal \g_weighted_reg[15]_i_3_n_6\ : STD_LOGIC;
  signal \g_weighted_reg[15]_i_3_n_7\ : STD_LOGIC;
  signal \g_weighted_reg[2]_i_1_n_0\ : STD_LOGIC;
  signal \g_weighted_reg[2]_i_1_n_1\ : STD_LOGIC;
  signal \g_weighted_reg[2]_i_1_n_2\ : STD_LOGIC;
  signal \g_weighted_reg[2]_i_1_n_3\ : STD_LOGIC;
  signal \g_weighted_reg[2]_i_1_n_4\ : STD_LOGIC;
  signal \g_weighted_reg[2]_i_1_n_5\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_1_n_0\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_1_n_1\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_1_n_2\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_1_n_3\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_2_n_0\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_2_n_1\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_2_n_2\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_2_n_3\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_2_n_4\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_2_n_5\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_2_n_6\ : STD_LOGIC;
  signal \g_weighted_reg[6]_i_2_n_7\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_10_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_10_n_1\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_10_n_2\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_10_n_3\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_11_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_12_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_13_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_14_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_1_n_1\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_1_n_2\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_1_n_3\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_5_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_6_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_7_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_8_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_i_9_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_n_0\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_n_1\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_n_2\ : STD_LOGIC;
  signal \grayscale[0]_INST_0_n_3\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_5_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_5_n_1\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_5_n_2\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_5_n_3\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_6_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_7_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_8_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_i_9_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_n_0\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_n_1\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_n_2\ : STD_LOGIC;
  signal \grayscale[1]_INST_0_n_3\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_4_n_2\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_5_n_0\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_5_n_1\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_5_n_2\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_5_n_3\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_6_n_0\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_7_n_0\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_i_8_n_0\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_n_2\ : STD_LOGIC;
  signal \grayscale[5]_INST_0_n_3\ : STD_LOGIC;
  signal r_weighted : STD_LOGIC_VECTOR ( 14 downto 2 );
  signal r_weighted0 : STD_LOGIC_VECTOR ( 14 downto 2 );
  signal \r_weighted[13]_i_2_n_0\ : STD_LOGIC;
  signal \r_weighted[13]_i_3_n_0\ : STD_LOGIC;
  signal \r_weighted[13]_i_4_n_0\ : STD_LOGIC;
  signal \r_weighted[13]_i_5_n_0\ : STD_LOGIC;
  signal \r_weighted[13]_i_6_n_0\ : STD_LOGIC;
  signal \r_weighted[13]_i_7_n_0\ : STD_LOGIC;
  signal \r_weighted[13]_i_8_n_0\ : STD_LOGIC;
  signal \r_weighted[14]_i_2_n_0\ : STD_LOGIC;
  signal \r_weighted[5]_i_2_n_0\ : STD_LOGIC;
  signal \r_weighted[5]_i_3_n_0\ : STD_LOGIC;
  signal \r_weighted[5]_i_4_n_0\ : STD_LOGIC;
  signal \r_weighted[9]_i_2_n_0\ : STD_LOGIC;
  signal \r_weighted[9]_i_3_n_0\ : STD_LOGIC;
  signal \r_weighted[9]_i_4_n_0\ : STD_LOGIC;
  signal \r_weighted[9]_i_5_n_0\ : STD_LOGIC;
  signal \r_weighted[9]_i_6_n_0\ : STD_LOGIC;
  signal \r_weighted[9]_i_7_n_0\ : STD_LOGIC;
  signal \r_weighted[9]_i_8_n_0\ : STD_LOGIC;
  signal \r_weighted_reg[13]_i_1_n_0\ : STD_LOGIC;
  signal \r_weighted_reg[13]_i_1_n_1\ : STD_LOGIC;
  signal \r_weighted_reg[13]_i_1_n_2\ : STD_LOGIC;
  signal \r_weighted_reg[13]_i_1_n_3\ : STD_LOGIC;
  signal \r_weighted_reg[5]_i_1_n_0\ : STD_LOGIC;
  signal \r_weighted_reg[5]_i_1_n_1\ : STD_LOGIC;
  signal \r_weighted_reg[5]_i_1_n_2\ : STD_LOGIC;
  signal \r_weighted_reg[5]_i_1_n_3\ : STD_LOGIC;
  signal \r_weighted_reg[9]_i_1_n_0\ : STD_LOGIC;
  signal \r_weighted_reg[9]_i_1_n_1\ : STD_LOGIC;
  signal \r_weighted_reg[9]_i_1_n_2\ : STD_LOGIC;
  signal \r_weighted_reg[9]_i_1_n_3\ : STD_LOGIC;
  signal \NLW_b_weighted_reg[12]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_b_weighted_reg[12]_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_b_weighted_reg[12]_i_5_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_b_weighted_reg[12]_i_5_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_g_weighted_reg[15]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_g_weighted_reg[15]_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_g_weighted_reg[15]_i_3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_g_weighted_reg[15]_i_3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_grayscale[0]_INST_0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_grayscale[0]_INST_0_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_grayscale[5]_INST_0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_grayscale[5]_INST_0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_grayscale[5]_INST_0_i_4_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_grayscale[5]_INST_0_i_4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_r_weighted_reg[14]_i_1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_r_weighted_reg[14]_i_1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \b_weighted_reg[10]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS : string;
  attribute METHODOLOGY_DRC_VIOS of \b_weighted_reg[10]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x5}}";
  attribute METHODOLOGY_DRC_VIOS of \b_weighted_reg[10]_i_10\ : label is "{SYNTH-9 {cell *THIS*} {string 8x5}}";
  attribute ADDER_THRESHOLD of \b_weighted_reg[12]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \b_weighted_reg[12]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x5}}";
  attribute METHODOLOGY_DRC_VIOS of \b_weighted_reg[12]_i_5\ : label is "{SYNTH-9 {cell *THIS*} {string 8x5}}";
  attribute METHODOLOGY_DRC_VIOS of \b_weighted_reg[2]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x5}}";
  attribute ADDER_THRESHOLD of \b_weighted_reg[6]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \b_weighted_reg[6]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x5}}";
  attribute HLUTNM : string;
  attribute HLUTNM of \g_weighted[10]_i_2\ : label is "lutpair1";
  attribute HLUTNM of \g_weighted[10]_i_3\ : label is "lutpair0";
  attribute HLUTNM of \g_weighted[10]_i_5\ : label is "lutpair2";
  attribute HLUTNM of \g_weighted[10]_i_6\ : label is "lutpair1";
  attribute HLUTNM of \g_weighted[10]_i_7\ : label is "lutpair0";
  attribute HLUTNM of \g_weighted[14]_i_5\ : label is "lutpair2";
  attribute ADDER_THRESHOLD of \g_weighted_reg[10]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \g_weighted_reg[10]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x8}}";
  attribute ADDER_THRESHOLD of \g_weighted_reg[14]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \g_weighted_reg[14]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x8}}";
  attribute ADDER_THRESHOLD of \g_weighted_reg[15]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \g_weighted_reg[15]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x8}}";
  attribute METHODOLOGY_DRC_VIOS of \g_weighted_reg[15]_i_3\ : label is "{SYNTH-9 {cell *THIS*} {string 8x8}}";
  attribute METHODOLOGY_DRC_VIOS of \g_weighted_reg[2]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x8}}";
  attribute ADDER_THRESHOLD of \g_weighted_reg[6]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \g_weighted_reg[6]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x8}}";
  attribute METHODOLOGY_DRC_VIOS of \g_weighted_reg[6]_i_2\ : label is "{SYNTH-9 {cell *THIS*} {string 8x8}}";
  attribute ADDER_THRESHOLD of \grayscale[0]_INST_0\ : label is 35;
  attribute ADDER_THRESHOLD of \grayscale[0]_INST_0_i_1\ : label is 35;
  attribute ADDER_THRESHOLD of \grayscale[1]_INST_0\ : label is 35;
  attribute ADDER_THRESHOLD of \grayscale[5]_INST_0\ : label is 35;
  attribute ADDER_THRESHOLD of \r_weighted_reg[13]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \r_weighted_reg[13]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x7}}";
  attribute ADDER_THRESHOLD of \r_weighted_reg[14]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \r_weighted_reg[14]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x7}}";
  attribute ADDER_THRESHOLD of \r_weighted_reg[5]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \r_weighted_reg[5]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x7}}";
  attribute ADDER_THRESHOLD of \r_weighted_reg[9]_i_1\ : label is 35;
  attribute METHODOLOGY_DRC_VIOS of \r_weighted_reg[9]_i_1\ : label is "{SYNTH-9 {cell *THIS*} {string 8x7}}";
begin
\b_weighted[10]_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => pixel_data(7),
      I1 => pixel_data(5),
      O => \b_weighted[10]_i_11_n_0\
    );
\b_weighted[10]_i_12\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => pixel_data(6),
      I1 => pixel_data(4),
      O => \b_weighted[10]_i_12_n_0\
    );
\b_weighted[10]_i_13\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => pixel_data(5),
      I1 => pixel_data(3),
      O => \b_weighted[10]_i_13_n_0\
    );
\b_weighted[10]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => pixel_data(6),
      I1 => \b_weighted_reg[12]_i_5_n_7\,
      I2 => pixel_data(4),
      O => \b_weighted[10]_i_2_n_0\
    );
\b_weighted[10]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => pixel_data(5),
      I1 => \b_weighted_reg[10]_i_10_n_4\,
      I2 => pixel_data(3),
      O => \b_weighted[10]_i_3_n_0\
    );
\b_weighted[10]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => pixel_data(4),
      I1 => \b_weighted_reg[10]_i_10_n_5\,
      I2 => pixel_data(2),
      O => \b_weighted[10]_i_4_n_0\
    );
\b_weighted[10]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => pixel_data(3),
      I1 => \b_weighted_reg[10]_i_10_n_6\,
      I2 => pixel_data(1),
      O => \b_weighted[10]_i_5_n_0\
    );
\b_weighted[10]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8E71718E718E8E71"
    )
        port map (
      I0 => pixel_data(4),
      I1 => \b_weighted_reg[12]_i_5_n_7\,
      I2 => pixel_data(6),
      I3 => pixel_data(7),
      I4 => \b_weighted_reg[12]_i_5_n_2\,
      I5 => pixel_data(5),
      O => \b_weighted[10]_i_6_n_0\
    );
\b_weighted[10]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8E71718E718E8E71"
    )
        port map (
      I0 => pixel_data(3),
      I1 => \b_weighted_reg[10]_i_10_n_4\,
      I2 => pixel_data(5),
      I3 => pixel_data(6),
      I4 => \b_weighted_reg[12]_i_5_n_7\,
      I5 => pixel_data(4),
      O => \b_weighted[10]_i_7_n_0\
    );
\b_weighted[10]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8E71718E718E8E71"
    )
        port map (
      I0 => pixel_data(2),
      I1 => \b_weighted_reg[10]_i_10_n_5\,
      I2 => pixel_data(4),
      I3 => pixel_data(5),
      I4 => \b_weighted_reg[10]_i_10_n_4\,
      I5 => pixel_data(3),
      O => \b_weighted[10]_i_8_n_0\
    );
\b_weighted[10]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8E71718E718E8E71"
    )
        port map (
      I0 => pixel_data(1),
      I1 => \b_weighted_reg[10]_i_10_n_6\,
      I2 => pixel_data(3),
      I3 => pixel_data(4),
      I4 => \b_weighted_reg[10]_i_10_n_5\,
      I5 => pixel_data(2),
      O => \b_weighted[10]_i_9_n_0\
    );
\b_weighted[12]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => pixel_data(7),
      I1 => \b_weighted_reg[12]_i_5_n_2\,
      I2 => pixel_data(5),
      O => \b_weighted[12]_i_2_n_0\
    );
\b_weighted[12]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(6),
      I1 => pixel_data(7),
      O => \b_weighted[12]_i_3_n_0\
    );
\b_weighted[12]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8E71"
    )
        port map (
      I0 => pixel_data(5),
      I1 => \b_weighted_reg[12]_i_5_n_2\,
      I2 => pixel_data(7),
      I3 => pixel_data(6),
      O => \b_weighted[12]_i_4_n_0\
    );
\b_weighted[2]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => pixel_data(4),
      I1 => pixel_data(2),
      O => \b_weighted[2]_i_2_n_0\
    );
\b_weighted[2]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => pixel_data(3),
      I1 => pixel_data(1),
      O => \b_weighted[2]_i_3_n_0\
    );
\b_weighted[2]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => pixel_data(2),
      I1 => pixel_data(0),
      O => \b_weighted[2]_i_4_n_0\
    );
\b_weighted[6]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => pixel_data(2),
      I1 => \b_weighted_reg[10]_i_10_n_7\,
      I2 => pixel_data(0),
      O => \b_weighted[6]_i_2_n_0\
    );
\b_weighted[6]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => pixel_data(2),
      I1 => \b_weighted_reg[10]_i_10_n_7\,
      I2 => pixel_data(0),
      O => \b_weighted[6]_i_3_n_0\
    );
\b_weighted[6]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \b_weighted_reg[2]_i_1_n_5\,
      I1 => pixel_data(0),
      O => \b_weighted[6]_i_4_n_0\
    );
\b_weighted[6]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8E71718E718E8E71"
    )
        port map (
      I0 => pixel_data(0),
      I1 => \b_weighted_reg[10]_i_10_n_7\,
      I2 => pixel_data(2),
      I3 => pixel_data(3),
      I4 => \b_weighted_reg[10]_i_10_n_6\,
      I5 => pixel_data(1),
      O => \b_weighted[6]_i_5_n_0\
    );
\b_weighted[6]_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69966969"
    )
        port map (
      I0 => pixel_data(2),
      I1 => \b_weighted_reg[10]_i_10_n_7\,
      I2 => pixel_data(0),
      I3 => pixel_data(1),
      I4 => \b_weighted_reg[2]_i_1_n_4\,
      O => \b_weighted[6]_i_6_n_0\
    );
\b_weighted[6]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2DD2"
    )
        port map (
      I0 => pixel_data(0),
      I1 => \b_weighted_reg[2]_i_1_n_5\,
      I2 => \b_weighted_reg[2]_i_1_n_4\,
      I3 => pixel_data(1),
      O => \b_weighted[6]_i_7_n_0\
    );
\b_weighted[6]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => pixel_data(0),
      I1 => \b_weighted_reg[2]_i_1_n_5\,
      O => \b_weighted[6]_i_8_n_0\
    );
\b_weighted_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(10),
      Q => b_weighted(10),
      R => '0'
    );
\b_weighted_reg[10]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \b_weighted_reg[6]_i_1_n_0\,
      CO(3) => \b_weighted_reg[10]_i_1_n_0\,
      CO(2) => \b_weighted_reg[10]_i_1_n_1\,
      CO(1) => \b_weighted_reg[10]_i_1_n_2\,
      CO(0) => \b_weighted_reg[10]_i_1_n_3\,
      CYINIT => '0',
      DI(3) => \b_weighted[10]_i_2_n_0\,
      DI(2) => \b_weighted[10]_i_3_n_0\,
      DI(1) => \b_weighted[10]_i_4_n_0\,
      DI(0) => \b_weighted[10]_i_5_n_0\,
      O(3 downto 0) => b_weighted0(10 downto 7),
      S(3) => \b_weighted[10]_i_6_n_0\,
      S(2) => \b_weighted[10]_i_7_n_0\,
      S(1) => \b_weighted[10]_i_8_n_0\,
      S(0) => \b_weighted[10]_i_9_n_0\
    );
\b_weighted_reg[10]_i_10\: unisim.vcomponents.CARRY4
     port map (
      CI => \b_weighted_reg[2]_i_1_n_0\,
      CO(3) => \b_weighted_reg[10]_i_10_n_0\,
      CO(2) => \b_weighted_reg[10]_i_10_n_1\,
      CO(1) => \b_weighted_reg[10]_i_10_n_2\,
      CO(0) => \b_weighted_reg[10]_i_10_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2 downto 0) => pixel_data(7 downto 5),
      O(3) => \b_weighted_reg[10]_i_10_n_4\,
      O(2) => \b_weighted_reg[10]_i_10_n_5\,
      O(1) => \b_weighted_reg[10]_i_10_n_6\,
      O(0) => \b_weighted_reg[10]_i_10_n_7\,
      S(3) => pixel_data(6),
      S(2) => \b_weighted[10]_i_11_n_0\,
      S(1) => \b_weighted[10]_i_12_n_0\,
      S(0) => \b_weighted[10]_i_13_n_0\
    );
\b_weighted_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(11),
      Q => b_weighted(11),
      R => '0'
    );
\b_weighted_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(12),
      Q => b_weighted(12),
      R => '0'
    );
\b_weighted_reg[12]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \b_weighted_reg[10]_i_1_n_0\,
      CO(3 downto 1) => \NLW_b_weighted_reg[12]_i_1_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \b_weighted_reg[12]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \b_weighted[12]_i_2_n_0\,
      O(3 downto 2) => \NLW_b_weighted_reg[12]_i_1_O_UNCONNECTED\(3 downto 2),
      O(1 downto 0) => b_weighted0(12 downto 11),
      S(3 downto 2) => B"00",
      S(1) => \b_weighted[12]_i_3_n_0\,
      S(0) => \b_weighted[12]_i_4_n_0\
    );
\b_weighted_reg[12]_i_5\: unisim.vcomponents.CARRY4
     port map (
      CI => \b_weighted_reg[10]_i_10_n_0\,
      CO(3 downto 2) => \NLW_b_weighted_reg[12]_i_5_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \b_weighted_reg[12]_i_5_n_2\,
      CO(0) => \NLW_b_weighted_reg[12]_i_5_CO_UNCONNECTED\(0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_b_weighted_reg[12]_i_5_O_UNCONNECTED\(3 downto 1),
      O(0) => \b_weighted_reg[12]_i_5_n_7\,
      S(3 downto 1) => B"001",
      S(0) => pixel_data(7)
    );
\b_weighted_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(1),
      Q => b_weighted(1),
      R => '0'
    );
\b_weighted_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(2),
      Q => b_weighted(2),
      R => '0'
    );
\b_weighted_reg[2]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \b_weighted_reg[2]_i_1_n_0\,
      CO(2) => \b_weighted_reg[2]_i_1_n_1\,
      CO(1) => \b_weighted_reg[2]_i_1_n_2\,
      CO(0) => \b_weighted_reg[2]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => pixel_data(4 downto 2),
      DI(0) => '0',
      O(3) => \b_weighted_reg[2]_i_1_n_4\,
      O(2) => \b_weighted_reg[2]_i_1_n_5\,
      O(1 downto 0) => b_weighted0(2 downto 1),
      S(3) => \b_weighted[2]_i_2_n_0\,
      S(2) => \b_weighted[2]_i_3_n_0\,
      S(1) => \b_weighted[2]_i_4_n_0\,
      S(0) => pixel_data(1)
    );
\b_weighted_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(3),
      Q => b_weighted(3),
      R => '0'
    );
\b_weighted_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(4),
      Q => b_weighted(4),
      R => '0'
    );
\b_weighted_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(5),
      Q => b_weighted(5),
      R => '0'
    );
\b_weighted_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(6),
      Q => b_weighted(6),
      R => '0'
    );
\b_weighted_reg[6]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \b_weighted_reg[6]_i_1_n_0\,
      CO(2) => \b_weighted_reg[6]_i_1_n_1\,
      CO(1) => \b_weighted_reg[6]_i_1_n_2\,
      CO(0) => \b_weighted_reg[6]_i_1_n_3\,
      CYINIT => '0',
      DI(3) => \b_weighted[6]_i_2_n_0\,
      DI(2) => \b_weighted[6]_i_3_n_0\,
      DI(1) => \b_weighted[6]_i_4_n_0\,
      DI(0) => '0',
      O(3 downto 0) => b_weighted0(6 downto 3),
      S(3) => \b_weighted[6]_i_5_n_0\,
      S(2) => \b_weighted[6]_i_6_n_0\,
      S(1) => \b_weighted[6]_i_7_n_0\,
      S(0) => \b_weighted[6]_i_8_n_0\
    );
\b_weighted_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(7),
      Q => b_weighted(7),
      R => '0'
    );
\b_weighted_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(8),
      Q => b_weighted(8),
      R => '0'
    );
\b_weighted_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => b_weighted0(9),
      Q => b_weighted(9),
      R => '0'
    );
\g_weighted[10]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => pixel_data(13),
      I1 => \g_weighted_reg[15]_i_3_n_7\,
      I2 => pixel_data(10),
      O => \g_weighted[10]_i_2_n_0\
    );
\g_weighted[10]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => pixel_data(12),
      I1 => \g_weighted_reg[6]_i_2_n_4\,
      I2 => pixel_data(9),
      O => \g_weighted[10]_i_3_n_0\
    );
\g_weighted[10]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => pixel_data(9),
      I1 => pixel_data(12),
      I2 => \g_weighted_reg[6]_i_2_n_4\,
      O => \g_weighted[10]_i_4_n_0\
    );
\g_weighted[10]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => pixel_data(14),
      I1 => \g_weighted_reg[15]_i_3_n_6\,
      I2 => pixel_data(11),
      I3 => \g_weighted[10]_i_2_n_0\,
      O => \g_weighted[10]_i_5_n_0\
    );
\g_weighted[10]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => pixel_data(13),
      I1 => \g_weighted_reg[15]_i_3_n_7\,
      I2 => pixel_data(10),
      I3 => \g_weighted[10]_i_3_n_0\,
      O => \g_weighted[10]_i_6_n_0\
    );
\g_weighted[10]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969696"
    )
        port map (
      I0 => pixel_data(12),
      I1 => \g_weighted_reg[6]_i_2_n_4\,
      I2 => pixel_data(9),
      I3 => \g_weighted_reg[6]_i_2_n_5\,
      I4 => pixel_data(11),
      O => \g_weighted[10]_i_7_n_0\
    );
\g_weighted[10]_i_8\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => pixel_data(11),
      I1 => \g_weighted_reg[6]_i_2_n_5\,
      I2 => pixel_data(8),
      O => \g_weighted[10]_i_8_n_0\
    );
\g_weighted[14]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => pixel_data(14),
      I1 => \g_weighted_reg[15]_i_3_n_1\,
      O => \g_weighted[14]_i_2_n_0\
    );
\g_weighted[14]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => pixel_data(13),
      I1 => \g_weighted_reg[15]_i_3_n_1\,
      O => \g_weighted[14]_i_3_n_0\
    );
\g_weighted[14]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => \g_weighted_reg[15]_i_3_n_1\,
      I1 => pixel_data(15),
      I2 => pixel_data(12),
      O => \g_weighted[14]_i_4_n_0\
    );
\g_weighted[14]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => pixel_data(14),
      I1 => \g_weighted_reg[15]_i_3_n_6\,
      I2 => pixel_data(11),
      O => \g_weighted[14]_i_5_n_0\
    );
\g_weighted[14]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E1"
    )
        port map (
      I0 => pixel_data(14),
      I1 => \g_weighted_reg[15]_i_3_n_1\,
      I2 => pixel_data(15),
      O => \g_weighted[14]_i_6_n_0\
    );
\g_weighted[14]_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E1"
    )
        port map (
      I0 => pixel_data(13),
      I1 => \g_weighted_reg[15]_i_3_n_1\,
      I2 => pixel_data(14),
      O => \g_weighted[14]_i_7_n_0\
    );
\g_weighted[14]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7E81"
    )
        port map (
      I0 => pixel_data(12),
      I1 => pixel_data(15),
      I2 => \g_weighted_reg[15]_i_3_n_1\,
      I3 => pixel_data(13),
      O => \g_weighted[14]_i_8_n_0\
    );
\g_weighted[14]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => \g_weighted[14]_i_5_n_0\,
      I1 => \g_weighted_reg[15]_i_3_n_1\,
      I2 => pixel_data(15),
      I3 => pixel_data(12),
      O => \g_weighted[14]_i_9_n_0\
    );
\g_weighted[15]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => pixel_data(15),
      I1 => \g_weighted_reg[15]_i_3_n_1\,
      O => \g_weighted[15]_i_2_n_0\
    );
\g_weighted[15]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => pixel_data(15),
      O => \g_weighted[15]_i_4_n_0\
    );
\g_weighted[15]_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => pixel_data(14),
      O => \g_weighted[15]_i_5_n_0\
    );
\g_weighted[2]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(9),
      I1 => pixel_data(11),
      O => \g_weighted[2]_i_2_n_0\
    );
\g_weighted[2]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(8),
      I1 => pixel_data(10),
      O => \g_weighted[2]_i_3_n_0\
    );
\g_weighted[2]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => pixel_data(9),
      O => \g_weighted[2]_i_4_n_0\
    );
\g_weighted[6]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \g_weighted_reg[6]_i_2_n_6\,
      I1 => pixel_data(10),
      O => \g_weighted[6]_i_3_n_0\
    );
\g_weighted[6]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \g_weighted_reg[6]_i_2_n_7\,
      I1 => pixel_data(9),
      O => \g_weighted[6]_i_4_n_0\
    );
\g_weighted[6]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \g_weighted_reg[2]_i_1_n_4\,
      I1 => pixel_data(8),
      O => \g_weighted[6]_i_5_n_0\
    );
\g_weighted[6]_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(13),
      I1 => pixel_data(15),
      O => \g_weighted[6]_i_6_n_0\
    );
\g_weighted[6]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(12),
      I1 => pixel_data(14),
      O => \g_weighted[6]_i_7_n_0\
    );
\g_weighted[6]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(11),
      I1 => pixel_data(13),
      O => \g_weighted[6]_i_8_n_0\
    );
\g_weighted[6]_i_9\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(10),
      I1 => pixel_data(12),
      O => \g_weighted[6]_i_9_n_0\
    );
\g_weighted_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(10),
      Q => g_weighted(10),
      R => '0'
    );
\g_weighted_reg[10]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \g_weighted_reg[6]_i_1_n_0\,
      CO(3) => \g_weighted_reg[10]_i_1_n_0\,
      CO(2) => \g_weighted_reg[10]_i_1_n_1\,
      CO(1) => \g_weighted_reg[10]_i_1_n_2\,
      CO(0) => \g_weighted_reg[10]_i_1_n_3\,
      CYINIT => '0',
      DI(3) => \g_weighted[10]_i_2_n_0\,
      DI(2) => \g_weighted[10]_i_3_n_0\,
      DI(1) => \g_weighted[10]_i_4_n_0\,
      DI(0) => pixel_data(8),
      O(3 downto 0) => g_weighted0(10 downto 7),
      S(3) => \g_weighted[10]_i_5_n_0\,
      S(2) => \g_weighted[10]_i_6_n_0\,
      S(1) => \g_weighted[10]_i_7_n_0\,
      S(0) => \g_weighted[10]_i_8_n_0\
    );
\g_weighted_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(11),
      Q => g_weighted(11),
      R => '0'
    );
\g_weighted_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(12),
      Q => g_weighted(12),
      R => '0'
    );
\g_weighted_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(13),
      Q => g_weighted(13),
      R => '0'
    );
\g_weighted_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(14),
      Q => g_weighted(14),
      R => '0'
    );
\g_weighted_reg[14]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \g_weighted_reg[10]_i_1_n_0\,
      CO(3) => \g_weighted_reg[14]_i_1_n_0\,
      CO(2) => \g_weighted_reg[14]_i_1_n_1\,
      CO(1) => \g_weighted_reg[14]_i_1_n_2\,
      CO(0) => \g_weighted_reg[14]_i_1_n_3\,
      CYINIT => '0',
      DI(3) => \g_weighted[14]_i_2_n_0\,
      DI(2) => \g_weighted[14]_i_3_n_0\,
      DI(1) => \g_weighted[14]_i_4_n_0\,
      DI(0) => \g_weighted[14]_i_5_n_0\,
      O(3 downto 0) => g_weighted0(14 downto 11),
      S(3) => \g_weighted[14]_i_6_n_0\,
      S(2) => \g_weighted[14]_i_7_n_0\,
      S(1) => \g_weighted[14]_i_8_n_0\,
      S(0) => \g_weighted[14]_i_9_n_0\
    );
\g_weighted_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(15),
      Q => g_weighted(15),
      R => '0'
    );
\g_weighted_reg[15]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \g_weighted_reg[14]_i_1_n_0\,
      CO(3 downto 0) => \NLW_g_weighted_reg[15]_i_1_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_g_weighted_reg[15]_i_1_O_UNCONNECTED\(3 downto 1),
      O(0) => g_weighted0(15),
      S(3 downto 1) => B"000",
      S(0) => \g_weighted[15]_i_2_n_0\
    );
\g_weighted_reg[15]_i_3\: unisim.vcomponents.CARRY4
     port map (
      CI => \g_weighted_reg[6]_i_2_n_0\,
      CO(3) => \NLW_g_weighted_reg[15]_i_3_CO_UNCONNECTED\(3),
      CO(2) => \g_weighted_reg[15]_i_3_n_1\,
      CO(1) => \NLW_g_weighted_reg[15]_i_3_CO_UNCONNECTED\(1),
      CO(0) => \g_weighted_reg[15]_i_3_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => pixel_data(15 downto 14),
      O(3 downto 2) => \NLW_g_weighted_reg[15]_i_3_O_UNCONNECTED\(3 downto 2),
      O(1) => \g_weighted_reg[15]_i_3_n_6\,
      O(0) => \g_weighted_reg[15]_i_3_n_7\,
      S(3 downto 2) => B"01",
      S(1) => \g_weighted[15]_i_4_n_0\,
      S(0) => \g_weighted[15]_i_5_n_0\
    );
\g_weighted_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(1),
      Q => g_weighted(1),
      R => '0'
    );
\g_weighted_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(2),
      Q => g_weighted(2),
      R => '0'
    );
\g_weighted_reg[2]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \g_weighted_reg[2]_i_1_n_0\,
      CO(2) => \g_weighted_reg[2]_i_1_n_1\,
      CO(1) => \g_weighted_reg[2]_i_1_n_2\,
      CO(0) => \g_weighted_reg[2]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => pixel_data(9 downto 8),
      DI(1 downto 0) => B"01",
      O(3) => \g_weighted_reg[2]_i_1_n_4\,
      O(2) => \g_weighted_reg[2]_i_1_n_5\,
      O(1 downto 0) => g_weighted0(2 downto 1),
      S(3) => \g_weighted[2]_i_2_n_0\,
      S(2) => \g_weighted[2]_i_3_n_0\,
      S(1) => \g_weighted[2]_i_4_n_0\,
      S(0) => pixel_data(8)
    );
\g_weighted_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(3),
      Q => g_weighted(3),
      R => '0'
    );
\g_weighted_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(4),
      Q => g_weighted(4),
      R => '0'
    );
\g_weighted_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(5),
      Q => g_weighted(5),
      R => '0'
    );
\g_weighted_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(6),
      Q => g_weighted(6),
      R => '0'
    );
\g_weighted_reg[6]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \g_weighted_reg[6]_i_1_n_0\,
      CO(2) => \g_weighted_reg[6]_i_1_n_1\,
      CO(1) => \g_weighted_reg[6]_i_1_n_2\,
      CO(0) => \g_weighted_reg[6]_i_1_n_3\,
      CYINIT => '0',
      DI(3) => \g_weighted_reg[6]_i_2_n_6\,
      DI(2) => \g_weighted_reg[6]_i_2_n_7\,
      DI(1) => \g_weighted_reg[2]_i_1_n_4\,
      DI(0) => '0',
      O(3 downto 0) => g_weighted0(6 downto 3),
      S(3) => \g_weighted[6]_i_3_n_0\,
      S(2) => \g_weighted[6]_i_4_n_0\,
      S(1) => \g_weighted[6]_i_5_n_0\,
      S(0) => \g_weighted_reg[2]_i_1_n_5\
    );
\g_weighted_reg[6]_i_2\: unisim.vcomponents.CARRY4
     port map (
      CI => \g_weighted_reg[2]_i_1_n_0\,
      CO(3) => \g_weighted_reg[6]_i_2_n_0\,
      CO(2) => \g_weighted_reg[6]_i_2_n_1\,
      CO(1) => \g_weighted_reg[6]_i_2_n_2\,
      CO(0) => \g_weighted_reg[6]_i_2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => pixel_data(13 downto 10),
      O(3) => \g_weighted_reg[6]_i_2_n_4\,
      O(2) => \g_weighted_reg[6]_i_2_n_5\,
      O(1) => \g_weighted_reg[6]_i_2_n_6\,
      O(0) => \g_weighted_reg[6]_i_2_n_7\,
      S(3) => \g_weighted[6]_i_6_n_0\,
      S(2) => \g_weighted[6]_i_7_n_0\,
      S(1) => \g_weighted[6]_i_8_n_0\,
      S(0) => \g_weighted[6]_i_9_n_0\
    );
\g_weighted_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(7),
      Q => g_weighted(7),
      R => '0'
    );
\g_weighted_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(8),
      Q => g_weighted(8),
      R => '0'
    );
\g_weighted_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => g_weighted0(9),
      Q => g_weighted(9),
      R => '0'
    );
\grayscale[0]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grayscale[0]_INST_0_i_1_n_0\,
      CO(3) => \grayscale[0]_INST_0_n_0\,
      CO(2) => \grayscale[0]_INST_0_n_1\,
      CO(1) => \grayscale[0]_INST_0_n_2\,
      CO(0) => \grayscale[0]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => g_weighted(8 downto 5),
      O(3) => grayscale(0),
      O(2 downto 0) => \NLW_grayscale[0]_INST_0_O_UNCONNECTED\(2 downto 0),
      S(3) => \grayscale[0]_INST_0_i_2_n_0\,
      S(2) => \grayscale[0]_INST_0_i_3_n_0\,
      S(1) => \grayscale[0]_INST_0_i_4_n_0\,
      S(0) => \grayscale[0]_INST_0_i_5_n_0\
    );
\grayscale[0]_INST_0_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \grayscale[0]_INST_0_i_1_n_0\,
      CO(2) => \grayscale[0]_INST_0_i_1_n_1\,
      CO(1) => \grayscale[0]_INST_0_i_1_n_2\,
      CO(0) => \grayscale[0]_INST_0_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => g_weighted(4 downto 1),
      O(3 downto 0) => \NLW_grayscale[0]_INST_0_i_1_O_UNCONNECTED\(3 downto 0),
      S(3) => \grayscale[0]_INST_0_i_6_n_0\,
      S(2) => \grayscale[0]_INST_0_i_7_n_0\,
      S(1) => \grayscale[0]_INST_0_i_8_n_0\,
      S(0) => \grayscale[0]_INST_0_i_9_n_0\
    );
\grayscale[0]_INST_0_i_10\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \grayscale[0]_INST_0_i_10_n_0\,
      CO(2) => \grayscale[0]_INST_0_i_10_n_1\,
      CO(1) => \grayscale[0]_INST_0_i_10_n_2\,
      CO(0) => \grayscale[0]_INST_0_i_10_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => b_weighted(5 downto 2),
      O(3 downto 0) => C(5 downto 2),
      S(3) => \grayscale[0]_INST_0_i_11_n_0\,
      S(2) => \grayscale[0]_INST_0_i_12_n_0\,
      S(1) => \grayscale[0]_INST_0_i_13_n_0\,
      S(0) => \grayscale[0]_INST_0_i_14_n_0\
    );
\grayscale[0]_INST_0_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(5),
      I1 => r_weighted(5),
      O => \grayscale[0]_INST_0_i_11_n_0\
    );
\grayscale[0]_INST_0_i_12\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(4),
      I1 => r_weighted(4),
      O => \grayscale[0]_INST_0_i_12_n_0\
    );
\grayscale[0]_INST_0_i_13\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(3),
      I1 => r_weighted(3),
      O => \grayscale[0]_INST_0_i_13_n_0\
    );
\grayscale[0]_INST_0_i_14\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(2),
      I1 => r_weighted(2),
      O => \grayscale[0]_INST_0_i_14_n_0\
    );
\grayscale[0]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(8),
      I1 => C(8),
      O => \grayscale[0]_INST_0_i_2_n_0\
    );
\grayscale[0]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(7),
      I1 => C(7),
      O => \grayscale[0]_INST_0_i_3_n_0\
    );
\grayscale[0]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(6),
      I1 => C(6),
      O => \grayscale[0]_INST_0_i_4_n_0\
    );
\grayscale[0]_INST_0_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(5),
      I1 => C(5),
      O => \grayscale[0]_INST_0_i_5_n_0\
    );
\grayscale[0]_INST_0_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(4),
      I1 => C(4),
      O => \grayscale[0]_INST_0_i_6_n_0\
    );
\grayscale[0]_INST_0_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(3),
      I1 => C(3),
      O => \grayscale[0]_INST_0_i_7_n_0\
    );
\grayscale[0]_INST_0_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(2),
      I1 => C(2),
      O => \grayscale[0]_INST_0_i_8_n_0\
    );
\grayscale[0]_INST_0_i_9\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(1),
      I1 => b_weighted(1),
      O => \grayscale[0]_INST_0_i_9_n_0\
    );
\grayscale[1]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grayscale[0]_INST_0_n_0\,
      CO(3) => \grayscale[1]_INST_0_n_0\,
      CO(2) => \grayscale[1]_INST_0_n_1\,
      CO(1) => \grayscale[1]_INST_0_n_2\,
      CO(0) => \grayscale[1]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => g_weighted(12 downto 9),
      O(3 downto 0) => grayscale(4 downto 1),
      S(3) => \grayscale[1]_INST_0_i_1_n_0\,
      S(2) => \grayscale[1]_INST_0_i_2_n_0\,
      S(1) => \grayscale[1]_INST_0_i_3_n_0\,
      S(0) => \grayscale[1]_INST_0_i_4_n_0\
    );
\grayscale[1]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(12),
      I1 => C(12),
      O => \grayscale[1]_INST_0_i_1_n_0\
    );
\grayscale[1]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(11),
      I1 => C(11),
      O => \grayscale[1]_INST_0_i_2_n_0\
    );
\grayscale[1]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(10),
      I1 => C(10),
      O => \grayscale[1]_INST_0_i_3_n_0\
    );
\grayscale[1]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(9),
      I1 => C(9),
      O => \grayscale[1]_INST_0_i_4_n_0\
    );
\grayscale[1]_INST_0_i_5\: unisim.vcomponents.CARRY4
     port map (
      CI => \grayscale[0]_INST_0_i_10_n_0\,
      CO(3) => \grayscale[1]_INST_0_i_5_n_0\,
      CO(2) => \grayscale[1]_INST_0_i_5_n_1\,
      CO(1) => \grayscale[1]_INST_0_i_5_n_2\,
      CO(0) => \grayscale[1]_INST_0_i_5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => b_weighted(9 downto 6),
      O(3 downto 0) => C(9 downto 6),
      S(3) => \grayscale[1]_INST_0_i_6_n_0\,
      S(2) => \grayscale[1]_INST_0_i_7_n_0\,
      S(1) => \grayscale[1]_INST_0_i_8_n_0\,
      S(0) => \grayscale[1]_INST_0_i_9_n_0\
    );
\grayscale[1]_INST_0_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(9),
      I1 => r_weighted(9),
      O => \grayscale[1]_INST_0_i_6_n_0\
    );
\grayscale[1]_INST_0_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(8),
      I1 => r_weighted(8),
      O => \grayscale[1]_INST_0_i_7_n_0\
    );
\grayscale[1]_INST_0_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(7),
      I1 => r_weighted(7),
      O => \grayscale[1]_INST_0_i_8_n_0\
    );
\grayscale[1]_INST_0_i_9\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(6),
      I1 => r_weighted(6),
      O => \grayscale[1]_INST_0_i_9_n_0\
    );
\grayscale[5]_INST_0\: unisim.vcomponents.CARRY4
     port map (
      CI => \grayscale[1]_INST_0_n_0\,
      CO(3 downto 2) => \NLW_grayscale[5]_INST_0_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \grayscale[5]_INST_0_n_2\,
      CO(0) => \grayscale[5]_INST_0_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1 downto 0) => g_weighted(14 downto 13),
      O(3) => \NLW_grayscale[5]_INST_0_O_UNCONNECTED\(3),
      O(2 downto 0) => grayscale(7 downto 5),
      S(3) => '0',
      S(2) => \grayscale[5]_INST_0_i_1_n_0\,
      S(1) => \grayscale[5]_INST_0_i_2_n_0\,
      S(0) => \grayscale[5]_INST_0_i_3_n_0\
    );
\grayscale[5]_INST_0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(15),
      I1 => \grayscale[5]_INST_0_i_4_n_2\,
      O => \grayscale[5]_INST_0_i_1_n_0\
    );
\grayscale[5]_INST_0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(14),
      I1 => C(14),
      O => \grayscale[5]_INST_0_i_2_n_0\
    );
\grayscale[5]_INST_0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => g_weighted(13),
      I1 => C(13),
      O => \grayscale[5]_INST_0_i_3_n_0\
    );
\grayscale[5]_INST_0_i_4\: unisim.vcomponents.CARRY4
     port map (
      CI => \grayscale[5]_INST_0_i_5_n_0\,
      CO(3 downto 2) => \NLW_grayscale[5]_INST_0_i_4_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \grayscale[5]_INST_0_i_4_n_2\,
      CO(0) => \NLW_grayscale[5]_INST_0_i_4_CO_UNCONNECTED\(0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_grayscale[5]_INST_0_i_4_O_UNCONNECTED\(3 downto 1),
      O(0) => C(14),
      S(3 downto 1) => B"001",
      S(0) => r_weighted(14)
    );
\grayscale[5]_INST_0_i_5\: unisim.vcomponents.CARRY4
     port map (
      CI => \grayscale[1]_INST_0_i_5_n_0\,
      CO(3) => \grayscale[5]_INST_0_i_5_n_0\,
      CO(2) => \grayscale[5]_INST_0_i_5_n_1\,
      CO(1) => \grayscale[5]_INST_0_i_5_n_2\,
      CO(0) => \grayscale[5]_INST_0_i_5_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2 downto 0) => b_weighted(12 downto 10),
      O(3 downto 0) => C(13 downto 10),
      S(3) => r_weighted(13),
      S(2) => \grayscale[5]_INST_0_i_6_n_0\,
      S(1) => \grayscale[5]_INST_0_i_7_n_0\,
      S(0) => \grayscale[5]_INST_0_i_8_n_0\
    );
\grayscale[5]_INST_0_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(12),
      I1 => r_weighted(12),
      O => \grayscale[5]_INST_0_i_6_n_0\
    );
\grayscale[5]_INST_0_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(11),
      I1 => r_weighted(11),
      O => \grayscale[5]_INST_0_i_7_n_0\
    );
\grayscale[5]_INST_0_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => b_weighted(10),
      I1 => r_weighted(10),
      O => \grayscale[5]_INST_0_i_8_n_0\
    );
hsync_reg_reg: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => hsync_in,
      Q => hsync_out,
      R => '0'
    );
\r_weighted[13]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => pixel_data(21),
      I1 => pixel_data(23),
      O => \r_weighted[13]_i_2_n_0\
    );
\r_weighted[13]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => pixel_data(20),
      I1 => pixel_data(22),
      O => \r_weighted[13]_i_3_n_0\
    );
\r_weighted[13]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => pixel_data(23),
      I1 => pixel_data(21),
      I2 => pixel_data(19),
      O => \r_weighted[13]_i_4_n_0\
    );
\r_weighted[13]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(22),
      I1 => pixel_data(23),
      O => \r_weighted[13]_i_5_n_0\
    );
\r_weighted[13]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E1"
    )
        port map (
      I0 => pixel_data(23),
      I1 => pixel_data(21),
      I2 => pixel_data(22),
      O => \r_weighted[13]_i_6_n_0\
    );
\r_weighted[13]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => pixel_data(22),
      I1 => pixel_data(20),
      I2 => pixel_data(23),
      I3 => pixel_data(21),
      O => \r_weighted[13]_i_7_n_0\
    );
\r_weighted[13]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"718E8E71"
    )
        port map (
      I0 => pixel_data(19),
      I1 => pixel_data(21),
      I2 => pixel_data(23),
      I3 => pixel_data(22),
      I4 => pixel_data(20),
      O => \r_weighted[13]_i_8_n_0\
    );
\r_weighted[14]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => pixel_data(23),
      O => \r_weighted[14]_i_2_n_0\
    );
\r_weighted[5]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(17),
      I1 => pixel_data(19),
      O => \r_weighted[5]_i_2_n_0\
    );
\r_weighted[5]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => pixel_data(16),
      I1 => pixel_data(18),
      O => \r_weighted[5]_i_3_n_0\
    );
\r_weighted[5]_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => pixel_data(17),
      O => \r_weighted[5]_i_4_n_0\
    );
\r_weighted[9]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => pixel_data(22),
      I1 => pixel_data(20),
      I2 => pixel_data(18),
      O => \r_weighted[9]_i_2_n_0\
    );
\r_weighted[9]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => pixel_data(21),
      I1 => pixel_data(19),
      I2 => pixel_data(17),
      O => \r_weighted[9]_i_3_n_0\
    );
\r_weighted[9]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => pixel_data(19),
      I1 => pixel_data(21),
      I2 => pixel_data(17),
      O => \r_weighted[9]_i_4_n_0\
    );
\r_weighted[9]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8E71718E718E8E71"
    )
        port map (
      I0 => pixel_data(18),
      I1 => pixel_data(20),
      I2 => pixel_data(22),
      I3 => pixel_data(21),
      I4 => pixel_data(23),
      I5 => pixel_data(19),
      O => \r_weighted[9]_i_5_n_0\
    );
\r_weighted[9]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8E71718E718E8E71"
    )
        port map (
      I0 => pixel_data(17),
      I1 => pixel_data(19),
      I2 => pixel_data(21),
      I3 => pixel_data(20),
      I4 => pixel_data(22),
      I5 => pixel_data(18),
      O => \r_weighted[9]_i_6_n_0\
    );
\r_weighted[9]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69966969"
    )
        port map (
      I0 => pixel_data(19),
      I1 => pixel_data(21),
      I2 => pixel_data(17),
      I3 => pixel_data(20),
      I4 => pixel_data(18),
      O => \r_weighted[9]_i_7_n_0\
    );
\r_weighted[9]_i_8\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => pixel_data(20),
      I1 => pixel_data(18),
      I2 => pixel_data(16),
      O => \r_weighted[9]_i_8_n_0\
    );
\r_weighted_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(10),
      Q => r_weighted(10),
      R => '0'
    );
\r_weighted_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(11),
      Q => r_weighted(11),
      R => '0'
    );
\r_weighted_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(12),
      Q => r_weighted(12),
      R => '0'
    );
\r_weighted_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(13),
      Q => r_weighted(13),
      R => '0'
    );
\r_weighted_reg[13]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \r_weighted_reg[9]_i_1_n_0\,
      CO(3) => \r_weighted_reg[13]_i_1_n_0\,
      CO(2) => \r_weighted_reg[13]_i_1_n_1\,
      CO(1) => \r_weighted_reg[13]_i_1_n_2\,
      CO(0) => \r_weighted_reg[13]_i_1_n_3\,
      CYINIT => '0',
      DI(3) => pixel_data(22),
      DI(2) => \r_weighted[13]_i_2_n_0\,
      DI(1) => \r_weighted[13]_i_3_n_0\,
      DI(0) => \r_weighted[13]_i_4_n_0\,
      O(3 downto 0) => r_weighted0(13 downto 10),
      S(3) => \r_weighted[13]_i_5_n_0\,
      S(2) => \r_weighted[13]_i_6_n_0\,
      S(1) => \r_weighted[13]_i_7_n_0\,
      S(0) => \r_weighted[13]_i_8_n_0\
    );
\r_weighted_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(14),
      Q => r_weighted(14),
      R => '0'
    );
\r_weighted_reg[14]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \r_weighted_reg[13]_i_1_n_0\,
      CO(3 downto 0) => \NLW_r_weighted_reg[14]_i_1_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_r_weighted_reg[14]_i_1_O_UNCONNECTED\(3 downto 1),
      O(0) => r_weighted0(14),
      S(3 downto 1) => B"000",
      S(0) => \r_weighted[14]_i_2_n_0\
    );
\r_weighted_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(2),
      Q => r_weighted(2),
      R => '0'
    );
\r_weighted_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(3),
      Q => r_weighted(3),
      R => '0'
    );
\r_weighted_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(4),
      Q => r_weighted(4),
      R => '0'
    );
\r_weighted_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(5),
      Q => r_weighted(5),
      R => '0'
    );
\r_weighted_reg[5]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \r_weighted_reg[5]_i_1_n_0\,
      CO(2) => \r_weighted_reg[5]_i_1_n_1\,
      CO(1) => \r_weighted_reg[5]_i_1_n_2\,
      CO(0) => \r_weighted_reg[5]_i_1_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => pixel_data(17 downto 16),
      DI(1 downto 0) => B"01",
      O(3 downto 0) => r_weighted0(5 downto 2),
      S(3) => \r_weighted[5]_i_2_n_0\,
      S(2) => \r_weighted[5]_i_3_n_0\,
      S(1) => \r_weighted[5]_i_4_n_0\,
      S(0) => pixel_data(16)
    );
\r_weighted_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(6),
      Q => r_weighted(6),
      R => '0'
    );
\r_weighted_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(7),
      Q => r_weighted(7),
      R => '0'
    );
\r_weighted_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(8),
      Q => r_weighted(8),
      R => '0'
    );
\r_weighted_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => r_weighted0(9),
      Q => r_weighted(9),
      R => '0'
    );
\r_weighted_reg[9]_i_1\: unisim.vcomponents.CARRY4
     port map (
      CI => \r_weighted_reg[5]_i_1_n_0\,
      CO(3) => \r_weighted_reg[9]_i_1_n_0\,
      CO(2) => \r_weighted_reg[9]_i_1_n_1\,
      CO(1) => \r_weighted_reg[9]_i_1_n_2\,
      CO(0) => \r_weighted_reg[9]_i_1_n_3\,
      CYINIT => '0',
      DI(3) => \r_weighted[9]_i_2_n_0\,
      DI(2) => \r_weighted[9]_i_3_n_0\,
      DI(1) => \r_weighted[9]_i_4_n_0\,
      DI(0) => pixel_data(16),
      O(3 downto 0) => r_weighted0(9 downto 6),
      S(3) => \r_weighted[9]_i_5_n_0\,
      S(2) => \r_weighted[9]_i_6_n_0\,
      S(1) => \r_weighted[9]_i_7_n_0\,
      S(0) => \r_weighted[9]_i_8_n_0\
    );
vde_reg_reg: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => vde_in,
      Q => vde_out,
      R => '0'
    );
vsync_reg_reg: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => vsync_in,
      Q => vsync_out,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_rgb_to_grayscale_wra_0_0 is
  port (
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
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_rgb_to_grayscale_wra_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_rgb_to_grayscale_wra_0_0 : entity is "design_1_rgb_to_grayscale_wra_0_0,rgb_to_grayscale_wrapper,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_rgb_to_grayscale_wra_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_1_rgb_to_grayscale_wra_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of design_1_rgb_to_grayscale_wra_0_0 : entity is "rgb_to_grayscale_wrapper,Vivado 2025.1";
end design_1_rgb_to_grayscale_wra_0_0;

architecture STRUCTURE of design_1_rgb_to_grayscale_wra_0_0 is
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_dvi2rgb_0_0_PixelClk, INSERT_VIP 0";
begin
inst: entity work.design_1_rgb_to_grayscale_wra_0_0_rgb_to_grayscale_wrapper
     port map (
      clk => clk,
      grayscale(7 downto 0) => grayscale(7 downto 0),
      hsync_in => hsync_in,
      hsync_out => hsync_out,
      pixel_data(23 downto 0) => pixel_data(23 downto 0),
      vde_in => vde_in,
      vde_out => vde_out,
      vsync_in => vsync_in,
      vsync_out => vsync_out
    );
end STRUCTURE;
