module reset_gen
(
	input wire clk,
	output reg reset_soft);
	
	reg [50:0] count, count_reg;

	always @(posedge clk)
	begin
		count = count_reg;
		count_reg = count + 1;
	end

	always @(*)
		case(count)
			50'b0: reset_soft = 1;
			50'b1: reset_soft = 1;
			50'b11: reset_soft = 1;
			default: reset_soft = 0;
		endcase

endmodule
