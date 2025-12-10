`timescale 1ns / 1ps


module rgb_to_grayscale(
        input logic clk,
        input logic [23:0] pixel_data,
        input logic hsync_in,
        input logic vsync_in,
        input logic vde_in,
        output logic [7:0] grayscale,
        output logic hsync_out,
        output logic vsync_out,
        output logic vde_out
    );
    
    logic [15:0] r_weighted;
    logic [15:0] g_weighted;
    logic [15:0] b_weighted;
    logic [17:0] sum_weighted;
    
    always_ff @(posedge clk) begin
        r_weighted <= 76 * pixel_data[23:16];
        g_weighted <= 150 * pixel_data[15:8];
        b_weighted <= 29 * pixel_data[7:0];
    
        hsync_out <= hsync_in;
        vsync_out <= vsync_in;
        vde_out <= vde_in;
    end
    
    assign sum_weighted = r_weighted + g_weighted + b_weighted;
    assign grayscale = sum_weighted >> 8;
endmodule
