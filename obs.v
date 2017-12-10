module obs
(
	input wire video_on,
    input wire reset,
    input clk,
    input wire [10:0] pix_x, pix_y,
    input wire [10:0] x1, x2, y1, y2,
    output reg [2:0] rgb,
    output wire obs_on);

	//Screen constraints
    localparam MAX_X = 640;
    localparam MAX_Y = 480;

    wire obs;
    wire [2:0] obsrgb;
    assign obs = (x1<=pix_x) && (pix_x<=x2) && (y1<=pix_y) && (pix_y<=y2);
    assign obsrgb = 3'b111;
    assign obs_on = obs;

    always @*
    	if(~video_on)
    		rgb = 3'b000;
    	else if(obs)
    			rgb = obsrgb;
    		 else
    		 	rgb = 3'b000;

endmodule