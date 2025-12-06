module fast_brief_integrated #(
    parameter IMG_WIDTH = 1280,
    parameter IMG_HEIGHT = 720,
    parameter PIXEL_WIDTH = 8
)(
    input  logic clk,
    input  logic rst_n,
    
    // Video input
    input  logic pixel_valid,
    input  logic [PIXEL_WIDTH-1:0] pixel_in,
    input logic hsync_in,
    input logic vsync_in,
    input logic vde_in,
    input  logic frame_start,
    
    // Video output (passthrough with corner marking)
    output logic [23:0] pixel_out,
    output logic hsync_out,
    output logic vsync_out,
    output logic vde_out,
    
    // Descriptor output
    output logic [255:0] descriptor,
    output logic descriptor_valid,
    output logic [10:0] descriptor_x,
    output logic [10:0] descriptor_y
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
    logic [10:0] corner_x, corner_y;
    

    logic hsync_delayed, vsync_delayed, vde_delayed;
    
    logic hsync_final, vsync_final, vde_final;

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
        .row0(row0),
        .row1(row1),
        .row2(row2),
        .row3(row3),
        .row4(row4),
        .row5(row5),
        .row6(row6),
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

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            corner_x <= 0;
            corner_y <= 0;
        end else if (vde_out) begin
            if (corner_y == IMG_HEIGHT - 1 && corner_x == IMG_WIDTH - 1) begin
                corner_x <= 0;
                corner_y <= 0;
            end else if (corner_x == IMG_WIDTH - 1) begin
                corner_x <= 0;
                corner_y <= corner_y + 1;
            end else begin
                corner_x <= corner_x + 1;
            end
        end
    end
    
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
        .descriptor_y(descriptor_y),
    );

    
endmodule