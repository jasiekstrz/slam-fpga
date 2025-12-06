



module nn #
    (
        parameter integer C_S00_AXIS_TDATA_WIDTH    = 32,
        parameter integer C_M00_AXIS_TDATA_WIDTH    = 32
    )
    (
 
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
    localparam NUM_BITS = 8;
    localparam NUM_CORNERS = 20;
    localparam KEY_SIZE = $clog2(NUM_BITS)+1;
    localparam IDX_SIZE = $clog2(NUM_CORNERS)+1;
    localparam B_PAR = 5;
    localparam MAX_IDX = NUM_CORNERS - B_PAR;
    localparam RATIO = 2;


    typedef struct packed {
        logic [NUM_BITS-1:0] desc;
    } corner_t;

    typedef struct packed {
        logic [KEY_SIZE-1:0] dist1;
        logic [KEY_SIZE-1:0] dist2;
        corner_t a;
        corner_t b;
    } match_t;


    corner_t [NUM_CORNERS-1:0] b_val;
    logic [NUM_CORNERS:0] b_valid;

    corner_t [NUM_CORNERS-1:0] a_val;
    logic [NUM_CORNERS:0] a_valid;

    match_t best_match;

    logic [IDX_SIZE-1:0] cur_idx;

    logic a_ready, a_last;



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



    assign m00_axis_tstrb = {C_M00_AXIS_TDATA_WIDTH/8{1'b1}};
    assign s00_axis_tready = (!a_ready || cur_idx >= MAX_IDX);





    always_ff @(posedge s00_axis_aclk) begin
        if (s00_axis_aresetn == 0) begin
            a_val <= 0;
            a_valid <= 0;
            b_val <= 0;
            b_valid <= 0;
            //for (integer i = 0; i < NUM_CORNERS; i = i + 1) begin
            //    a_val[i] <= 0;
            //    b_val[i] <= 0;
            //end
            cur_idx <= 0;
            best_match.dist1 <= NUM_BITS;
            best_match.dist2 <= NUM_BITS;
            best_match.a <= 0;
            best_match.b <= 0;
            m00_axis_tvalid <= 0;
            a_ready <= 0;
            a_last <= 0;

        end else begin
            logic [NUM_CORNERS-1:0] new_a_valid;
            new_a_valid = a_valid;

            if (a_ready) begin
                match_t best_tmp;
                best_tmp = best_match;
                for (integer bi = 0; bi < B_PAR; bi = bi + 1) begin
                    if (b_valid[cur_idx+bi]) begin
                        logic [NUM_BITS-1:0] a_desc;
                        logic [NUM_BITS-1:0] b_desc;
                        logic [KEY_SIZE-1:0] new_dist;
                        a_desc = a_val[0].desc;
                        b_desc = b_val[cur_idx+bi].desc;
                        new_dist = popcount(a_desc ^ b_desc);
                        //$display("Iteration %0d: a_desc = %0b", bi, a_desc);
                        //$display("Iteration %0d: b_desc = %0b", bi, b_desc);
                        //$display("Iteration %0d: new_dist = %0d", bi, new_dist);
                        //$display("Iteration %0d: best_tmp = %0b", bi, best_tmp);
                        if (new_dist < best_tmp.dist1) begin
                            //best_tmp.dist2 = best_tmp.dist1;
                            //best_tmp.dist1 = new_dist;
                            //best_tmp.a = a_val[0];
                            //best_tmp.b = b_val[cur_idx+bi];
                            best_tmp = {new_dist, best_tmp.dist1, a_val[0], b_val[cur_idx+bi]};
                        end else if (new_dist < best_tmp.dist2) begin
                            //best_tmp.dist2 = new_dist;
                            best_tmp = {best_tmp.dist1, new_dist, best_tmp.a, best_tmp.b};
                        end
                    end
                end           
                if (cur_idx < MAX_IDX) begin
                    best_match <= best_tmp;
                    cur_idx <= cur_idx + B_PAR;
                    m00_axis_tvalid <= 0;
                end else begin
                    cur_idx <= 0;
                    best_match.dist1 <= NUM_BITS;
                    best_match.dist2 <= NUM_BITS;
                    best_match.a <= 0;
                    best_match.b <= 0;
                    m00_axis_tvalid <= 1;
                    m00_axis_tdata <= best_tmp;
                    m00_axis_tlast <= a_last;

                    if (a_last) begin
                        //for (integer i = 0; i < NUM_CORNERS; i = i + 1) begin
                        //    b_val[i] <= a_val[i];
                        //end
                        //$display("CHANGE a_val:%0b a_valid:%0b", a_val, a_valid);
                        b_val <= a_val;
                        b_valid <= a_valid;
                        new_a_valid = 0;
                    end
                end
            end else begin
                m00_axis_tvalid <= 0;
            end

            if (s00_axis_tready && s00_axis_tvalid) begin
                new_a_valid = {new_a_valid[NUM_CORNERS-2:0], 1'b1};
                a_val[0] <= s00_axis_tdata;
                a_last <= s00_axis_tlast;
                for (integer i = 1; i < NUM_CORNERS; i = i + 1) begin
                    a_val[i] <= a_val[i-1];
                end
                a_ready <= 1;
            end else if (a_ready && cur_idx < MAX_IDX) begin
                a_ready <= 1;
            end else begin
                a_ready <= 0;
            end

            a_valid <= new_a_valid;

        end
    end
    





endmodule


