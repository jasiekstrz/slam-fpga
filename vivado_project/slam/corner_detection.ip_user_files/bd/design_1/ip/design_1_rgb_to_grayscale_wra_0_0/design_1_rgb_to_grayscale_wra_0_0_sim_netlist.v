// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
// Date        : Mon Dec  8 21:19:22 2025
// Host        : eecs-digital-47 running 64-bit Ubuntu 24.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/jstrz/slam/corner_detection.gen/sources_1/bd/design_1/ip/design_1_rgb_to_grayscale_wra_0_0/design_1_rgb_to_grayscale_wra_0_0_sim_netlist.v
// Design      : design_1_rgb_to_grayscale_wra_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_rgb_to_grayscale_wra_0_0,rgb_to_grayscale_wrapper,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "rgb_to_grayscale_wrapper,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module design_1_rgb_to_grayscale_wra_0_0
   (clk,
    pixel_data,
    hsync_in,
    vsync_in,
    vde_in,
    grayscale,
    hsync_out,
    vsync_out,
    vde_out);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_dvi2rgb_0_0_PixelClk, INSERT_VIP 0" *) input clk;
  input [23:0]pixel_data;
  input hsync_in;
  input vsync_in;
  input vde_in;
  output [7:0]grayscale;
  output hsync_out;
  output vsync_out;
  output vde_out;

  wire clk;
  wire [7:0]grayscale;
  wire hsync_in;
  wire hsync_out;
  wire [23:0]pixel_data;
  wire vde_in;
  wire vde_out;
  wire vsync_in;
  wire vsync_out;

  design_1_rgb_to_grayscale_wra_0_0_rgb_to_grayscale_wrapper inst
       (.clk(clk),
        .grayscale(grayscale),
        .hsync_in(hsync_in),
        .hsync_out(hsync_out),
        .pixel_data(pixel_data),
        .vde_in(vde_in),
        .vde_out(vde_out),
        .vsync_in(vsync_in),
        .vsync_out(vsync_out));
endmodule

