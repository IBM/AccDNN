module passthrough(
  clk,
  rst,
  op_din_en,
  op_din_eop,
  op_din,
  op_dout
);

parameter Q = 8;
parameter RELU = 0;

input clk;
input rst;
input op_din_en;
input op_din_eop;
input [15:0] op_din;
output [15:0] op_dout;

assign op_dout = op_din;

endmodule
