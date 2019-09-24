`timescale 1ns/1ps

module vect_muladd_tb();

parameter DIN_DW=8;
parameter DIN_Q=2;
parameter WW=8;
parameter WQ=8;
parameter CPF=32;
parameter DATA_CHANNEL = 2; // when using 8bit, set to 2
parameter DOUT_DW = 8; //bit-width of output 
parameter DOUT_Q=1;
parameter DIN_VECT=32/CPF;

reg clk,rst;
reg op_din_en;
reg [DIN_DW*CPF-1:0] op_din;
reg op_din_eop;
reg [WW*DATA_CHANNEL*CPF-1:0] op_weight;


wire  [DOUT_DW*DATA_CHANNEL-1:0] op_dout;

integer fpin,fpw;

initial begin
   clk = 0;
   #3;
   forever    clk = #2 ~clk;
end


initial begin
  rst = 0;
  op_din_en=0;
  op_din = 0;
  op_din_eop = 0;
  #199;
  rst = 1;
  #200;
  rst = 0;
  fpin=$fopen("/home/bjzhuc/muladdr/data/hexout/din.txt","r");
  fpw=$fopen("/home/bjzhuc/muladdr/data/hexout/weight.txt","r");
  
/*  while(!$feof(fpin))  // 写文件结束标志
   begin
   @(posedge clk) begin
     op_din_en = 1'b1;
     $fscanf(fpin,"%h",op_din);
   end
   #4;
   op_din_en = 1'b0;
*/

end

integer cnt;

always @(posedge clk)
begin
   if (rst) begin
      op_din <= 0;
      op_din_en <= 0;
      op_din_eop <= 1'b0;
      cnt <=0;
   end
   else if (!$feof(fpin)) begin 
      op_din_en <= 1'b1;
      $fscanf(fpin, "%h\n", op_din);
      cnt <= cnt+1;
      if (cnt == DIN_VECT-1)
        op_din_eop <= 1'b1;
      else
        op_din_eop <= 1'b0;
   end
   else begin
      op_din_en <= 0;
      op_din_eop <= 1'b0;
    //  $fclose(fpin);
   end
end  

always @(posedge clk)
begin
   if (rst)
      op_weight <= 0;
   else if (!$feof(fpw)) 
      $fscanf(fpw, "%h\n", op_weight);
   else
      $fclose(fpw);
end  

vector_muladd #(
 	.CPF(CPF),
 	.RELU(0),
 	.Q(WQ),
 	.DIN_Q(DIN_Q),
 	.DOUT_Q(DOUT_Q),
 	.ACC_WIDTH(40),
 	.BIAS_DW(4),
 	.BN(0),
 	.BN_SCALE_Q(13),
 	.BN_BIAS_Q(13),
 	.MID_Q(12),
 	.DIN_DW(DIN_DW),
 	.DOUT_DW(DOUT_DW), 
 	.WW(WW),
 	.DATA_CHANNEL(DATA_CHANNEL)) 
 	uut (
        .clk(clk),
        .rst(rst),
        .op_din_en(op_din_en),
        .op_din_eop(op_din_eop),
        .op_din(op_din),
        .op_weight(op_weight),
        .op_bias(0),
        .op_dout(op_dout)
    );

endmodule
