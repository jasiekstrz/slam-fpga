
`timescale 1 ns / 1 ps

	module fast_brief #
	(
		// Users to add parameters here
		parameter IMG_WIDTH = 1280,
        parameter IMG_HEIGHT = 720,
        parameter PIXEL_WIDTH = 8,
        // AXI Stream Parameters
        parameter AXIS_WIDTH = 280, // 256 (desc) + 11 (x) + 11 (y) + 2 (padding)
        parameter MAX_CORNERS = 1000 // Throttle to prevent Matcher overflow

	)(
		input  wire clk,
        input  wire rst_n,
        
        // Video input
        input  wire pixel_valid,
        input  wire [PIXEL_WIDTH-1:0] pixel_in,
        input  wire hsync_in,
        input  wire vsync_in,
        input  wire vde_in,
        input  wire frame_start,
        
        // Video output (passthrough with corner marking)
        output wire [23:0] pixel_out,
        output wire hsync_out,
        output wire vsync_out,
        output wire vde_out,
        
        // AXI4-Stream Master Output (Connect to FIFO)
        output wire [AXIS_WIDTH-1:0] m_axis_tdata,
        output wire m_axis_tvalid,
        output wire m_axis_tlast,
        input  wire m_axis_tready // Input from FIFO (Backpressure)
	);

    fast_brief_integrated #(
        .IMG_WIDTH(IMG_WIDTH),
        .IMG_HEIGHT(IMG_HEIGHT),
        .PIXEL_WIDTH(PIXEL_WIDTH),
        .AXIS_WIDTH(AXIS_WIDTH),
        .MAX_CORNERS(MAX_CORNERS)
        
        ) mod (
            .clk(clk),
            .rst_n(rst_n),
            .pixel_valid(pixel_valid),
            .pixel_in(pixel_in),
            .hsync_in(hsync_in),
            .vsync_in(vsync_in),
            .vde_in(vde_in),
            .frame_start(frame_start),
            .pixel_out(pixel_out),
            .hsync_out(hsync_out),
            .vsync_out(vsync_out),
            .vde_out(vde_out),
            .m_axis_tdata(m_axis_tdata),
            .m_axis_tvalid(m_axis_tvalid),
            .m_axis_tlast(m_axis_tlast),
            .m_axis_tready(m_axis_tready)
        
        );

	endmodule
