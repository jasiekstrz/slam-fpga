module cube
    (
        input wire clk,
        input wire rst_n,

        input wire [7:0][31:0] cube_pts,

        input wire [23:0] pixel_in,
        input wire vde_in,
        input wire vsync_in,
        input wire hsync_in,

        output wire [23:0] pixel_out,
        output wire vde_out,
        output wire vsync_out,
        output wire hsync_out
    );

    localparam PIXEL_SIZE = 24;
    localparam CORD_SIZE = 11;
    localparam MAX_X = 1226;
    localparam MAX_Y = 370;
    localparam EPS = 1;
    


    logic [CORD_SIZE-1:0] cube_x [7:0];
    logic [CORD_SIZE-1:0] cube_y [7:0];

    always_comb begin
        for (int i = 0; i < 8; i = i + 1) begin
            cube_x[i] = cube_pts[i][CORD_SIZE-1:0];
            cube_y[i] = cube_pts[i][16+CORD_SIZE-1:16];
        end
    end

    logic [CORD_SIZE-1:0] cur_x;
    logic [CORD_SIZE-1:0] cur_y;



    assign s00_axis_tready = m00_axis_tready;
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



    always_ff @(posedge clk) begin
        if (rst_n == 0) begin
            cur_cube_point <= 0;
            cur_x <= 0;
            cur_y <= 0;
            m00_axis_tvalid <= 0;
        end else begin
            if (vde_in) begin
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
                    pixel_out <= {8'hFF, 8'h00, 8'h00};
                end else begin
                    pixel_out <= pixel_in;
                end

                if (cur_x == MAX_X-1) begin
                    if (cur_y == MAX_Y-1) begin
                        cur_y <= 0;
                    end else begin
                        cur_y <= cur_y + 1;
                    end
                    cur_x <= 0;
                end else begin
                    cur_x <= cur_x + 1;
                end
            end
            vde_out <= vde_in;
            vsync_out <= vsync_in;
            hsync_out <= hsync_in;
        end
    end
endmodule

