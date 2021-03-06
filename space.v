module space
(
	input wire clk, reset,
	input wire led1, led2, led3,
	output wire hsync, vsync,
	output wire [2:0] rgb,
	output reg [7:0] leds
	);

	//Signal declaration
	wire [10:0] pixel_x, pixel_y;
	wire pixel_tick, video_on;
	reg [2:0] rgb_reg;
	reg [2:0] rgb_next;
	wire [2:0] rgb_wall, rgb_obs, rgb_obs1, rgb_obs2, rgb_obs3, rgb_obs4, rgb_obs5, rgb_obs6, rgb_obs7;
	wire wall_on, obs_on, obs_on1, obs_on2, obs_on3, obs_on4, obs_on5, obs_on6, obs_on7;
	wire reset_n;
	wire reset_soft;
	wire [10:0] bull_x, bull_y;
	wire gamewin;
	wire [0:7] obs_state; //for game winning states
	wire gameover;
	wire [0:7] game_state;
    wire [0:7] crossed;

	//Instantiation
	reset_gen rese
	(.clk(clk), .reset_soft(reset_soft));

	sync vga
	(.clk(clk), .reset(reset_n), .h_sync(hsync), .v_sync(vsync), .video_on(video_on), .p_tick(pixel_tick), .pixel_x(pixel_x), .pixel_y(pixel_y));

	wall wallins
	(.video_on(video_on), .pix_x(pixel_x), .pix_y(pixel_y), .rgb(rgb_wall), .ledleft(led2), .ledright(led1), .reset(reset_n), .clk(clk), .fire(led3), .wall_on(wall_on), .bull_x_reg1(bull_x), .bull_y_reg1(bull_y));

	obs #(.N1(13)) obst1
	(.crossed(crossed[0]), .obs_state(obs_state[0]), .video_on(video_on), .reset(reset_n), .clk(clk), .pix_x(pixel_x), .pix_y(pixel_y), .x1(20), .y1(20), .x2(80), .y2(40), .rgb(rgb_obs), .obs_on(obs_on), .bull_x(bull_x), .bull_y(bull_y));

	obs #(.N1(14)) obst2
	(.crossed(crossed[1]), .obs_state(obs_state[1]), .video_on(video_on), .reset(reset_n), .clk(clk), .pix_x(pixel_x), .pix_y(pixel_y), .x1(100), .y1(20), .x2(160), .y2(40), .rgb(rgb_obs1), .obs_on(obs_on1), .bull_x(bull_x), .bull_y(bull_y));

	obs #(.N1(15)) obst3
	(.crossed(crossed[2]), .obs_state(obs_state[2]), .video_on(video_on), .reset(reset_n), .clk(clk), .pix_x(pixel_x), .pix_y(pixel_y), .x1(180), .y1(20), .x2(240), .y2(40), .rgb(rgb_obs2), .obs_on(obs_on2), .bull_x(bull_x), .bull_y(bull_y));

	obs #(.N1(14)) obst4
	(.crossed(crossed[3]), .obs_state(obs_state[3]), .video_on(video_on), .reset(reset_n), .clk(clk), .pix_x(pixel_x), .pix_y(pixel_y), .x1(260), .y1(20), .x2(320), .y2(40), .rgb(rgb_obs3), .obs_on(obs_on3), .bull_x(bull_x), .bull_y(bull_y));

	obs #(.N1(13)) obst5
	(.crossed(crossed[4]), .obs_state(obs_state[4]), .video_on(video_on), .reset(reset_n), .clk(clk), .pix_x(pixel_x), .pix_y(pixel_y), .x1(340), .y1(20), .x2(400), .y2(40), .rgb(rgb_obs4), .obs_on(obs_on4), .bull_x(bull_x), .bull_y(bull_y));

	obs #(.N1(14)) obst6
	(.crossed(crossed[5]), .obs_state(obs_state[5]), .video_on(video_on), .reset(reset_n), .clk(clk), .pix_x(pixel_x), .pix_y(pixel_y), .x1(420), .y1(20), .x2(460), .y2(40), .rgb(rgb_obs5), .obs_on(obs_on5), .bull_x(bull_x), .bull_y(bull_y));

	obs #(.N1(13)) obst7
	(.crossed(crossed[6]), .obs_state(obs_state[6]), .video_on(video_on), .reset(reset_n), .clk(clk), .pix_x(pixel_x), .pix_y(pixel_y), .x1(480), .y1(20), .x2(540), .y2(40), .rgb(rgb_obs6), .obs_on(obs_on6), .bull_x(bull_x), .bull_y(bull_y));

	obs #(.N1(15)) obst8
	(.crossed(crossed[7]), .obs_state(obs_state[7]), .video_on(video_on), .reset(reset_n), .clk(clk), .pix_x(pixel_x), .pix_y(pixel_y), .x1(560), .y1(20), .x2(620), .y2(40), .rgb(rgb_obs7), .obs_on(obs_on7), .bull_x(bull_x), .bull_y(bull_y));

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

	//Selecting RGB signal
	always @(*)
	begin
		if(~video_on)
			rgb_next = 3'b000;
		else if(gamewin)
			rgb_next = 3'b010;
		else if(gameover)
			rgb_next = 3'b100;
		else if (wall_on)
			rgb_next = rgb_wall;
		else if (obs_on)
			rgb_next = rgb_obs;
		else if(obs_on1)
			rgb_next = rgb_obs1;
		else if(obs_on2)
			rgb_next = rgb_obs2;
		else if(obs_on3)
			rgb_next = rgb_obs3;
		else if(obs_on4)
			rgb_next = rgb_obs4;
		else if(obs_on5)
			rgb_next = rgb_obs5;
		else if(obs_on6)
			rgb_next = rgb_obs6;
		else if(obs_on7)
			rgb_next = rgb_obs7;
		else
			rgb_next = 3'b000;
	end

	//Output
	assign gamewin = &(~obs_state);
	assign gameover = |(crossed);
	assign  rgb = rgb_reg;
	assign  reset_n = ~reset | reset_soft;
endmodule
