module frame_counter_axis #
    (
        parameter integer C_S00_AXIS_TDATA_WIDTH    = 32,
        parameter integer C_M00_AXIS_TDATA_WIDTH    = 32
    )
    (
        input logic [NUM_FRAME_SIZE-1:0] num_frames,
 
        // Ports of Axi Slave Bus Interface S00_AXIS
        input wire  s00_axis_aclk, s00_axis_aresetn,
        input wire  s00_axis_tlast, s00_axis_tvalid,
        input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
        input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1: 0] s00_axis_tstrb,
        output logic  s00_axis_tready,
 
        // Ports of Axi Master Bus Interface M00_AXIS
        input wire  m00_axis_aclk, m00_axis_aresetn,
        input wire  m00_axis_tready,
        output logic  m00_axis_tvalid, m00_axis_tlast,
        output logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
        output logic [(C_M00_AXIS_TDATA_WIDTH/8)-1: 0] m00_axis_tstrb
    );

    localparam NUM_FRAME_SIZE = 4;
    

    logic [NUM_FRAME_SIZE-1:0] cnt;


    assign m00_axis_tdata = s00_axis_tdata;
    assign m00_axis_tstrb = s00_axis_tstrb;
    assign m00_axis_tlast = s00_axis_tlast && (cnt == 0);
    assign m00_axis_tvalid = s00_axis_tvalid && (cnt == 0);
    assign s00_axis_tready = m00_axis_tready;


    always_ff @(posedge s00_axis_aclk) begin
        if (s00_axis_aresetn == 0) begin
            cnt <= 0;
        end else begin
            if (s00_axis_tvalid && s00_axis_tready && s00_axis_tlast) begin
                if (cnt == num_frames-1) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt+1;
                end
            end
        end
    end
endmodule

