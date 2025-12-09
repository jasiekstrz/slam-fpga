module cube #
    (
        parameter integer C_S00_AXIS_TDATA_WIDTH    = 32,
        parameter integer C_S01_AXIS_TDATA_WIDTH    = 32,
        parameter integer C_M00_AXIS_TDATA_WIDTH    = 32
    )
    (
 
        // Ports of Axi Slave Bus Interface S00_AXIS  -  Cube Points
        input wire  s00_axis_aclk, s00_axis_aresetn,
        input wire  s00_axis_tlast, s00_axis_tvalid,
        input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
        input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1: 0] s00_axis_tstrb,
        output logic  s00_axis_tready,
 
        // Ports of Axi Slave Bus Interface S01_AXIS  -  Frame Data
        input wire  s01_axis_aclk, s01_axis_aresetn,
        input wire  s01_axis_tlast, s01_axis_tvalid,
        input wire [C_S01_AXIS_TDATA_WIDTH-1 : 0] s01_axis_tdata,
        input wire [(C_S01_AXIS_TDATA_WIDTH/8)-1: 0] s01_axis_tstrb,
        output logic  s01_axis_tready,
 
        // Ports of Axi Master Bus Interface M00_AXIS  -  Modified Frame
        input wire  m00_axis_aclk, m00_axis_aresetn,
        input wire  m00_axis_tready,
        output logic  m00_axis_tvalid, m00_axis_tlast,
        output logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
        output logic [(C_M00_AXIS_TDATA_WIDTH/8)-1: 0] m00_axis_tstrb
    );

    localparam PIXEL_SIZE = 24;
    localparam CORD_SIZE = 11;
    localparam MAX_X = 1226;
    localparam MAX_Y = 370;
    localparam EPS = 1;
    


    typedef enum {INPUT_CUBE, STREAM_FRAME} state_t;
    state_t state;

    logic [2:0] cur_cube_point;
    logic [CORD_SIZE-1:0] cube_x [7:0];
    logic [CORD_SIZE-1:0] cube_y [7:0];

    logic [CORD_SIZE-1:0] cur_x;
    logic [CORD_SIZE-1:0] cur_y;



    assign s00_axis_tready = (state == INPUT_CUBE);
    assign s01_axis_tready = (state == STREAM_FRAME && m00_axis_tready);
    assign m00_axis_tstrb  = {C_M00_AXIS_TDATA_WIDTH/8{1'b1}};



    function automatic logic is_on_segment(
        input logic [CORD_SIZE-1:0] px,py, // tested point
        input logic [CORD_SIZE-1:0] ax,ay, // first end of the segment
        input logic [CORD_SIZE-1:0] bx,by  // second end of the segment
    );
        logic signed [2*CORD_SIZE+1:0] spx = $signed(px);
        logic signed [2*CORD_SIZE+1:0] spy = $signed(py);
        logic signed [2*CORD_SIZE+1:0] sax = $signed(ax);
        logic signed [2*CORD_SIZE+1:0] say = $signed(ay);
        logic signed [2*CORD_SIZE+1:0] sbx = $signed(bx);
        logic signed [2*CORD_SIZE+1:0] sby = $signed(by);

        logic signed [2*CORD_SIZE+1:0] cross_prod = (sax-spx)*(sby-spy) - (sbx-spx)*(say-spy);
        return (-EPS < cross_prod) && (cross_prod < EPS) && 
               (((ax <= px) && (px <= bx)) || ((bx <= px) && (px <= ax))) && 
               (((ay <= py) && (py <= by)) || ((by <= py) && (py <= ay)));
    endfunction



    always_ff @(posedge s00_axis_aclk) begin
        if (s00_axis_aresetn == 0) begin
            state <= INPUT_CUBE;
            cur_cube_point <= 0;
            cur_x <= 0;
            cur_y <= 0;
            m00_axis_tvalid <= 0;
        end else if (state == INPUT_CUBE) begin
            if (s00_axis_tvalid) begin
                cube_x[cur_cube_point] <= s00_axis_tdata[CORD_SIZE-1:0];
                cube_y[cur_cube_point] <= s00_axis_tdata[2*CORD_SIZE-1:CORD_SIZE];

                cur_cube_point <= cur_cube_point + 1;
                if (cur_cube_point == 7) begin
                    state <= STREAM_FRAME;
                end
            end
            m00_axis_tvalid <= 0;
        end else if (state == STREAM_FRAME) begin
            if (s01_axis_tready && s01_axis_tvalid) begin
                if (is_on_segment(cur_x, cur_y, cube_x[0], cube_y[0], cube_x[1], cube_y[1]) ||
                    is_on_segment(cur_x, cur_y, cube_x[2], cube_y[2], cube_x[3], cube_y[3]) ||
                    is_on_segment(cur_x, cur_y, cube_x[4], cube_y[4], cube_x[5], cube_y[5]) ||
                    is_on_segment(cur_x, cur_y, cube_x[6], cube_y[6], cube_x[7], cube_y[7]) ||

                    is_on_segment(cur_x, cur_y, cube_x[0], cube_y[0], cube_x[2], cube_y[2]) ||
                    is_on_segment(cur_x, cur_y, cube_x[1], cube_y[1], cube_x[3], cube_y[3]) ||
                    is_on_segment(cur_x, cur_y, cube_x[4], cube_y[4], cube_x[6], cube_y[6]) ||
                    is_on_segment(cur_x, cur_y, cube_x[5], cube_y[5], cube_x[7], cube_y[7]) ||

                    is_on_segment(cur_x, cur_y, cube_x[0], cube_y[0], cube_x[4], cube_y[4]) ||
                    is_on_segment(cur_x, cur_y, cube_x[1], cube_y[1], cube_x[5], cube_y[5]) ||
                    is_on_segment(cur_x, cur_y, cube_x[2], cube_y[2], cube_x[6], cube_y[6]) ||
                    is_on_segment(cur_x, cur_y, cube_x[3], cube_y[3], cube_x[7], cube_y[7])
                ) begin  
                    m00_axis_tdata <= {8'hFF, 8'h00, 8'h00};
                end else begin
                    m00_axis_tdata <= s01_axis_tdata;
                end

                m00_axis_tvalid <= 1;
                m00_axis_tlast <= s01_axis_tlast;

                if (cur_x == MAX_X-1) begin
                    if (cur_y == MAX_Y-1) begin
                        cur_y <= 0;
                        state <= INPUT_CUBE;
                    end else begin
                        cur_y <= cur_y + 1;
                    end
                    cur_x <= 0;
                end else begin
                    cur_x <= cur_x + 1;
                end
            end else begin
                m00_axis_tvalid <= 0;
            end
        end
    end
endmodule

