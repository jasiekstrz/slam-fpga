module fast_brief_integrated #(
    parameter IMG_WIDTH = 1280,
    parameter IMG_HEIGHT = 720,
    parameter PIXEL_WIDTH = 8,
    // AXI Stream Parameters
    parameter AXIS_WIDTH = 280, // 256 (desc) + 11 (x) + 11 (y) + 2 (padding)
    parameter MAX_CORNERS = 1000 // Throttle to prevent Matcher overflow
)(
    input  logic clk,
    input  logic rst_n,
    
    // Video input
    input  logic pixel_valid,
    input  logic [PIXEL_WIDTH-1:0] pixel_in,
    input  logic hsync_in,
    input  logic vsync_in,
    input  logic vde_in,
    input  logic frame_start,
    
    // Video output (passthrough with corner marking)
    output logic [23:0] pixel_out,
    output logic hsync_out,
    output logic vsync_out,
    output logic vde_out,
    
    // AXI4-Stream Master Output (Connect to FIFO)
    output logic [AXIS_WIDTH-1:0] m_axis_tdata,
    output logic m_axis_tvalid,
    output logic m_axis_tlast,
    input  logic m_axis_tready // Input from FIFO (Backpressure)
);
    
    // Shared line buffers (31 lines for BRIEF, center 7 for FAST)
    logic [PIXEL_WIDTH-1:0] fast_rows [0:6];
    logic [PIXEL_WIDTH-1:0] brief_rows [0:30];
    
    shared_line_buffers #(
        .WIDTH(1280),
        .DATA_WIDTH(PIXEL_WIDTH),
        .TOTAL_LINES(31),
        .FAST_LINES(7)
    ) linebuf (
        .clk(clk),
        .rst_n(rst_n),
        .pixel_in(pixel_in),
        .valid_in(pixel_valid),
        .fast_rows(fast_rows),
        .brief_rows(brief_rows)
    );
    
    logic corner_detected;
    // Internal coordinate tracking
    logic [10:0] corner_x, corner_y;
    
    logic hsync_delayed, vsync_delayed, vde_delayed;

    // Delay sync signals by WIDTH*15 + 15 cycles
    sync_delay #(
        .WIDTH(1650),
        .DELAY_ROWS(15),
        .DELAY_COLS(15)
    ) sync_delay_inst (
        .clk(clk),
        .rst_n(rst_n),
        .hsync_in(hsync_in),
        .vsync_in(vsync_in),
        .vde_in(vde_in),
        .hsync_out(hsync_delayed),
        .vsync_out(vsync_delayed),
        .vde_out(vde_delayed)
    );

    logic [7:0] row0, row1, row2, row3, row4, row5, row6;
    assign row0 = fast_rows[0];
    assign row1 = fast_rows[1];
    assign row2 = fast_rows[2];
    assign row3 = fast_rows[3];
    assign row4 = fast_rows[4];
    assign row5 = fast_rows[5];
    assign row6 = fast_rows[6];

    logic valid_out;
    
    // FAST corner detector
    corner_detector #(
        .THRESHOLD(20)
    ) corner_det_inst (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(vde_delayed),
        .row0(row0), .row1(row1), .row2(row2), .row3(row3),
        .row4(row4), .row5(row5), .row6(row6),
        .hsync_in(hsync_delayed),  
        .vsync_in(vsync_delayed),
        .vde_in(vde_delayed),
        .corner_detected(corner_detected),
        .valid_out(valid_out),
        .pixel_out(pixel_out),
        .hsync_out(hsync_out),    
        .vsync_out(vsync_out),
        .vde_out(vde_out)
    );

    // X/Y Counter Logic
    // Reset counters on VSYNC to ensure alignment every frame
    always_ff @(posedge clk) begin
        if (!rst_n || vsync_out) begin // Added vsync reset for safety
            corner_x <= 0;
            corner_y <= 0;
        end else if (vde_out) begin
            if (corner_x == IMG_WIDTH - 1) begin
                corner_x <= 0;
                if (corner_y == IMG_HEIGHT - 1) corner_y <= 0;
                else corner_y <= corner_y + 1;
            end else begin
                corner_x <= corner_x + 1;
            end
        end
    end
    
    // Descriptor Internal Signals
    logic [255:0] descriptor;
    logic descriptor_valid;
    logic [10:0] descriptor_x, descriptor_y;

    // BRIEF descriptor
    brief_descriptor_fast #(
        .PATCH_SIZE(31),
        .N_BITS(256),
        .PIXEL_WIDTH(PIXEL_WIDTH)
    ) brief_inst (
        .clk(clk),
        .rst_n(rst_n),
        .brief_rows(brief_rows),
        .pixel_valid(pixel_valid),
        .corner_detected(corner_detected),
        .corner_x(corner_x),
        .corner_y(corner_y),
        .descriptor(descriptor),
        .descriptor_valid(descriptor_valid),
        .descriptor_x(descriptor_x),
        .descriptor_y(descriptor_y)
    );


    logic [10:0] corner_cnt;
    
    always_ff @(posedge clk) begin
        if (!rst_n || vsync_in) begin
            corner_cnt <= 0;
        end else if (descriptor_valid) begin
            if (corner_cnt < MAX_CORNERS) 
                corner_cnt <= corner_cnt + 1;
        end
    end

    logic vsync_r;
    logic send_eof; // Send End-Of-Frame
    
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            vsync_r <= 0;
            send_eof <= 0;
        end else begin
            vsync_r <= vsync_in;
            // Rising edge of VSYNC indicates start of new frame / end of old
            if (vsync_in && !vsync_r) 
                send_eof <= 1;
            else if (m_axis_tready) // Clear flag once accepted
                send_eof <= 0;
        end
    end

    always_comb begin
        m_axis_tvalid = 0;
        m_axis_tlast  = 0;
        m_axis_tdata  = 0;

        // If FIFO is full (ready=0), MUST drop data.
        // Only assert valid if ready is high.
        if (m_axis_tready) begin
            
            if (send_eof) begin
                m_axis_tvalid = 1;
                m_axis_tlast  = 1;
                m_axis_tdata  = 0; 
            end
            else if (descriptor_valid && (corner_cnt < MAX_CORNERS)) begin
                m_axis_tvalid = 1;
                m_axis_tlast  = 0;
                
                // Pack Structure for Partner's Module:
                // struct { y[10:0], x[10:0], desc[255:0] }
                // Padded to 280 bits: { 2'b00, Y, X, DESC }
                m_axis_tdata = {2'b00, descriptor_y, descriptor_x, descriptor};
            end
        end
    end
    
endmodule