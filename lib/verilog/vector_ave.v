module vector_ave(
  clk,
  rst,
  op_din_en,
  op_din_eop,
  op_din,
  fraction,
  op_dout
 );
 
//========================================
//input/output  declare
//======================================== 
input clk;
input rst;
input op_din_en;
input op_din_eop;
input [15:0] op_din;
input [15:0] fraction;
output [15:0] op_dout; 

//========================================
//parameter define                        
//========================================
parameter RELU = 0;
//parameter FRACTION = 1000;
parameter Q = 8;

//========================================
//call mul IP core : op_din[15:0] * FRACTION
//========================================
wire [31:0] a1;
mul16_signed u_mul16_signed_1 (
  .CLK(clk),
  .A(op_din),
  .B(fraction),
  .P(a1)
);

//========================================
//delay op_din_en 1 clock
//========================================
reg op_din_en_d1;
always @ (posedge clk)
begin
  if(rst)
    op_din_en_d1 <= 1'b0;
  else
    op_din_en_d1 <= op_din_en;
end

//========================================
//delay op_din_eop 2 clock
//========================================
wire op_din_eop_d2;
delay #(2)u_delay_1(
  .clk(clk),
  .rst(rst),
  .in(op_din_eop),
  .out(op_din_eop_d2)
);

//========================================
//accumulation with signal
//========================================
reg [31:0] sum;
always @ (posedge clk)
begin
  if(rst)
    sum <= 32'b0;
  else if ((op_din_eop_d2 == 1) && (op_din_en_d1 == 1))
    sum <= a1;
  else if ((op_din_eop_d2 == 1) && (op_din_en_d1 == 0))
    sum <= 32'b0;
  else if ((op_din_eop_d2 == 0) && (op_din_en_d1 == 1))
    sum <= sum + a1;
  else  
    sum <= sum;	
end

wire [15:0] op_dout_tmp;
bit_trunc #(
  .WIDTH(32),
  .MSB(Q+15),
  .LSB(Q)
) 
u_bit_trunc_2(
  .din(sum),
  .dout(op_dout_tmp)
);

assign op_dout = RELU ? (op_dout_tmp[15] ? 0 : op_dout_tmp) : op_dout_tmp;

endmodule
