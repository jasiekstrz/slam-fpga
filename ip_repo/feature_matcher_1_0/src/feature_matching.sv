module nn #(
    parameter integer C_S00_AXIS_TDATA_WIDTH = 280,
    parameter integer C_M00_AXIS_TDATA_WIDTH = 280,
    parameter integer NUM_BITS = 256,
    parameter integer NUM_CORNERS = 1024,
    parameter integer KEY_SIZE = 9,
    parameter integer IDX_SIZE = 11
)(
    input wire  s00_axis_aclk, s00_axis_aresetn,
    input wire  s00_axis_tlast, s00_axis_tvalid,
    input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
    output logic s00_axis_tready,

    input wire  m00_axis_aclk, m00_axis_aresetn,
    input wire  m00_axis_tready,
    output logic m00_axis_tvalid, m00_axis_tlast,
    output logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata
);

    typedef struct packed {
        logic [10:0] y;
        logic [10:0] x;
        logic [NUM_BITS-1:0] desc;
    } corner_t;

    typedef struct packed {
        logic [10:0] y_prev;
        logic [10:0] x_prev;
        logic [10:0] y_curr;
        logic [10:0] x_curr;
        logic [8:0] dist_out;
        logic [10:0] padding;
    } match_out_t;

    (* ram_style = "block" *)
    corner_t mem_bank0 [0:NUM_CORNERS-1];
    (* ram_style = "block" *)
    corner_t mem_bank1 [0:NUM_CORNERS-1];
    
    logic wr_en;
    logic [C_S00_AXIS_TDATA_WIDTH-1 : 0] wr_data;
    
    assign wr_en = (state == IDLE) && s00_axis_tvalid && s00_axis_tready;
    assign wr_data = s00_axis_tdata;

    typedef enum {IDLE, MATCH_READ, MATCH_CALC, OUTPUT_MATCH} state_t;
    state_t state;

    logic bank_sel;
    logic [IDX_SIZE-1:0] wr_ptr;
    logic [IDX_SIZE-1:0] prev_frame_count;
    
    corner_t current_corner;
    corner_t compare_corner; // Output of BRAM read
    corner_t best_corner_data;
    corner_t second_best_corner_data;
    
    logic [KEY_SIZE-1:0] D1;
    logic [KEY_SIZE-1:0] D2;
    logic [IDX_SIZE-1:0] match_iterator;
    logic processing_last_pixel;

    function automatic logic [KEY_SIZE-1:0] popcount 
    (
        input logic [NUM_BITS-1:0] d_in
    );
        logic [KEY_SIZE-1:0] sum = 0;
        for (integer i = 0; i < NUM_BITS; i = i + 1) begin
            sum = sum + d_in[i];
        end
        return sum;
    endfunction
    
    
    always_ff @(posedge s00_axis_aclk) begin
        if (wr_en && (bank_sel == 0)) begin
            mem_bank0[wr_ptr] <= wr_data;
        end else if (wr_en && (bank_sel == 1)) begin
            mem_bank1[wr_ptr] <= wr_data;
        end
        
        if (bank_sel == 1) begin
            compare_corner <= mem_bank0[match_iterator];
        end else begin
            compare_corner <= mem_bank1[match_iterator];
        end
    end


    always_ff @(posedge s00_axis_aclk) begin
        if (!s00_axis_aresetn) begin
            state <= IDLE;
            bank_sel <= 0;
            wr_ptr <= 0;
            prev_frame_count <= 0;
            s00_axis_tready <= 0;
            m00_axis_tvalid <= 0;
            processing_last_pixel <= 0;
            D1 <= 256;
            D2 <= 256;
        end else begin
            case (state)
                IDLE: begin
                    s00_axis_tready <= 1;
                    m00_axis_tvalid <= 0;
                    
                    if (s00_axis_tvalid && s00_axis_tready) begin
                        current_corner <= s00_axis_tdata;
                        
                        // Write to current bank
//                        if (bank_sel == 0) begin
//                            mem_bank0[wr_ptr] <= s00_axis_tdata;
//                        end else begin
//                            mem_bank1[wr_ptr] <= s00_axis_tdata;
//                        end

                        // Increment Pointer
                        if (wr_ptr < NUM_CORNERS-1) begin
                            wr_ptr <= wr_ptr + 1;
                        end

                        processing_last_pixel <= s00_axis_tlast;
                        
                        // Setup Matching
                        s00_axis_tready <= 0;
                        match_iterator <= 0;
                        D1 <= 256;
                        D2 <= 256;
                        
                        // If there are no corners in previous frame, skip matching
                        if (prev_frame_count == 0) begin
                            state <= OUTPUT_MATCH;
                        end else begin
                            state <= MATCH_READ;
                        end
                    end
                end

                // wait one cycle for BRAM to output data
                MATCH_READ: begin
                    state <= MATCH_CALC;
                end

                MATCH_CALC: begin
                    logic [KEY_SIZE-1:0] tdist;
                    tdist = popcount(current_corner.desc ^ compare_corner.desc);

                    if (tdist < D1) begin
                        D2 <= D1;
                        second_best_corner_data <= best_corner_data;

                        D1 <= tdist;
                        best_corner_data <= compare_corner; 
                    end else if (tdist < D2) begin
                        D2 <= tdist;
                        second_best_corner_data <= compare_corner;
                    end

                    // Loop Logic
                    if (match_iterator < prev_frame_count - 1) begin
                        match_iterator <= match_iterator + 1;
                        state <= MATCH_READ;
                    end else begin
                        state <= OUTPUT_MATCH;
                    end
                end

                OUTPUT_MATCH: begin
                    if (D1 < 40) begin
                        if (D2 > 0 && D1 * 5 < D2 * 4) begin
                            match_out_t match_packet;
                            match_packet.x_curr = current_corner.x;
                            match_packet.y_curr = current_corner.y;
                            match_packet.x_prev = best_corner_data.x;
                            match_packet.y_prev = best_corner_data.y;
                            match_packet.dist_out   = D1;
                            match_packet.padding = 11'b0;

                            m00_axis_tdata <= match_packet;
                            m00_axis_tvalid <= 1;
                        end
                    end

                    // Frame Swap Logic
                    if (processing_last_pixel) begin
                        bank_sel <= ~bank_sel;
                        prev_frame_count <= wr_ptr; // wr_ptr is the total count of the frame just finished
                        wr_ptr <= 0;
                        m00_axis_tlast <= 1;
                    end else begin
                        m00_axis_tlast <= 0;
                    end
                    
                    state <= IDLE;
                end
            endcase
        end
    end


endmodule