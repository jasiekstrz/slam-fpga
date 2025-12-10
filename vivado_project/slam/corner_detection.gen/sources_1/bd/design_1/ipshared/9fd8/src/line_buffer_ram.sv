module shared_line_buffers #(
    parameter WIDTH = 1280,
    parameter DATA_WIDTH = 8,
    parameter TOTAL_LINES = 31,  // Enough for BRIEF
    parameter FAST_LINES = 7     // FAST only needs 7
)(
    input  logic clk,
    input  logic rst_n,
    input  logic [DATA_WIDTH-1:0] pixel_in,
    input  logic valid_in,
    
    output logic [DATA_WIDTH-1:0] fast_rows [0:FAST_LINES-1],

    output logic [DATA_WIDTH-1:0] brief_rows [0:TOTAL_LINES-1]
);

    logic [DATA_WIDTH-1:0] taps [0:TOTAL_LINES-1];
    
    assign taps[0] = pixel_in;

    genvar i;
    generate
        for (i = 0; i < TOTAL_LINES - 1; i++) begin : gen_line_bufs
            line_buffer_ram #(
                .WIDTH(WIDTH),
                .DATA_WIDTH(DATA_WIDTH)
            ) lb_inst (
                .clk(clk),
                .en(valid_in),
                .din(taps[i]),    // Input from previous stage
                .dout(taps[i+1])  // Output to next stage
            );
        end
    endgenerate


    always_comb begin
        for (int j = 0; j < TOTAL_LINES; j++) begin
            brief_rows[j] = taps[TOTAL_LINES - 1 - j];
        end
    end

    localparam FAST_OFFSET = (TOTAL_LINES - FAST_LINES) / 2;
    
    always_comb begin
        for (int k = 0; k < FAST_LINES; k++) begin
            fast_rows[k] = brief_rows[FAST_OFFSET + k];
        end
    end

endmodule

module line_buffer_ram #(
    parameter WIDTH = 1280,
    parameter DATA_WIDTH = 8
)(
    input logic clk,
    input logic en,
    input logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout
);
    // BRAM inference style
    (* ram_style = "block" *)
    logic [DATA_WIDTH-1:0] mem [0:WIDTH-1];
    logic [$clog2(WIDTH)-1:0] ptr;

    always_ff @(posedge clk) begin
        if (en) begin
            mem[ptr] <= din;
            ptr <= (ptr == WIDTH - 1) ? 0 : ptr + 1;
            dout <= mem[ptr];
        end
    end
    
    // assign dout = mem[ptr];

    initial ptr = 0;
endmodule

