module wall
  (
    input wire video_on,
    input wire [10:0] pix_x, pix_y,
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
    localparam BALL_L = 315;
    localparam BALL_R = 325;
    localparam BALL_T = 465;
    localparam BALL_B = 477;
    //Bullet constraints
    localparam BULL_T = BALL_T - 1;//469 when on default
    localparam BULL_B = BALL_T - 5;//465 when on default
    localparam BULL_L = BALL_L + 3;//318 when on default
    localparam BULL_R = BALL_R - 3;//322 when on default

    wire lwall, rwall, twall, bwall, ball, bull;
    wire [2:0] lrgb, rrgb, trgb, brgb, ballrgb, bullrgb;

    assign lwall = (LWALL_L<=pix_x) && (pix_x<=LWALL_R);
    assign rwall = (RWALL_L<=pix_x) && (pix_x<=RWALL_R);
    assign twall = (TWALL_L<=pix_y) && (pix_y<=TWALL_R);
    assign bwall = (BWALL_L<=pix_y) && (pix_y<=BWALL_R);
    assign ball = (BALL_L<=pix_x) && (pix_x<=BALL_R) && (BALL_T<=pix_y) && (pix_y<=BALL_B);
    assign bull = (BULL_L<=pix_x) && (pix_x<=BULL_R) && (BULL_B<=pix_y) && (pix_y<=BULL_T);

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
    	else if(bull)
    			rgb = bullrgb;
    		 else
    		 	rgb = 3'b000;

endmodule
