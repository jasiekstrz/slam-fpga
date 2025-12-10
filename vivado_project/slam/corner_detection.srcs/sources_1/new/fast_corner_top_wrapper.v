`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2025 05:44:58 PM
// Design Name: 
// Module Name: fast_corner_top_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fast_corner_top_wrapper #(
    parameter WIDTH = 1280,
    parameter THRESHOLD = 20
)(
    input wire clk,
    input wire rst_n,
    input wire [7:0] pixel_in,
    input wire hsync_in,
    input wire vsync_in,
    input wire vde_in,
    input wire valid_in,
    output wire corner_detected,
    output wire valid_out,
    // output logic [55:0] debug_data
    output wire [23:0] pixel_out,
    output wire hsync_out,
    output wire vsync_out,
    output wire vde_out
);

    fast_corner_top #(
        .WIDTH(WIDTH),
        .THRESHOLD(20)
    ) fast_detector (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_in(pixel_in),
        .hsync_in(hsync_in),
        .vsync_in(vsync_in),
        .vde_in(vde_in),
        .valid_in(valid_in),
        .corner_detected(corner_detected),
        .valid_out(valid_out),
        .pixel_out(pixel_out),
        .hsync_out(hsync_out),
        .vsync_out(vsync_out),
        .vde_out(vde_out)
    );
endmodule
