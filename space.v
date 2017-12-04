module space
( 
	input wire clk, reset, 
	input wire led1, led2,
	output wire hsync, vsync,
	output wire [2:0] rgb, 
	output reg [7:0] leds
	);

	//Signal decleration
	wire [10:0] pixel_x, pixel_y;
	wire pixel_tick, video_on;
	reg [2:0] rgb_reg; 
	wire [2:0] rgb_next;
	wire reset_n;
	wire reset_soft;
	//Instantiation
	reset_gen rese 
	(.clk(clk), .reset_soft(reset_soft));  
	
	sync vga
	(.clk(clk), .reset(reset_n), .h_sync(hsync), .v_sync(vsync), .video_on(video_on), .p_tick(pixel_tick), .pixel_x(pixel_x), .pixel_y(pixel_y));

	wall wallins
	(.video_on(video_on), .pix_x(pixel_x), .pix_y(pixel_y), .rgb(rgb_next), .ledleft(led2), .ledright(led1), .reset(reset_n), .clk(clk), .fire(led2));
 
 	//test t
 	//(.video_on(video_on), .pix_x(pixel_x), .pix_y(pixel_y), .rgb(rgb_next));
 	//LED TEST
 	always @(*)
 		case({led1,led2})
 			2'b00: leds = 8'b00000000;
 			2'b11: leds = 8'b11111111;
 			2'b10: leds = 8'b11110000;
 			2'b01: leds = 8'b00001111;
 			default: leds = 8'b10101010;
 		endcase 

	//RGB Buffer 
	always @(posedge clk )
		if (pixel_tick)
			rgb_reg<=rgb_next; 
	//Output  
	assign  rgb = rgb_reg;
	assign  reset_n = ~reset | reset_soft;
endmodule 