(* ORIG_REF_NAME = "rgb_to_grayscale_wrapper" *) 
module design_1_rgb_to_grayscale_wra_0_0_rgb_to_grayscale_wrapper
   (grayscale,
    hsync_out,
    vsync_out,
    vde_out,
    pixel_data,
    clk,
    hsync_in,
    vsync_in,
    vde_in);
  output [7:0]grayscale;
  output hsync_out;
  output vsync_out;
  output vde_out;
  input [23:0]pixel_data;
  input clk;
  input hsync_in;
  input vsync_in;
  input vde_in;

  wire [14:2]C;
  wire [12:1]b_weighted;
  wire [12:1]b_weighted0;
  wire \b_weighted[10]_i_11_n_0 ;
  wire \b_weighted[10]_i_12_n_0 ;
  wire \b_weighted[10]_i_13_n_0 ;
  wire \b_weighted[10]_i_2_n_0 ;
  wire \b_weighted[10]_i_3_n_0 ;
  wire \b_weighted[10]_i_4_n_0 ;
  wire \b_weighted[10]_i_5_n_0 ;
  wire \b_weighted[10]_i_6_n_0 ;
  wire \b_weighted[10]_i_7_n_0 ;
  wire \b_weighted[10]_i_8_n_0 ;
  wire \b_weighted[10]_i_9_n_0 ;
  wire \b_weighted[12]_i_2_n_0 ;
  wire \b_weighted[12]_i_3_n_0 ;
  wire \b_weighted[12]_i_4_n_0 ;
  wire \b_weighted[2]_i_2_n_0 ;
  wire \b_weighted[2]_i_3_n_0 ;
  wire \b_weighted[2]_i_4_n_0 ;
  wire \b_weighted[6]_i_2_n_0 ;
  wire \b_weighted[6]_i_3_n_0 ;
  wire \b_weighted[6]_i_4_n_0 ;
  wire \b_weighted[6]_i_5_n_0 ;
  wire \b_weighted[6]_i_6_n_0 ;
  wire \b_weighted[6]_i_7_n_0 ;
  wire \b_weighted[6]_i_8_n_0 ;
  wire \b_weighted_reg[10]_i_10_n_0 ;
  wire \b_weighted_reg[10]_i_10_n_1 ;
  wire \b_weighted_reg[10]_i_10_n_2 ;
  wire \b_weighted_reg[10]_i_10_n_3 ;
  wire \b_weighted_reg[10]_i_10_n_4 ;
  wire \b_weighted_reg[10]_i_10_n_5 ;
  wire \b_weighted_reg[10]_i_10_n_6 ;
  wire \b_weighted_reg[10]_i_10_n_7 ;
  wire \b_weighted_reg[10]_i_1_n_0 ;
  wire \b_weighted_reg[10]_i_1_n_1 ;
  wire \b_weighted_reg[10]_i_1_n_2 ;
  wire \b_weighted_reg[10]_i_1_n_3 ;
  wire \b_weighted_reg[12]_i_1_n_3 ;
  wire \b_weighted_reg[12]_i_5_n_2 ;
  wire \b_weighted_reg[12]_i_5_n_7 ;
  wire \b_weighted_reg[2]_i_1_n_0 ;
  wire \b_weighted_reg[2]_i_1_n_1 ;
  wire \b_weighted_reg[2]_i_1_n_2 ;
  wire \b_weighted_reg[2]_i_1_n_3 ;
  wire \b_weighted_reg[2]_i_1_n_4 ;
  wire \b_weighted_reg[2]_i_1_n_5 ;
  wire \b_weighted_reg[6]_i_1_n_0 ;
  wire \b_weighted_reg[6]_i_1_n_1 ;
  wire \b_weighted_reg[6]_i_1_n_2 ;
  wire \b_weighted_reg[6]_i_1_n_3 ;
  wire clk;
  wire [15:1]g_weighted;
  wire [15:1]g_weighted0;
  wire \g_weighted[10]_i_2_n_0 ;
  wire \g_weighted[10]_i_3_n_0 ;
  wire \g_weighted[10]_i_4_n_0 ;
  wire \g_weighted[10]_i_5_n_0 ;
  wire \g_weighted[10]_i_6_n_0 ;
  wire \g_weighted[10]_i_7_n_0 ;
  wire \g_weighted[10]_i_8_n_0 ;
  wire \g_weighted[14]_i_2_n_0 ;
  wire \g_weighted[14]_i_3_n_0 ;
  wire \g_weighted[14]_i_4_n_0 ;
  wire \g_weighted[14]_i_5_n_0 ;
  wire \g_weighted[14]_i_6_n_0 ;
  wire \g_weighted[14]_i_7_n_0 ;
  wire \g_weighted[14]_i_8_n_0 ;
  wire \g_weighted[14]_i_9_n_0 ;
  wire \g_weighted[15]_i_2_n_0 ;
  wire \g_weighted[15]_i_4_n_0 ;
  wire \g_weighted[15]_i_5_n_0 ;
  wire \g_weighted[2]_i_2_n_0 ;
  wire \g_weighted[2]_i_3_n_0 ;
  wire \g_weighted[2]_i_4_n_0 ;
  wire \g_weighted[6]_i_3_n_0 ;
  wire \g_weighted[6]_i_4_n_0 ;
  wire \g_weighted[6]_i_5_n_0 ;
  wire \g_weighted[6]_i_6_n_0 ;
  wire \g_weighted[6]_i_7_n_0 ;
  wire \g_weighted[6]_i_8_n_0 ;
  wire \g_weighted[6]_i_9_n_0 ;
  wire \g_weighted_reg[10]_i_1_n_0 ;
  wire \g_weighted_reg[10]_i_1_n_1 ;
  wire \g_weighted_reg[10]_i_1_n_2 ;
  wire \g_weighted_reg[10]_i_1_n_3 ;
  wire \g_weighted_reg[14]_i_1_n_0 ;
  wire \g_weighted_reg[14]_i_1_n_1 ;
  wire \g_weighted_reg[14]_i_1_n_2 ;
  wire \g_weighted_reg[14]_i_1_n_3 ;
  wire \g_weighted_reg[15]_i_3_n_1 ;
  wire \g_weighted_reg[15]_i_3_n_3 ;
  wire \g_weighted_reg[15]_i_3_n_6 ;
  wire \g_weighted_reg[15]_i_3_n_7 ;
  wire \g_weighted_reg[2]_i_1_n_0 ;
  wire \g_weighted_reg[2]_i_1_n_1 ;
  wire \g_weighted_reg[2]_i_1_n_2 ;
  wire \g_weighted_reg[2]_i_1_n_3 ;
  wire \g_weighted_reg[2]_i_1_n_4 ;
  wire \g_weighted_reg[2]_i_1_n_5 ;
  wire \g_weighted_reg[6]_i_1_n_0 ;
  wire \g_weighted_reg[6]_i_1_n_1 ;
  wire \g_weighted_reg[6]_i_1_n_2 ;
  wire \g_weighted_reg[6]_i_1_n_3 ;
  wire \g_weighted_reg[6]_i_2_n_0 ;
  wire \g_weighted_reg[6]_i_2_n_1 ;
  wire \g_weighted_reg[6]_i_2_n_2 ;
  wire \g_weighted_reg[6]_i_2_n_3 ;
  wire \g_weighted_reg[6]_i_2_n_4 ;
  wire \g_weighted_reg[6]_i_2_n_5 ;
  wire \g_weighted_reg[6]_i_2_n_6 ;
  wire \g_weighted_reg[6]_i_2_n_7 ;
  wire [7:0]grayscale;
  wire \grayscale[0]_INST_0_i_10_n_0 ;
  wire \grayscale[0]_INST_0_i_10_n_1 ;
  wire \grayscale[0]_INST_0_i_10_n_2 ;
  wire \grayscale[0]_INST_0_i_10_n_3 ;
  wire \grayscale[0]_INST_0_i_11_n_0 ;
  wire \grayscale[0]_INST_0_i_12_n_0 ;
  wire \grayscale[0]_INST_0_i_13_n_0 ;
  wire \grayscale[0]_INST_0_i_14_n_0 ;
  wire \grayscale[0]_INST_0_i_1_n_0 ;
  wire \grayscale[0]_INST_0_i_1_n_1 ;
  wire \grayscale[0]_INST_0_i_1_n_2 ;
  wire \grayscale[0]_INST_0_i_1_n_3 ;
  wire \grayscale[0]_INST_0_i_2_n_0 ;
  wire \grayscale[0]_INST_0_i_3_n_0 ;
  wire \grayscale[0]_INST_0_i_4_n_0 ;
  wire \grayscale[0]_INST_0_i_5_n_0 ;
  wire \grayscale[0]_INST_0_i_6_n_0 ;
  wire \grayscale[0]_INST_0_i_7_n_0 ;
  wire \grayscale[0]_INST_0_i_8_n_0 ;
  wire \grayscale[0]_INST_0_i_9_n_0 ;
  wire \grayscale[0]_INST_0_n_0 ;
  wire \grayscale[0]_INST_0_n_1 ;
  wire \grayscale[0]_INST_0_n_2 ;
  wire \grayscale[0]_INST_0_n_3 ;
  wire \grayscale[1]_INST_0_i_1_n_0 ;
  wire \grayscale[1]_INST_0_i_2_n_0 ;
  wire \grayscale[1]_INST_0_i_3_n_0 ;
  wire \grayscale[1]_INST_0_i_4_n_0 ;
  wire \grayscale[1]_INST_0_i_5_n_0 ;
  wire \grayscale[1]_INST_0_i_5_n_1 ;
  wire \grayscale[1]_INST_0_i_5_n_2 ;
  wire \grayscale[1]_INST_0_i_5_n_3 ;
  wire \grayscale[1]_INST_0_i_6_n_0 ;
  wire \grayscale[1]_INST_0_i_7_n_0 ;
  wire \grayscale[1]_INST_0_i_8_n_0 ;
  wire \grayscale[1]_INST_0_i_9_n_0 ;
  wire \grayscale[1]_INST_0_n_0 ;
  wire \grayscale[1]_INST_0_n_1 ;
  wire \grayscale[1]_INST_0_n_2 ;
  wire \grayscale[1]_INST_0_n_3 ;
  wire \grayscale[5]_INST_0_i_1_n_0 ;
  wire \grayscale[5]_INST_0_i_2_n_0 ;
  wire \grayscale[5]_INST_0_i_3_n_0 ;
  wire \grayscale[5]_INST_0_i_4_n_2 ;
  wire \grayscale[5]_INST_0_i_5_n_0 ;
  wire \grayscale[5]_INST_0_i_5_n_1 ;
  wire \grayscale[5]_INST_0_i_5_n_2 ;
  wire \grayscale[5]_INST_0_i_5_n_3 ;
  wire \grayscale[5]_INST_0_i_6_n_0 ;
  wire \grayscale[5]_INST_0_i_7_n_0 ;
  wire \grayscale[5]_INST_0_i_8_n_0 ;
  wire \grayscale[5]_INST_0_n_2 ;
  wire \grayscale[5]_INST_0_n_3 ;
  wire hsync_in;
  wire hsync_out;
  wire [23:0]pixel_data;
  wire [14:2]r_weighted;
  wire [14:2]r_weighted0;
  wire \r_weighted[13]_i_2_n_0 ;
  wire \r_weighted[13]_i_3_n_0 ;
  wire \r_weighted[13]_i_4_n_0 ;
  wire \r_weighted[13]_i_5_n_0 ;
  wire \r_weighted[13]_i_6_n_0 ;
  wire \r_weighted[13]_i_7_n_0 ;
  wire \r_weighted[13]_i_8_n_0 ;
  wire \r_weighted[14]_i_2_n_0 ;
  wire \r_weighted[5]_i_2_n_0 ;
  wire \r_weighted[5]_i_3_n_0 ;
  wire \r_weighted[5]_i_4_n_0 ;
  wire \r_weighted[9]_i_2_n_0 ;
  wire \r_weighted[9]_i_3_n_0 ;
  wire \r_weighted[9]_i_4_n_0 ;
  wire \r_weighted[9]_i_5_n_0 ;
  wire \r_weighted[9]_i_6_n_0 ;
  wire \r_weighted[9]_i_7_n_0 ;
  wire \r_weighted[9]_i_8_n_0 ;
  wire \r_weighted_reg[13]_i_1_n_0 ;
  wire \r_weighted_reg[13]_i_1_n_1 ;
  wire \r_weighted_reg[13]_i_1_n_2 ;
  wire \r_weighted_reg[13]_i_1_n_3 ;
  wire \r_weighted_reg[5]_i_1_n_0 ;
  wire \r_weighted_reg[5]_i_1_n_1 ;
  wire \r_weighted_reg[5]_i_1_n_2 ;
  wire \r_weighted_reg[5]_i_1_n_3 ;
  wire \r_weighted_reg[9]_i_1_n_0 ;
  wire \r_weighted_reg[9]_i_1_n_1 ;
  wire \r_weighted_reg[9]_i_1_n_2 ;
  wire \r_weighted_reg[9]_i_1_n_3 ;
  wire vde_in;
  wire vde_out;
  wire vsync_in;
  wire vsync_out;
  wire [3:1]\NLW_b_weighted_reg[12]_i_1_CO_UNCONNECTED ;
  wire [3:2]\NLW_b_weighted_reg[12]_i_1_O_UNCONNECTED ;
  wire [3:0]\NLW_b_weighted_reg[12]_i_5_CO_UNCONNECTED ;
  wire [3:1]\NLW_b_weighted_reg[12]_i_5_O_UNCONNECTED ;
  wire [3:0]\NLW_g_weighted_reg[15]_i_1_CO_UNCONNECTED ;
  wire [3:1]\NLW_g_weighted_reg[15]_i_1_O_UNCONNECTED ;
  wire [3:1]\NLW_g_weighted_reg[15]_i_3_CO_UNCONNECTED ;
  wire [3:2]\NLW_g_weighted_reg[15]_i_3_O_UNCONNECTED ;
  wire [2:0]\NLW_grayscale[0]_INST_0_O_UNCONNECTED ;
  wire [3:0]\NLW_grayscale[0]_INST_0_i_1_O_UNCONNECTED ;
  wire [3:2]\NLW_grayscale[5]_INST_0_CO_UNCONNECTED ;
  wire [3:3]\NLW_grayscale[5]_INST_0_O_UNCONNECTED ;
  wire [3:0]\NLW_grayscale[5]_INST_0_i_4_CO_UNCONNECTED ;
  wire [3:1]\NLW_grayscale[5]_INST_0_i_4_O_UNCONNECTED ;
  wire [3:0]\NLW_r_weighted_reg[14]_i_1_CO_UNCONNECTED ;
  wire [3:1]\NLW_r_weighted_reg[14]_i_1_O_UNCONNECTED ;

  LUT2 #(
    .INIT(4'h6)) 
    \b_weighted[10]_i_11 
       (.I0(pixel_data[7]),
        .I1(pixel_data[5]),
        .O(\b_weighted[10]_i_11_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \b_weighted[10]_i_12 
       (.I0(pixel_data[6]),
        .I1(pixel_data[4]),
        .O(\b_weighted[10]_i_12_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \b_weighted[10]_i_13 
       (.I0(pixel_data[5]),
        .I1(pixel_data[3]),
        .O(\b_weighted[10]_i_13_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \b_weighted[10]_i_2 
       (.I0(pixel_data[6]),
        .I1(\b_weighted_reg[12]_i_5_n_7 ),
        .I2(pixel_data[4]),
        .O(\b_weighted[10]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \b_weighted[10]_i_3 
       (.I0(pixel_data[5]),
        .I1(\b_weighted_reg[10]_i_10_n_4 ),
        .I2(pixel_data[3]),
        .O(\b_weighted[10]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \b_weighted[10]_i_4 
       (.I0(pixel_data[4]),
        .I1(\b_weighted_reg[10]_i_10_n_5 ),
        .I2(pixel_data[2]),
        .O(\b_weighted[10]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \b_weighted[10]_i_5 
       (.I0(pixel_data[3]),
        .I1(\b_weighted_reg[10]_i_10_n_6 ),
        .I2(pixel_data[1]),
        .O(\b_weighted[10]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h8E71718E718E8E71)) 
    \b_weighted[10]_i_6 
       (.I0(pixel_data[4]),
        .I1(\b_weighted_reg[12]_i_5_n_7 ),
        .I2(pixel_data[6]),
        .I3(pixel_data[7]),
        .I4(\b_weighted_reg[12]_i_5_n_2 ),
        .I5(pixel_data[5]),
        .O(\b_weighted[10]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h8E71718E718E8E71)) 
    \b_weighted[10]_i_7 
       (.I0(pixel_data[3]),
        .I1(\b_weighted_reg[10]_i_10_n_4 ),
        .I2(pixel_data[5]),
        .I3(pixel_data[6]),
        .I4(\b_weighted_reg[12]_i_5_n_7 ),
        .I5(pixel_data[4]),
        .O(\b_weighted[10]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h8E71718E718E8E71)) 
    \b_weighted[10]_i_8 
       (.I0(pixel_data[2]),
        .I1(\b_weighted_reg[10]_i_10_n_5 ),
        .I2(pixel_data[4]),
        .I3(pixel_data[5]),
        .I4(\b_weighted_reg[10]_i_10_n_4 ),
        .I5(pixel_data[3]),
        .O(\b_weighted[10]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h8E71718E718E8E71)) 
    \b_weighted[10]_i_9 
       (.I0(pixel_data[1]),
        .I1(\b_weighted_reg[10]_i_10_n_6 ),
        .I2(pixel_data[3]),
        .I3(pixel_data[4]),
        .I4(\b_weighted_reg[10]_i_10_n_5 ),
        .I5(pixel_data[2]),
        .O(\b_weighted[10]_i_9_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \b_weighted[12]_i_2 
       (.I0(pixel_data[7]),
        .I1(\b_weighted_reg[12]_i_5_n_2 ),
        .I2(pixel_data[5]),
        .O(\b_weighted[12]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \b_weighted[12]_i_3 
       (.I0(pixel_data[6]),
        .I1(pixel_data[7]),
        .O(\b_weighted[12]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h8E71)) 
    \b_weighted[12]_i_4 
       (.I0(pixel_data[5]),
        .I1(\b_weighted_reg[12]_i_5_n_2 ),
        .I2(pixel_data[7]),
        .I3(pixel_data[6]),
        .O(\b_weighted[12]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \b_weighted[2]_i_2 
       (.I0(pixel_data[4]),
        .I1(pixel_data[2]),
        .O(\b_weighted[2]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \b_weighted[2]_i_3 
       (.I0(pixel_data[3]),
        .I1(pixel_data[1]),
        .O(\b_weighted[2]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \b_weighted[2]_i_4 
       (.I0(pixel_data[2]),
        .I1(pixel_data[0]),
        .O(\b_weighted[2]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \b_weighted[6]_i_2 
       (.I0(pixel_data[2]),
        .I1(\b_weighted_reg[10]_i_10_n_7 ),
        .I2(pixel_data[0]),
        .O(\b_weighted[6]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h69)) 
    \b_weighted[6]_i_3 
       (.I0(pixel_data[2]),
        .I1(\b_weighted_reg[10]_i_10_n_7 ),
        .I2(pixel_data[0]),
        .O(\b_weighted[6]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'hB)) 
    \b_weighted[6]_i_4 
       (.I0(\b_weighted_reg[2]_i_1_n_5 ),
        .I1(pixel_data[0]),
        .O(\b_weighted[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h8E71718E718E8E71)) 
    \b_weighted[6]_i_5 
       (.I0(pixel_data[0]),
        .I1(\b_weighted_reg[10]_i_10_n_7 ),
        .I2(pixel_data[2]),
        .I3(pixel_data[3]),
        .I4(\b_weighted_reg[10]_i_10_n_6 ),
        .I5(pixel_data[1]),
        .O(\b_weighted[6]_i_5_n_0 ));
  LUT5 #(
    .INIT(32'h69966969)) 
    \b_weighted[6]_i_6 
       (.I0(pixel_data[2]),
        .I1(\b_weighted_reg[10]_i_10_n_7 ),
        .I2(pixel_data[0]),
        .I3(pixel_data[1]),
        .I4(\b_weighted_reg[2]_i_1_n_4 ),
        .O(\b_weighted[6]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h2DD2)) 
    \b_weighted[6]_i_7 
       (.I0(pixel_data[0]),
        .I1(\b_weighted_reg[2]_i_1_n_5 ),
        .I2(\b_weighted_reg[2]_i_1_n_4 ),
        .I3(pixel_data[1]),
        .O(\b_weighted[6]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \b_weighted[6]_i_8 
       (.I0(pixel_data[0]),
        .I1(\b_weighted_reg[2]_i_1_n_5 ),
        .O(\b_weighted[6]_i_8_n_0 ));
  FDRE \b_weighted_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[10]),
        .Q(b_weighted[10]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x5}}" *) 
  CARRY4 \b_weighted_reg[10]_i_1 
       (.CI(\b_weighted_reg[6]_i_1_n_0 ),
        .CO({\b_weighted_reg[10]_i_1_n_0 ,\b_weighted_reg[10]_i_1_n_1 ,\b_weighted_reg[10]_i_1_n_2 ,\b_weighted_reg[10]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\b_weighted[10]_i_2_n_0 ,\b_weighted[10]_i_3_n_0 ,\b_weighted[10]_i_4_n_0 ,\b_weighted[10]_i_5_n_0 }),
        .O(b_weighted0[10:7]),
        .S({\b_weighted[10]_i_6_n_0 ,\b_weighted[10]_i_7_n_0 ,\b_weighted[10]_i_8_n_0 ,\b_weighted[10]_i_9_n_0 }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x5}}" *) 
  CARRY4 \b_weighted_reg[10]_i_10 
       (.CI(\b_weighted_reg[2]_i_1_n_0 ),
        .CO({\b_weighted_reg[10]_i_10_n_0 ,\b_weighted_reg[10]_i_10_n_1 ,\b_weighted_reg[10]_i_10_n_2 ,\b_weighted_reg[10]_i_10_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,pixel_data[7:5]}),
        .O({\b_weighted_reg[10]_i_10_n_4 ,\b_weighted_reg[10]_i_10_n_5 ,\b_weighted_reg[10]_i_10_n_6 ,\b_weighted_reg[10]_i_10_n_7 }),
        .S({pixel_data[6],\b_weighted[10]_i_11_n_0 ,\b_weighted[10]_i_12_n_0 ,\b_weighted[10]_i_13_n_0 }));
  FDRE \b_weighted_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[11]),
        .Q(b_weighted[11]),
        .R(1'b0));
  FDRE \b_weighted_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[12]),
        .Q(b_weighted[12]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x5}}" *) 
  CARRY4 \b_weighted_reg[12]_i_1 
       (.CI(\b_weighted_reg[10]_i_1_n_0 ),
        .CO({\NLW_b_weighted_reg[12]_i_1_CO_UNCONNECTED [3:1],\b_weighted_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\b_weighted[12]_i_2_n_0 }),
        .O({\NLW_b_weighted_reg[12]_i_1_O_UNCONNECTED [3:2],b_weighted0[12:11]}),
        .S({1'b0,1'b0,\b_weighted[12]_i_3_n_0 ,\b_weighted[12]_i_4_n_0 }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x5}}" *) 
  CARRY4 \b_weighted_reg[12]_i_5 
       (.CI(\b_weighted_reg[10]_i_10_n_0 ),
        .CO({\NLW_b_weighted_reg[12]_i_5_CO_UNCONNECTED [3:2],\b_weighted_reg[12]_i_5_n_2 ,\NLW_b_weighted_reg[12]_i_5_CO_UNCONNECTED [0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_b_weighted_reg[12]_i_5_O_UNCONNECTED [3:1],\b_weighted_reg[12]_i_5_n_7 }),
        .S({1'b0,1'b0,1'b1,pixel_data[7]}));
  FDRE \b_weighted_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[1]),
        .Q(b_weighted[1]),
        .R(1'b0));
  FDRE \b_weighted_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[2]),
        .Q(b_weighted[2]),
        .R(1'b0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x5}}" *) 
  CARRY4 \b_weighted_reg[2]_i_1 
       (.CI(1'b0),
        .CO({\b_weighted_reg[2]_i_1_n_0 ,\b_weighted_reg[2]_i_1_n_1 ,\b_weighted_reg[2]_i_1_n_2 ,\b_weighted_reg[2]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({pixel_data[4:2],1'b0}),
        .O({\b_weighted_reg[2]_i_1_n_4 ,\b_weighted_reg[2]_i_1_n_5 ,b_weighted0[2:1]}),
        .S({\b_weighted[2]_i_2_n_0 ,\b_weighted[2]_i_3_n_0 ,\b_weighted[2]_i_4_n_0 ,pixel_data[1]}));
  FDRE \b_weighted_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[3]),
        .Q(b_weighted[3]),
        .R(1'b0));
  FDRE \b_weighted_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[4]),
        .Q(b_weighted[4]),
        .R(1'b0));
  FDRE \b_weighted_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[5]),
        .Q(b_weighted[5]),
        .R(1'b0));
  FDRE \b_weighted_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[6]),
        .Q(b_weighted[6]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x5}}" *) 
  CARRY4 \b_weighted_reg[6]_i_1 
       (.CI(1'b0),
        .CO({\b_weighted_reg[6]_i_1_n_0 ,\b_weighted_reg[6]_i_1_n_1 ,\b_weighted_reg[6]_i_1_n_2 ,\b_weighted_reg[6]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\b_weighted[6]_i_2_n_0 ,\b_weighted[6]_i_3_n_0 ,\b_weighted[6]_i_4_n_0 ,1'b0}),
        .O(b_weighted0[6:3]),
        .S({\b_weighted[6]_i_5_n_0 ,\b_weighted[6]_i_6_n_0 ,\b_weighted[6]_i_7_n_0 ,\b_weighted[6]_i_8_n_0 }));
  FDRE \b_weighted_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[7]),
        .Q(b_weighted[7]),
        .R(1'b0));
  FDRE \b_weighted_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[8]),
        .Q(b_weighted[8]),
        .R(1'b0));
  FDRE \b_weighted_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(b_weighted0[9]),
        .Q(b_weighted[9]),
        .R(1'b0));
  (* HLUTNM = "lutpair1" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \g_weighted[10]_i_2 
       (.I0(pixel_data[13]),
        .I1(\g_weighted_reg[15]_i_3_n_7 ),
        .I2(pixel_data[10]),
        .O(\g_weighted[10]_i_2_n_0 ));
  (* HLUTNM = "lutpair0" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \g_weighted[10]_i_3 
       (.I0(pixel_data[12]),
        .I1(\g_weighted_reg[6]_i_2_n_4 ),
        .I2(pixel_data[9]),
        .O(\g_weighted[10]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \g_weighted[10]_i_4 
       (.I0(pixel_data[9]),
        .I1(pixel_data[12]),
        .I2(\g_weighted_reg[6]_i_2_n_4 ),
        .O(\g_weighted[10]_i_4_n_0 ));
  (* HLUTNM = "lutpair2" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \g_weighted[10]_i_5 
       (.I0(pixel_data[14]),
        .I1(\g_weighted_reg[15]_i_3_n_6 ),
        .I2(pixel_data[11]),
        .I3(\g_weighted[10]_i_2_n_0 ),
        .O(\g_weighted[10]_i_5_n_0 ));
  (* HLUTNM = "lutpair1" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    \g_weighted[10]_i_6 
       (.I0(pixel_data[13]),
        .I1(\g_weighted_reg[15]_i_3_n_7 ),
        .I2(pixel_data[10]),
        .I3(\g_weighted[10]_i_3_n_0 ),
        .O(\g_weighted[10]_i_6_n_0 ));
  (* HLUTNM = "lutpair0" *) 
  LUT5 #(
    .INIT(32'h69969696)) 
    \g_weighted[10]_i_7 
       (.I0(pixel_data[12]),
        .I1(\g_weighted_reg[6]_i_2_n_4 ),
        .I2(pixel_data[9]),
        .I3(\g_weighted_reg[6]_i_2_n_5 ),
        .I4(pixel_data[11]),
        .O(\g_weighted[10]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \g_weighted[10]_i_8 
       (.I0(pixel_data[11]),
        .I1(\g_weighted_reg[6]_i_2_n_5 ),
        .I2(pixel_data[8]),
        .O(\g_weighted[10]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \g_weighted[14]_i_2 
       (.I0(pixel_data[14]),
        .I1(\g_weighted_reg[15]_i_3_n_1 ),
        .O(\g_weighted[14]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \g_weighted[14]_i_3 
       (.I0(pixel_data[13]),
        .I1(\g_weighted_reg[15]_i_3_n_1 ),
        .O(\g_weighted[14]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \g_weighted[14]_i_4 
       (.I0(\g_weighted_reg[15]_i_3_n_1 ),
        .I1(pixel_data[15]),
        .I2(pixel_data[12]),
        .O(\g_weighted[14]_i_4_n_0 ));
  (* HLUTNM = "lutpair2" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    \g_weighted[14]_i_5 
       (.I0(pixel_data[14]),
        .I1(\g_weighted_reg[15]_i_3_n_6 ),
        .I2(pixel_data[11]),
        .O(\g_weighted[14]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'hE1)) 
    \g_weighted[14]_i_6 
       (.I0(pixel_data[14]),
        .I1(\g_weighted_reg[15]_i_3_n_1 ),
        .I2(pixel_data[15]),
        .O(\g_weighted[14]_i_6_n_0 ));
  LUT3 #(
    .INIT(8'hE1)) 
    \g_weighted[14]_i_7 
       (.I0(pixel_data[13]),
        .I1(\g_weighted_reg[15]_i_3_n_1 ),
        .I2(pixel_data[14]),
        .O(\g_weighted[14]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h7E81)) 
    \g_weighted[14]_i_8 
       (.I0(pixel_data[12]),
        .I1(pixel_data[15]),
        .I2(\g_weighted_reg[15]_i_3_n_1 ),
        .I3(pixel_data[13]),
        .O(\g_weighted[14]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h9669)) 
    \g_weighted[14]_i_9 
       (.I0(\g_weighted[14]_i_5_n_0 ),
        .I1(\g_weighted_reg[15]_i_3_n_1 ),
        .I2(pixel_data[15]),
        .I3(pixel_data[12]),
        .O(\g_weighted[14]_i_9_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \g_weighted[15]_i_2 
       (.I0(pixel_data[15]),
        .I1(\g_weighted_reg[15]_i_3_n_1 ),
        .O(\g_weighted[15]_i_2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \g_weighted[15]_i_4 
       (.I0(pixel_data[15]),
        .O(\g_weighted[15]_i_4_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \g_weighted[15]_i_5 
       (.I0(pixel_data[14]),
        .O(\g_weighted[15]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \g_weighted[2]_i_2 
       (.I0(pixel_data[9]),
        .I1(pixel_data[11]),
        .O(\g_weighted[2]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \g_weighted[2]_i_3 
       (.I0(pixel_data[8]),
        .I1(pixel_data[10]),
        .O(\g_weighted[2]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \g_weighted[2]_i_4 
       (.I0(pixel_data[9]),
        .O(\g_weighted[2]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \g_weighted[6]_i_3 
       (.I0(\g_weighted_reg[6]_i_2_n_6 ),
        .I1(pixel_data[10]),
        .O(\g_weighted[6]_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \g_weighted[6]_i_4 
       (.I0(\g_weighted_reg[6]_i_2_n_7 ),
        .I1(pixel_data[9]),
        .O(\g_weighted[6]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \g_weighted[6]_i_5 
       (.I0(\g_weighted_reg[2]_i_1_n_4 ),
        .I1(pixel_data[8]),
        .O(\g_weighted[6]_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \g_weighted[6]_i_6 
       (.I0(pixel_data[13]),
        .I1(pixel_data[15]),
        .O(\g_weighted[6]_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \g_weighted[6]_i_7 
       (.I0(pixel_data[12]),
        .I1(pixel_data[14]),
        .O(\g_weighted[6]_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \g_weighted[6]_i_8 
       (.I0(pixel_data[11]),
        .I1(pixel_data[13]),
        .O(\g_weighted[6]_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \g_weighted[6]_i_9 
       (.I0(pixel_data[10]),
        .I1(pixel_data[12]),
        .O(\g_weighted[6]_i_9_n_0 ));
  FDRE \g_weighted_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[10]),
        .Q(g_weighted[10]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x8}}" *) 
  CARRY4 \g_weighted_reg[10]_i_1 
       (.CI(\g_weighted_reg[6]_i_1_n_0 ),
        .CO({\g_weighted_reg[10]_i_1_n_0 ,\g_weighted_reg[10]_i_1_n_1 ,\g_weighted_reg[10]_i_1_n_2 ,\g_weighted_reg[10]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\g_weighted[10]_i_2_n_0 ,\g_weighted[10]_i_3_n_0 ,\g_weighted[10]_i_4_n_0 ,pixel_data[8]}),
        .O(g_weighted0[10:7]),
        .S({\g_weighted[10]_i_5_n_0 ,\g_weighted[10]_i_6_n_0 ,\g_weighted[10]_i_7_n_0 ,\g_weighted[10]_i_8_n_0 }));
  FDRE \g_weighted_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[11]),
        .Q(g_weighted[11]),
        .R(1'b0));
  FDRE \g_weighted_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[12]),
        .Q(g_weighted[12]),
        .R(1'b0));
  FDRE \g_weighted_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[13]),
        .Q(g_weighted[13]),
        .R(1'b0));
  FDRE \g_weighted_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[14]),
        .Q(g_weighted[14]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x8}}" *) 
  CARRY4 \g_weighted_reg[14]_i_1 
       (.CI(\g_weighted_reg[10]_i_1_n_0 ),
        .CO({\g_weighted_reg[14]_i_1_n_0 ,\g_weighted_reg[14]_i_1_n_1 ,\g_weighted_reg[14]_i_1_n_2 ,\g_weighted_reg[14]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\g_weighted[14]_i_2_n_0 ,\g_weighted[14]_i_3_n_0 ,\g_weighted[14]_i_4_n_0 ,\g_weighted[14]_i_5_n_0 }),
        .O(g_weighted0[14:11]),
        .S({\g_weighted[14]_i_6_n_0 ,\g_weighted[14]_i_7_n_0 ,\g_weighted[14]_i_8_n_0 ,\g_weighted[14]_i_9_n_0 }));
  FDRE \g_weighted_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[15]),
        .Q(g_weighted[15]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x8}}" *) 
  CARRY4 \g_weighted_reg[15]_i_1 
       (.CI(\g_weighted_reg[14]_i_1_n_0 ),
        .CO(\NLW_g_weighted_reg[15]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_g_weighted_reg[15]_i_1_O_UNCONNECTED [3:1],g_weighted0[15]}),
        .S({1'b0,1'b0,1'b0,\g_weighted[15]_i_2_n_0 }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x8}}" *) 
  CARRY4 \g_weighted_reg[15]_i_3 
       (.CI(\g_weighted_reg[6]_i_2_n_0 ),
        .CO({\NLW_g_weighted_reg[15]_i_3_CO_UNCONNECTED [3],\g_weighted_reg[15]_i_3_n_1 ,\NLW_g_weighted_reg[15]_i_3_CO_UNCONNECTED [1],\g_weighted_reg[15]_i_3_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,pixel_data[15:14]}),
        .O({\NLW_g_weighted_reg[15]_i_3_O_UNCONNECTED [3:2],\g_weighted_reg[15]_i_3_n_6 ,\g_weighted_reg[15]_i_3_n_7 }),
        .S({1'b0,1'b1,\g_weighted[15]_i_4_n_0 ,\g_weighted[15]_i_5_n_0 }));
  FDRE \g_weighted_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[1]),
        .Q(g_weighted[1]),
        .R(1'b0));
  FDRE \g_weighted_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[2]),
        .Q(g_weighted[2]),
        .R(1'b0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x8}}" *) 
  CARRY4 \g_weighted_reg[2]_i_1 
       (.CI(1'b0),
        .CO({\g_weighted_reg[2]_i_1_n_0 ,\g_weighted_reg[2]_i_1_n_1 ,\g_weighted_reg[2]_i_1_n_2 ,\g_weighted_reg[2]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({pixel_data[9:8],1'b0,1'b1}),
        .O({\g_weighted_reg[2]_i_1_n_4 ,\g_weighted_reg[2]_i_1_n_5 ,g_weighted0[2:1]}),
        .S({\g_weighted[2]_i_2_n_0 ,\g_weighted[2]_i_3_n_0 ,\g_weighted[2]_i_4_n_0 ,pixel_data[8]}));
  FDRE \g_weighted_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[3]),
        .Q(g_weighted[3]),
        .R(1'b0));
  FDRE \g_weighted_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[4]),
        .Q(g_weighted[4]),
        .R(1'b0));
  FDRE \g_weighted_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[5]),
        .Q(g_weighted[5]),
        .R(1'b0));
  FDRE \g_weighted_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[6]),
        .Q(g_weighted[6]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x8}}" *) 
  CARRY4 \g_weighted_reg[6]_i_1 
       (.CI(1'b0),
        .CO({\g_weighted_reg[6]_i_1_n_0 ,\g_weighted_reg[6]_i_1_n_1 ,\g_weighted_reg[6]_i_1_n_2 ,\g_weighted_reg[6]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\g_weighted_reg[6]_i_2_n_6 ,\g_weighted_reg[6]_i_2_n_7 ,\g_weighted_reg[2]_i_1_n_4 ,1'b0}),
        .O(g_weighted0[6:3]),
        .S({\g_weighted[6]_i_3_n_0 ,\g_weighted[6]_i_4_n_0 ,\g_weighted[6]_i_5_n_0 ,\g_weighted_reg[2]_i_1_n_5 }));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x8}}" *) 
  CARRY4 \g_weighted_reg[6]_i_2 
       (.CI(\g_weighted_reg[2]_i_1_n_0 ),
        .CO({\g_weighted_reg[6]_i_2_n_0 ,\g_weighted_reg[6]_i_2_n_1 ,\g_weighted_reg[6]_i_2_n_2 ,\g_weighted_reg[6]_i_2_n_3 }),
        .CYINIT(1'b0),
        .DI(pixel_data[13:10]),
        .O({\g_weighted_reg[6]_i_2_n_4 ,\g_weighted_reg[6]_i_2_n_5 ,\g_weighted_reg[6]_i_2_n_6 ,\g_weighted_reg[6]_i_2_n_7 }),
        .S({\g_weighted[6]_i_6_n_0 ,\g_weighted[6]_i_7_n_0 ,\g_weighted[6]_i_8_n_0 ,\g_weighted[6]_i_9_n_0 }));
  FDRE \g_weighted_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[7]),
        .Q(g_weighted[7]),
        .R(1'b0));
  FDRE \g_weighted_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[8]),
        .Q(g_weighted[8]),
        .R(1'b0));
  FDRE \g_weighted_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(g_weighted0[9]),
        .Q(g_weighted[9]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \grayscale[0]_INST_0 
       (.CI(\grayscale[0]_INST_0_i_1_n_0 ),
        .CO({\grayscale[0]_INST_0_n_0 ,\grayscale[0]_INST_0_n_1 ,\grayscale[0]_INST_0_n_2 ,\grayscale[0]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(g_weighted[8:5]),
        .O({grayscale[0],\NLW_grayscale[0]_INST_0_O_UNCONNECTED [2:0]}),
        .S({\grayscale[0]_INST_0_i_2_n_0 ,\grayscale[0]_INST_0_i_3_n_0 ,\grayscale[0]_INST_0_i_4_n_0 ,\grayscale[0]_INST_0_i_5_n_0 }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \grayscale[0]_INST_0_i_1 
       (.CI(1'b0),
        .CO({\grayscale[0]_INST_0_i_1_n_0 ,\grayscale[0]_INST_0_i_1_n_1 ,\grayscale[0]_INST_0_i_1_n_2 ,\grayscale[0]_INST_0_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI(g_weighted[4:1]),
        .O(\NLW_grayscale[0]_INST_0_i_1_O_UNCONNECTED [3:0]),
        .S({\grayscale[0]_INST_0_i_6_n_0 ,\grayscale[0]_INST_0_i_7_n_0 ,\grayscale[0]_INST_0_i_8_n_0 ,\grayscale[0]_INST_0_i_9_n_0 }));
  CARRY4 \grayscale[0]_INST_0_i_10 
       (.CI(1'b0),
        .CO({\grayscale[0]_INST_0_i_10_n_0 ,\grayscale[0]_INST_0_i_10_n_1 ,\grayscale[0]_INST_0_i_10_n_2 ,\grayscale[0]_INST_0_i_10_n_3 }),
        .CYINIT(1'b0),
        .DI(b_weighted[5:2]),
        .O(C[5:2]),
        .S({\grayscale[0]_INST_0_i_11_n_0 ,\grayscale[0]_INST_0_i_12_n_0 ,\grayscale[0]_INST_0_i_13_n_0 ,\grayscale[0]_INST_0_i_14_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_11 
       (.I0(b_weighted[5]),
        .I1(r_weighted[5]),
        .O(\grayscale[0]_INST_0_i_11_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_12 
       (.I0(b_weighted[4]),
        .I1(r_weighted[4]),
        .O(\grayscale[0]_INST_0_i_12_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_13 
       (.I0(b_weighted[3]),
        .I1(r_weighted[3]),
        .O(\grayscale[0]_INST_0_i_13_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_14 
       (.I0(b_weighted[2]),
        .I1(r_weighted[2]),
        .O(\grayscale[0]_INST_0_i_14_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_2 
       (.I0(g_weighted[8]),
        .I1(C[8]),
        .O(\grayscale[0]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_3 
       (.I0(g_weighted[7]),
        .I1(C[7]),
        .O(\grayscale[0]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_4 
       (.I0(g_weighted[6]),
        .I1(C[6]),
        .O(\grayscale[0]_INST_0_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_5 
       (.I0(g_weighted[5]),
        .I1(C[5]),
        .O(\grayscale[0]_INST_0_i_5_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_6 
       (.I0(g_weighted[4]),
        .I1(C[4]),
        .O(\grayscale[0]_INST_0_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_7 
       (.I0(g_weighted[3]),
        .I1(C[3]),
        .O(\grayscale[0]_INST_0_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_8 
       (.I0(g_weighted[2]),
        .I1(C[2]),
        .O(\grayscale[0]_INST_0_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[0]_INST_0_i_9 
       (.I0(g_weighted[1]),
        .I1(b_weighted[1]),
        .O(\grayscale[0]_INST_0_i_9_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \grayscale[1]_INST_0 
       (.CI(\grayscale[0]_INST_0_n_0 ),
        .CO({\grayscale[1]_INST_0_n_0 ,\grayscale[1]_INST_0_n_1 ,\grayscale[1]_INST_0_n_2 ,\grayscale[1]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI(g_weighted[12:9]),
        .O(grayscale[4:1]),
        .S({\grayscale[1]_INST_0_i_1_n_0 ,\grayscale[1]_INST_0_i_2_n_0 ,\grayscale[1]_INST_0_i_3_n_0 ,\grayscale[1]_INST_0_i_4_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[1]_INST_0_i_1 
       (.I0(g_weighted[12]),
        .I1(C[12]),
        .O(\grayscale[1]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[1]_INST_0_i_2 
       (.I0(g_weighted[11]),
        .I1(C[11]),
        .O(\grayscale[1]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[1]_INST_0_i_3 
       (.I0(g_weighted[10]),
        .I1(C[10]),
        .O(\grayscale[1]_INST_0_i_3_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[1]_INST_0_i_4 
       (.I0(g_weighted[9]),
        .I1(C[9]),
        .O(\grayscale[1]_INST_0_i_4_n_0 ));
  CARRY4 \grayscale[1]_INST_0_i_5 
       (.CI(\grayscale[0]_INST_0_i_10_n_0 ),
        .CO({\grayscale[1]_INST_0_i_5_n_0 ,\grayscale[1]_INST_0_i_5_n_1 ,\grayscale[1]_INST_0_i_5_n_2 ,\grayscale[1]_INST_0_i_5_n_3 }),
        .CYINIT(1'b0),
        .DI(b_weighted[9:6]),
        .O(C[9:6]),
        .S({\grayscale[1]_INST_0_i_6_n_0 ,\grayscale[1]_INST_0_i_7_n_0 ,\grayscale[1]_INST_0_i_8_n_0 ,\grayscale[1]_INST_0_i_9_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[1]_INST_0_i_6 
       (.I0(b_weighted[9]),
        .I1(r_weighted[9]),
        .O(\grayscale[1]_INST_0_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[1]_INST_0_i_7 
       (.I0(b_weighted[8]),
        .I1(r_weighted[8]),
        .O(\grayscale[1]_INST_0_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[1]_INST_0_i_8 
       (.I0(b_weighted[7]),
        .I1(r_weighted[7]),
        .O(\grayscale[1]_INST_0_i_8_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[1]_INST_0_i_9 
       (.I0(b_weighted[6]),
        .I1(r_weighted[6]),
        .O(\grayscale[1]_INST_0_i_9_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \grayscale[5]_INST_0 
       (.CI(\grayscale[1]_INST_0_n_0 ),
        .CO({\NLW_grayscale[5]_INST_0_CO_UNCONNECTED [3:2],\grayscale[5]_INST_0_n_2 ,\grayscale[5]_INST_0_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,g_weighted[14:13]}),
        .O({\NLW_grayscale[5]_INST_0_O_UNCONNECTED [3],grayscale[7:5]}),
        .S({1'b0,\grayscale[5]_INST_0_i_1_n_0 ,\grayscale[5]_INST_0_i_2_n_0 ,\grayscale[5]_INST_0_i_3_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[5]_INST_0_i_1 
       (.I0(g_weighted[15]),
        .I1(\grayscale[5]_INST_0_i_4_n_2 ),
        .O(\grayscale[5]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[5]_INST_0_i_2 
       (.I0(g_weighted[14]),
        .I1(C[14]),
        .O(\grayscale[5]_INST_0_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[5]_INST_0_i_3 
       (.I0(g_weighted[13]),
        .I1(C[13]),
        .O(\grayscale[5]_INST_0_i_3_n_0 ));
  CARRY4 \grayscale[5]_INST_0_i_4 
       (.CI(\grayscale[5]_INST_0_i_5_n_0 ),
        .CO({\NLW_grayscale[5]_INST_0_i_4_CO_UNCONNECTED [3:2],\grayscale[5]_INST_0_i_4_n_2 ,\NLW_grayscale[5]_INST_0_i_4_CO_UNCONNECTED [0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_grayscale[5]_INST_0_i_4_O_UNCONNECTED [3:1],C[14]}),
        .S({1'b0,1'b0,1'b1,r_weighted[14]}));
  CARRY4 \grayscale[5]_INST_0_i_5 
       (.CI(\grayscale[1]_INST_0_i_5_n_0 ),
        .CO({\grayscale[5]_INST_0_i_5_n_0 ,\grayscale[5]_INST_0_i_5_n_1 ,\grayscale[5]_INST_0_i_5_n_2 ,\grayscale[5]_INST_0_i_5_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,b_weighted[12:10]}),
        .O(C[13:10]),
        .S({r_weighted[13],\grayscale[5]_INST_0_i_6_n_0 ,\grayscale[5]_INST_0_i_7_n_0 ,\grayscale[5]_INST_0_i_8_n_0 }));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[5]_INST_0_i_6 
       (.I0(b_weighted[12]),
        .I1(r_weighted[12]),
        .O(\grayscale[5]_INST_0_i_6_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[5]_INST_0_i_7 
       (.I0(b_weighted[11]),
        .I1(r_weighted[11]),
        .O(\grayscale[5]_INST_0_i_7_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \grayscale[5]_INST_0_i_8 
       (.I0(b_weighted[10]),
        .I1(r_weighted[10]),
        .O(\grayscale[5]_INST_0_i_8_n_0 ));
  FDRE hsync_reg_reg
       (.C(clk),
        .CE(1'b1),
        .D(hsync_in),
        .Q(hsync_out),
        .R(1'b0));
  LUT2 #(
    .INIT(4'hE)) 
    \r_weighted[13]_i_2 
       (.I0(pixel_data[21]),
        .I1(pixel_data[23]),
        .O(\r_weighted[13]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \r_weighted[13]_i_3 
       (.I0(pixel_data[20]),
        .I1(pixel_data[22]),
        .O(\r_weighted[13]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \r_weighted[13]_i_4 
       (.I0(pixel_data[23]),
        .I1(pixel_data[21]),
        .I2(pixel_data[19]),
        .O(\r_weighted[13]_i_4_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \r_weighted[13]_i_5 
       (.I0(pixel_data[22]),
        .I1(pixel_data[23]),
        .O(\r_weighted[13]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'hE1)) 
    \r_weighted[13]_i_6 
       (.I0(pixel_data[23]),
        .I1(pixel_data[21]),
        .I2(pixel_data[22]),
        .O(\r_weighted[13]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'h1EE1)) 
    \r_weighted[13]_i_7 
       (.I0(pixel_data[22]),
        .I1(pixel_data[20]),
        .I2(pixel_data[23]),
        .I3(pixel_data[21]),
        .O(\r_weighted[13]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'h718E8E71)) 
    \r_weighted[13]_i_8 
       (.I0(pixel_data[19]),
        .I1(pixel_data[21]),
        .I2(pixel_data[23]),
        .I3(pixel_data[22]),
        .I4(pixel_data[20]),
        .O(\r_weighted[13]_i_8_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \r_weighted[14]_i_2 
       (.I0(pixel_data[23]),
        .O(\r_weighted[14]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \r_weighted[5]_i_2 
       (.I0(pixel_data[17]),
        .I1(pixel_data[19]),
        .O(\r_weighted[5]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h9)) 
    \r_weighted[5]_i_3 
       (.I0(pixel_data[16]),
        .I1(pixel_data[18]),
        .O(\r_weighted[5]_i_3_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \r_weighted[5]_i_4 
       (.I0(pixel_data[17]),
        .O(\r_weighted[5]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \r_weighted[9]_i_2 
       (.I0(pixel_data[22]),
        .I1(pixel_data[20]),
        .I2(pixel_data[18]),
        .O(\r_weighted[9]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \r_weighted[9]_i_3 
       (.I0(pixel_data[21]),
        .I1(pixel_data[19]),
        .I2(pixel_data[17]),
        .O(\r_weighted[9]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h69)) 
    \r_weighted[9]_i_4 
       (.I0(pixel_data[19]),
        .I1(pixel_data[21]),
        .I2(pixel_data[17]),
        .O(\r_weighted[9]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h8E71718E718E8E71)) 
    \r_weighted[9]_i_5 
       (.I0(pixel_data[18]),
        .I1(pixel_data[20]),
        .I2(pixel_data[22]),
        .I3(pixel_data[21]),
        .I4(pixel_data[23]),
        .I5(pixel_data[19]),
        .O(\r_weighted[9]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h8E71718E718E8E71)) 
    \r_weighted[9]_i_6 
       (.I0(pixel_data[17]),
        .I1(pixel_data[19]),
        .I2(pixel_data[21]),
        .I3(pixel_data[20]),
        .I4(pixel_data[22]),
        .I5(pixel_data[18]),
        .O(\r_weighted[9]_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h69966969)) 
    \r_weighted[9]_i_7 
       (.I0(pixel_data[19]),
        .I1(pixel_data[21]),
        .I2(pixel_data[17]),
        .I3(pixel_data[20]),
        .I4(pixel_data[18]),
        .O(\r_weighted[9]_i_7_n_0 ));
  LUT3 #(
    .INIT(8'h69)) 
    \r_weighted[9]_i_8 
       (.I0(pixel_data[20]),
        .I1(pixel_data[18]),
        .I2(pixel_data[16]),
        .O(\r_weighted[9]_i_8_n_0 ));
  FDRE \r_weighted_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[10]),
        .Q(r_weighted[10]),
        .R(1'b0));
  FDRE \r_weighted_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[11]),
        .Q(r_weighted[11]),
        .R(1'b0));
  FDRE \r_weighted_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[12]),
        .Q(r_weighted[12]),
        .R(1'b0));
  FDRE \r_weighted_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[13]),
        .Q(r_weighted[13]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x7}}" *) 
  CARRY4 \r_weighted_reg[13]_i_1 
       (.CI(\r_weighted_reg[9]_i_1_n_0 ),
        .CO({\r_weighted_reg[13]_i_1_n_0 ,\r_weighted_reg[13]_i_1_n_1 ,\r_weighted_reg[13]_i_1_n_2 ,\r_weighted_reg[13]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({pixel_data[22],\r_weighted[13]_i_2_n_0 ,\r_weighted[13]_i_3_n_0 ,\r_weighted[13]_i_4_n_0 }),
        .O(r_weighted0[13:10]),
        .S({\r_weighted[13]_i_5_n_0 ,\r_weighted[13]_i_6_n_0 ,\r_weighted[13]_i_7_n_0 ,\r_weighted[13]_i_8_n_0 }));
  FDRE \r_weighted_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[14]),
        .Q(r_weighted[14]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x7}}" *) 
  CARRY4 \r_weighted_reg[14]_i_1 
       (.CI(\r_weighted_reg[13]_i_1_n_0 ),
        .CO(\NLW_r_weighted_reg[14]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_r_weighted_reg[14]_i_1_O_UNCONNECTED [3:1],r_weighted0[14]}),
        .S({1'b0,1'b0,1'b0,\r_weighted[14]_i_2_n_0 }));
  FDRE \r_weighted_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[2]),
        .Q(r_weighted[2]),
        .R(1'b0));
  FDRE \r_weighted_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[3]),
        .Q(r_weighted[3]),
        .R(1'b0));
  FDRE \r_weighted_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[4]),
        .Q(r_weighted[4]),
        .R(1'b0));
  FDRE \r_weighted_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[5]),
        .Q(r_weighted[5]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x7}}" *) 
  CARRY4 \r_weighted_reg[5]_i_1 
       (.CI(1'b0),
        .CO({\r_weighted_reg[5]_i_1_n_0 ,\r_weighted_reg[5]_i_1_n_1 ,\r_weighted_reg[5]_i_1_n_2 ,\r_weighted_reg[5]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({pixel_data[17:16],1'b0,1'b1}),
        .O(r_weighted0[5:2]),
        .S({\r_weighted[5]_i_2_n_0 ,\r_weighted[5]_i_3_n_0 ,\r_weighted[5]_i_4_n_0 ,pixel_data[16]}));
  FDRE \r_weighted_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[6]),
        .Q(r_weighted[6]),
        .R(1'b0));
  FDRE \r_weighted_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[7]),
        .Q(r_weighted[7]),
        .R(1'b0));
  FDRE \r_weighted_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[8]),
        .Q(r_weighted[8]),
        .R(1'b0));
  FDRE \r_weighted_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(r_weighted0[9]),
        .Q(r_weighted[9]),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-9 {cell *THIS*} {string 8x7}}" *) 
  CARRY4 \r_weighted_reg[9]_i_1 
       (.CI(\r_weighted_reg[5]_i_1_n_0 ),
        .CO({\r_weighted_reg[9]_i_1_n_0 ,\r_weighted_reg[9]_i_1_n_1 ,\r_weighted_reg[9]_i_1_n_2 ,\r_weighted_reg[9]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({\r_weighted[9]_i_2_n_0 ,\r_weighted[9]_i_3_n_0 ,\r_weighted[9]_i_4_n_0 ,pixel_data[16]}),
        .O(r_weighted0[9:6]),
        .S({\r_weighted[9]_i_5_n_0 ,\r_weighted[9]_i_6_n_0 ,\r_weighted[9]_i_7_n_0 ,\r_weighted[9]_i_8_n_0 }));
  FDRE vde_reg_reg
       (.C(clk),
        .CE(1'b1),
        .D(vde_in),
        .Q(vde_out),
        .R(1'b0));
  FDRE vsync_reg_reg
       (.C(clk),
        .CE(1'b1),
        .D(vsync_in),
        .Q(vsync_out),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
