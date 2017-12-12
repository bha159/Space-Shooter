module obs
#(parameter N1=15)
(
	input wire video_on,
    input wire reset,
    input clk,
    input wire [10:0] pix_x, pix_y,
    input wire [10:0] x1, x2, y1, y2,
    output reg [2:0] rgb,
    output wire obs_on,
    input wire [10:0] bull_x, bull_y,
    output wire obs_state
);

	//Screen constraints
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
    localparam OBS_V = 1;
    localparam START = 0;
    localparam on = 1'b1, off = 1'b0;
    localparam N = N1;  //increasing this will slowdown the speed of paddle
                        //with increment of 1 the speed will be halved,
                        //minimum = 11 (should not be less than 11, or bad thing will happen)

    wire obs;
    wire [2:0] obsrgb;
    reg next, ps;
    wire col;
    reg [N-1:0] obs_y_reg, obs_y_next; //*
    wire frame_tick;
    wire [10:0] y1n, y2n;
    reg [3:0] count, count_next;
    assign frame_tick = (pix_y==11'd481) && (pix_x==11'd0);

    assign y1n = y1 + obs_y_reg[N-1:N-11]; //*
    assign y2n = y2 + obs_y_reg[N-1:N-11]; //*

    assign obs = (x1<=pix_x) && (pix_x<=x2) && (y1n<=pix_y) && (pix_y<=y2n);
    assign obsrgb = 3'b111;
    assign col = (x1<bull_x) && (bull_x<x2) && (y1n<bull_y) && (bull_y<y2n);
    assign obs_on = obs & ps;

    //Animation Obstacle
    always @(posedge clk)
    begin
        if(reset)
            obs_y_reg <= START;
        else
            obs_y_reg <= obs_y_next;
    end

    always @(*)
    begin
        if (frame_tick)
        begin
            obs_y_next = obs_y_reg + OBS_V;
        end
        else
            obs_y_next = obs_y_reg;
    end

    //Collision Detection
    always @(posedge clk)
    begin
    if(reset)
        ps <= on;
    else
        ps <= next;
    end

    always @(*)
    begin
        next = ps;
        case(ps)
        on: if(col)
                next = off;
        off: next = off;
        endcase
    end

    always @*
    	if(~video_on)
    		rgb = 3'b000;
    	else if(obs)
    			rgb = obsrgb;
    		 else
    		 	rgb = 3'b000;

    assign obs_state = ps;
endmodule
