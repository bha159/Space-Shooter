module wall
  (
    input wire video_on,
    input wire reset,
    input clk,
    input wire [10:0] pix_x, pix_y,
    input wire ledleft, ledright, fire,
    output reg [2:0] rgb
    );
    //Screen constraints
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
    //Left Wall constraints
    localparam LWALL_L = 0;
    localparam LWALL_R = 2;
    //Right Wall contraints
    localparam RWALL_L = 637;
    localparam RWALL_R = 639;
    //Top Wall constraints
    localparam TWALL_L = 0;
    localparam TWALL_R = 2;
    //Bottom Wall constraints
    localparam BWALL_L = 477;
    localparam BWALL_R = 479;
    //Ball constraints
    localparam BALL_T = 465;
    localparam BALL_B = 477;
    localparam BALL_SIZE = 10;
    localparam BALL_V = 2;
    //Bullet constraints
    localparam BULL_T = BALL_T - 1;
    localparam BULL_B = BALL_T - 5;
    localparam BULL_SIZE = 4;

    wire lwall, rwall, twall, bwall, ball, bull;
    wire [2:0] lrgb, rrgb, trgb, brgb, ballrgb, bullrgb;
    //Player animation
    wire frame_tick;
    wire [10:0] ball_x_l, ball_x_r; 
    reg [10:0] ball_x_reg, ball_x_next;
    //Bullet animation
    wire [10:0] bull_x_l, bull_x_r;

    assign lwall = (LWALL_L<=pix_x) && (pix_x<=LWALL_R);
    assign rwall = (RWALL_L<=pix_x) && (pix_x<=RWALL_R);
    assign twall = (TWALL_L<=pix_y) && (pix_y<=TWALL_R);
    assign bwall = (BWALL_L<=pix_y) && (pix_y<=BWALL_R);
    //Player animation
    assign frame_tick = (pix_y==11'd481) && (pix_x==11'd0);
    assign ball_x_l = ball_x_reg;
    assign ball_x_r = ball_x_l + BALL_SIZE - 1;  
    assign  ball = (BALL_T<=pix_y) && (pix_y<=BALL_B) && (ball_x_l<=pix_x) && (pix_x<=ball_x_r);
    //Bullet animation
    assign bull_x_l = ball_x_reg + 3;
    assign bull_x_r = bull_x_l + BULL_SIZE - 1;
    assign bull = (BULL_B<=pix_y) && (pix_y<=pix_y) && (bull_x_l<=pix_x) && (pix_x<=bull_x_r);


    always @(*)
    begin
    	if (frame_tick)
    		if( (~ledright) && (ball_x_r < MAX_X - BALL_SIZE - 1) )
    			ball_x_next = ball_x_reg + BALL_V;
    		else if( (~ledleft) && (ball_x_l > BALL_V) )
    			ball_x_next = ball_x_reg - BALL_V;
    		else
    			ball_x_next = ball_x_reg;
    	else
    		ball_x_next = ball_x_reg;
    end

    always @(posedge clk)
    	if(reset)
    		ball_x_reg <= 315;
    	else if(frame_tick)
    	begin
    		ball_x_reg <= ball_x_next;
    	end


    assign ballrgb = 3'b110;
    assign bullrgb = 3'b100;
    assign lrgb = 3'b111;
    assign rrgb = 3'b111;
    assign trgb = 3'b111;
    assign brgb = 3'b111;

    always @*
    	if(~video_on)
    		rgb = 3'b000;
    	else if(lwall)
    			rgb = lrgb;
    	else if(rwall)
    			rgb = rrgb;
    	else if(twall)
    			rgb = trgb;
    	else if(bwall)
    			rgb = brgb;
    	else if(ball)
    			rgb = ballrgb;
    	else if(bull && ~fire)
    			rgb = bullrgb;
    		 else
    		 	rgb = 3'b000;

endmodule
