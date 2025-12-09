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


    assign pixel_data_out = pixel_data_in;
    assign hsync_out = (hsync_in && (cnt == 0));
    assign vsync_out = (vsync_in && (cnt == 0));
    assign vde_out = (vde_in && (cnt == 0));


    always_ff @(posedge clk) begin
        if (arst == 0) begin
            cnt <= 0;
            vsync_out <= 0;
            hsync_out <= 0;
            vde_out <= 0;
        end else begin
            if (vsync_in) begin
                if (cnt == num_frames-1) begin
                    cnt <= 0;
                end else begin
                    cnt <= cnt+1;
                end
            end
        end
    end
endmodule

