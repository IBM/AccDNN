module vector_max(
        clk,
        rst,
        op_din_en,
        op_din_eop,
        op_din,
        op_dout
);

//========================================
//parameter define                        
//========================================
parameter RELU = 0;
parameter DIN_W = 16;
parameter Q = 8;

//========================================
//input/output  declare
//========================================
input clk;
input rst;
input op_din_en;
input op_din_eop;
input signed [DIN_W-1:0] op_din;
output signed [DIN_W-1:0] op_dout; 
 
//========================================
//delay op_din_eop 1 clock
//========================================
reg op_din_eop_d1;
always @ (posedge clk)
begin
  if(rst)
    op_din_eop_d1 <= 1'b0;
  else
    op_din_eop_d1 <= op_din_eop;
end
//========================================
//select max value with signal
//========================================
reg signed [DIN_W-1:0] op_dout_tmp; 
always @ (posedge clk)
begin
  if(rst)
    op_dout_tmp <= {DIN_W{1'b0}};
  else if ((op_din_eop_d1 == 1'b1) && (op_din_en == 1'b1))
    op_dout_tmp <= op_din;
  else if ((op_din_eop_d1 == 1'b1) && (op_din_en == 1'b0))
    op_dout_tmp <= {1'b1, {(DIN_W-1){1'b0}}};
  else if ((op_din_eop_d1 == 1'b0) && (op_din_en == 1'b1))
    op_dout_tmp <= op_dout_tmp > op_din ? op_dout_tmp : op_din;
  else  
    op_dout_tmp <= op_dout_tmp;	
end

//========================================
//non-linearization deal
//========================================
assign op_dout = RELU ? (op_dout_tmp[DIN_W-1] ? 0 : op_dout_tmp) : op_dout_tmp;

endmodule
