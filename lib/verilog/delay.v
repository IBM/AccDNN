`timescale 1ns / 1ps

module delay(clk,rst,in,out);
input clk;
input rst;
input in;
output out;

parameter N = 2;

generate
	if (N == 0) begin : gen_delay_block
		assign out = in;
	end
	else if (N == 1) begin
(*mark_debug="true"*)reg				delay_line;

		always @ (posedge clk)
		begin
			delay_line 	<= in;
		end

		assign out = delay_line;
	end
	else begin
		genvar i;
(*mark_debug="true"*)reg		[N-1:0]		delay_line;

		always @ (posedge clk)
		begin
			delay_line [0]	<= in;
		end

		for (i=1; i < N; i=i+1) begin:gen_delay_line
			always @ (posedge clk)
			begin
				delay_line [i]	<= delay_line [i-1];
			end
		end

		assign	out = delay_line [N-1];
	end
endgenerate


endmodule
