module test
(
	input wire video_on,
	input wire [10:0] pix_x,pix_y,
	output reg [2:0] rgb
	);

	always @(*)
		if (~video_on)
			rgb=3'b000;
		else
			rgb=3'b111;
endmodule
