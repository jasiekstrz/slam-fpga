`timescale 1ns / 1ps
module rgb_to_grayscale_wrapper(
        input  clk,
        input  [23:0] pixel_data,
        input  hsync_in,
        input  vsync_in,
        input  vde_in,
        output  [7:0] grayscale,
        output  hsync_out,
        output  vsync_out,
        output  vde_out
    );
    
    reg [15:0] r_weighted;
    reg [15:0] g_weighted;
    reg [15:0] b_weighted;
    wire [17:0] sum_weighted;
    reg hsync_reg;
    reg vsync_reg;
    reg vde_reg;
    
    always @(posedge clk) begin
        r_weighted <= 76 * pixel_data[23:16];
        g_weighted <= 150 * pixel_data[15:8];
        b_weighted <= 29 * pixel_data[7:0];
    
        hsync_reg <= hsync_in;
        vsync_reg <= vsync_in;
        vde_reg <= vde_in;
    end
    
    assign sum_weighted = r_weighted + g_weighted + b_weighted;
    assign grayscale = sum_weighted >> 8;
    assign hsync_out = hsync_reg;
    assign vsync_out = vsync_reg;
    assign vde_out = vde_reg;
endmodule
