
`timescale 1 ns / 1 ps

	module feature_matcher #
	(
		parameter integer C_S00_AXIS_TDATA_WIDTH = 280,
        parameter integer C_M00_AXIS_TDATA_WIDTH = 64,
        parameter integer NUM_BITS = 256,
        parameter integer NUM_CORNERS = 1024,
        parameter integer KEY_SIZE = 9,
        parameter integer IDX_SIZE = 11
	)
	(
		input wire  s00_axis_aclk, s00_axis_aresetn,
        input wire  s00_axis_tlast, s00_axis_tvalid,
        input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
        output wire s00_axis_tready,
    
        input wire  m00_axis_aclk, m00_axis_aresetn,
        input wire  m00_axis_tready,
        output wire m00_axis_tvalid, m00_axis_tlast,
        output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
        output wire [(C_M00_AXIS_TDATA_WIDTH/8) - 1:0] m00_axis_tkeep
	);
   
        assign m00_axis_tkeep = {(C_M00_AXIS_TDATA_WIDTH/8){1'b1}};
        nn #(
            .C_S00_AXIS_TDATA_WIDTH(C_S00_AXIS_TDATA_WIDTH),
            .C_M00_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
            .NUM_BITS(NUM_BITS),
            .NUM_CORNERS(NUM_CORNERS),
            .KEY_SIZE(KEY_SIZE),
            .IDX_SIZE(IDX_SIZE)
        ) matcher (
            .s00_axis_aclk(s00_axis_aclk),
            .s00_axis_aresetn(s00_axis_aresetn),
            .s00_axis_tlast(s00_axis_tlast),
            .s00_axis_tvalid(s00_axis_tvalid),
            .s00_axis_tdata(s00_axis_tdata),
            .s00_axis_tready(s00_axis_tready),
        
            .m00_axis_aclk(m00_axis_aclk),
            .m00_axis_aresetn(m00_axis_aresetn),
            .m00_axis_tready(m00_axis_tready),
            .m00_axis_tvalid(m00_axis_tvalid),
            .m00_axis_tlast(m00_axis_tlast),
            .m00_axis_tdata(m00_axis_tdata)
        );

	endmodule
