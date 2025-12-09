module corner_detector #(
    parameter THRESHOLD = 20
)(
    input logic clk,
    input logic rst_n,
    input logic valid_in,
    input logic [7:0] row0, row1, row2, row3, row4, row5, row6,
    input logic hsync_in,
    input logic vsync_in,
    input logic vde_in,
    output logic corner_detected,
    output logic valid_out,
    output logic [23:0] pixel_out,
    output logic hsync_out,
    output logic vsync_out,
    output logic vde_out
);
    localparam signed [8:0] STH = $signed({1'b0, THRESHOLD});

    // Create array for easier indexing
    logic [7:0] rows [6:0];
    assign rows[0] = row0;
    assign rows[1] = row1;
    assign rows[2] = row2;
    assign rows[3] = row3;
    assign rows[4] = row4;
    assign rows[5] = row5;
    assign rows[6] = row6;
    
    // Pipeline sync signals through 5 stages
    logic hsync_pipe [0:4];
    logic vsync_pipe [0:4];
    logic vde_pipe [0:4];
    logic [7:0] pixel_pipe [0:4];
    
    // 7x7 shift register
    reg [7:0] window [0:6][0:6];

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            for (int i = 0; i <= 4; i++) begin
                hsync_pipe[i] <= 0;
                vsync_pipe[i] <= 0;
                vde_pipe[i] <= 0;
                pixel_pipe[i] <= 0;
            end
        end else begin
            hsync_pipe[0] <= hsync_in;
            vsync_pipe[0] <= vsync_in;
            vde_pipe[0] <= vde_in;
            pixel_pipe[0] <= window[3][3];  // Center pixel
            
            // Propagate through stages 1-4
            for (int i = 1; i <= 4; i++) begin
                hsync_pipe[i] <= hsync_pipe[i-1];
                vsync_pipe[i] <= vsync_pipe[i-1];
                vde_pipe[i] <= vde_pipe[i-1];
                pixel_pipe[i] <= pixel_pipe[i-1];
            end
        end
        
        // Shift window
        if (valid_in) begin
            for (int i = 0; i < 7; i++) begin
                window[i][0] <= window[i][1];
                window[i][1] <= window[i][2];
                window[i][2] <= window[i][3];
                window[i][3] <= window[i][4];
                window[i][4] <= window[i][5];
                window[i][5] <= window[i][6];
                window[i][6] <= rows[i];
            end
        end
    end
    
    // Extract circle points
    logic [7:0] p [0:15];
    assign p[0]  = window[3][6];
    assign p[1]  = window[4][6];
    assign p[2]  = window[5][5];
    assign p[3]  = window[6][4];
    assign p[4]  = window[6][3];
    assign p[5]  = window[6][2];
    assign p[6]  = window[5][1];
    assign p[7]  = window[4][0];
    assign p[8]  = window[3][0];
    assign p[9]  = window[2][0];
    assign p[10] = window[1][1];
    assign p[11] = window[0][2];
    assign p[12] = window[0][3];
    assign p[13] = window[0][4];
    assign p[14] = window[1][5];
    assign p[15] = window[2][6];
    
    wire [7:0] center = window[3][3];

    // STAGE 1: Compute differences

    logic signed [8:0] diff [0:15];  // 9 bits to handle signed difference
    logic valid_stage1;
    
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            valid_stage1 <= 1'b0;
        end else begin
            for (int i = 0; i < 16; i++) begin
                diff[i] <= $signed({1'b0, p[i]}) - $signed({1'b0, center});
            end
            valid_stage1 <= valid_in;
        end
    end

    // STAGE 2: Compare differences to threshold

    logic is_brighter [0:15];
    logic is_darker [0:15];
    logic valid_stage2;
    
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            valid_stage2 <= 1'b0;
        end else begin
            for (int i = 0; i < 16; i++) begin
                is_brighter[i] <= (diff[i] >= STH);
                is_darker[i]   <= (diff[i] <= -STH);
            end
            valid_stage2 <= valid_stage1;
        end
    end

    // STAGE 3: Check 4 compass points

    logic [2:0] bright_compass_count;
    logic [2:0] dark_compass_count;
    logic passes_quick_test;
    logic valid_stage3;
    
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            valid_stage3 <= 1'b0;
        end else begin
            // Test indices 0, 4, 8, 12 (right, bottom, left, top)
            bright_compass_count <= is_brighter[0] + is_brighter[4] + is_brighter[8] + is_brighter[12];
            dark_compass_count   <= is_darker[0]   + is_darker[4]   + is_darker[8]   + is_darker[12];
            passes_quick_test <= (bright_compass_count >= 1) || (dark_compass_count >= 1);
            valid_stage3 <= valid_stage2;
        end
    end


    // STAGE 4: Check for 9 contiguous pixels

    logic has_9_contiguous;
    logic has_9_contiguous_comb;
    logic valid_stage4;
    
    // combinational logic for 9 contiguous check
    always_comb begin
        has_9_contiguous_comb = 1'b0;

        if (passes_quick_test) begin
            for (int start = 0; start < 16; start++) begin
                logic all_brighter;
                logic all_darker;
                
                all_brighter = 1'b1;
                all_darker = 1'b1;
                
                for (int i = 0; i < 9; i++) begin
                    int idx;
                    idx = (start + i) % 16;
                    all_brighter = all_brighter && is_brighter[idx];
                    all_darker = all_darker && is_darker[idx];
                end
                
                if (all_brighter || all_darker) begin
                    has_9_contiguous_comb = 1'b1;
                end
            end
        end
    end

    // sequential logic to register output
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            valid_stage4 <= 1'b0;
            has_9_contiguous <= 1'b0;
        end else begin
            has_9_contiguous <= has_9_contiguous_comb;
            valid_stage4 <= valid_stage3;
        end
    end

    
    // Output assignments
    assign corner_detected = has_9_contiguous;
    assign valid_out = valid_stage4;
    assign pixel_out = (has_9_contiguous) ? 24'h00FF00 : {pixel_pipe[4], pixel_pipe[4], pixel_pipe[4]};
    assign hsync_out = hsync_pipe[4];
    assign vsync_out = vsync_pipe[4];
    assign vde_out = vde_pipe[4];

endmodule