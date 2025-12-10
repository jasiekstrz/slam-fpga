`timescale 1ns / 1ps


module frame_counter_wrapper (
        input wire [7:0] num_frames,

        input wire clk,
        input wire rst_n,

        input wire [23:0] pixel_data_in,
        input wire hsync_in,
        input wire vsync_in,
        input wire vde_in,
 
        output wire [23:0] pixel_data_out,
        output wire hsync_out,
        output wire vsync_out,
        output wire vde_out
);

    frame_counter frame_cnt (
        .clk(clk),
        .arst(rst_n),
        .pixel_data_in(pixel_data_in),
        .hsync_in(hsync_in),
        .vsync_in(vsync_in),
        .vde_in(vde_in),
        .pixel_data_out(pixel_data_out),
        .hsync_out(hsync_out),
        .vsync_out(vsync_out),
        .vde_out(vde_out)
    );
endmodule
