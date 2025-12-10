module frame_counter (

        input wire [NUM_FRAME_SIZE-1:0] num_frames,

        input wire clk,
        input wire arst,

        input wire [23:0] pixel_data_in,
        input wire hsync_in,
        input wire vsync_in,
        input wire vde_in,
 
        output wire [23:0] pixel_data_out,
        output wire hsync_out,
        output wire vsync_out,
        output wire vde_out
    );

    localparam NUM_FRAME_SIZE = 4;
    


    logic [NUM_FRAME_SIZE-1:0] cnt;
    
    
    logic [23:0] pixel_data_reg;
    logic vsync_reg;
    logic hsync_reg;
    logic vde_reg;


    assign pixel_data_out = pixel_data_reg;
    assign hsync_out = hsync_reg;
    assign vsync_out = vsync_reg;
    assign vde_out = (vde_reg && (cnt == 0));


    always_ff @(posedge clk) begin
        if (arst == 0) begin
            cnt <= 0;
        end else begin
            if (vsync_in && !vsync_reg) begin
                if (cnt < num_frames-1) begin
                    cnt <= cnt+1;
                end else begin
                    cnt <= 0;
                end
            end
            
            pixel_data_reg <= pixel_data_in;
            vsync_reg <= vsync_in;
            hsync_reg <= hsync_in;
            vde_reg <= vde_in;
        end
    end
endmodule

