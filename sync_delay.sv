module sync_delay #(
    parameter WIDTH = 1650, // Total line width
    parameter DELAY_ROWS = 15,
    parameter DELAY_COLS = 15
)(
    input  logic clk,
    input  logic rst_n, /
    input  logic hsync_in,
    input  logic vsync_in,
    input  logic vde_in,
    output logic hsync_out,
    output logic vsync_out,
    output logic vde_out
);

    localparam DEPTH = (DELAY_ROWS * WIDTH) + DELAY_COLS;
    
    // Combine signals into one 3-bit vector
    logic [2:0] din, dout;
    assign din = {hsync_in, vsync_in, vde_in};
    assign {hsync_out, vsync_out, vde_out} = dout;

    
    logic fifo_full, fifo_empty;
    logic rd_en;
    logic [2:0] fifo_dout;
    
    logic [$clog2(DEPTH):0] count;
    logic delaying;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            count <= 0;
            delaying <= 1;
            rd_en <= 0;
        end else begin
            
            if (delaying) begin
                count <= count + 1;
                if (count >= DEPTH - 1) begin
                    delaying <= 0;
                    rd_en <= 1; // Start reading forever
                end
            end
        end
    end

    xpm_fifo_sync #(
        .DOUT_RESET_VALUE("0"),
        .ECC_MODE("no_ecc"),
        .FIFO_MEMORY_TYPE("auto"),
        .FIFO_READ_LATENCY(1),
        .FIFO_WRITE_DEPTH(32768), 
        .READ_DATA_WIDTH(3),
        .READ_MODE("std"),
        .WRITE_DATA_WIDTH(3)
    ) xpm_fifo_inst (
        .data_valid(),
        .dout(dout),
        .empty(fifo_empty),
        .full(fifo_full),
        .overflow(),
        .prog_empty(),
        .prog_full(),
        .rd_data_count(),
        .rd_rst_busy(),
        .underflow(),
        .wr_ack(),
        .wr_data_count(),
        .wr_rst_busy(),
        .din(din),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rd_en(rd_en),
        .rst(!rst_n), 
        .sleep(1'b0),
        .wr_clk(clk),
        .wr_en(1'b1) 
    );

endmodule