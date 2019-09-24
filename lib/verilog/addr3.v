module addr3(
	clk,
	rst,
	d0_i,
	d1_i,
	d2_i,
	d_o
	);
parameter IN_WIDTH = 32;

input clk;
input rst;
input wire [IN_WIDTH-1:0] d0_i;
input wire [IN_WIDTH-1:0] d1_i;
input wire [IN_WIDTH-1:0] d2_i;
output reg [IN_WIDTH:0] d_o;

always @(posedge clk)
begin
	if (rst)
		d_o <= 0;
	else
		d_o <= {{1{d0_i[IN_WIDTH-1]}}, d0_i} + {{1{d1_i[IN_WIDTH-1]}}, d1_i} + {{1{d2_i[IN_WIDTH-1]}}, d2_i};
end
endmodule