module busnto512(
  clk,
  rst,
  blob_din,
  blob_din_rdy,
  blob_din_en,
  blob_din_eop,
  blob_dout,
  blob_dout_rdy,
  blob_dout_en,
  blob_dout_eop
);

parameter IN_WIDTH  = 32 ;
parameter OUT_WIDTH = 512;
parameter COUNT     = 4  ;

//========================================
//input/output  declare
//========================================
input                                 clk;
input                                 rst;
input      [IN_WIDTH-1:0]             blob_din;
output                                blob_din_rdy;
input                                 blob_din_en;
input                                 blob_din_eop;
output     [OUT_WIDTH-1:0]            blob_dout;
input                                 blob_dout_rdy;
output                                blob_dout_en;
output                                blob_dout_eop;

reg auto_pad;
reg [COUNT-1:0] phase;

always @ (posedge clk)
begin
  if(rst)
    auto_pad <= 1'b0;
  else if(&phase)
    auto_pad <= 1'b0;
  else if(blob_din_en & blob_din_eop)
    auto_pad <= 1'b1;
  else
    auto_pad <= auto_pad;
end

always @ (posedge clk)
begin
  if(rst)
    phase <= 0;
  else if(blob_din_en | auto_pad)
	phase <= phase + 1'b1;
  else
    phase <= phase;
end

reg  [OUT_WIDTH-1:0]  blob_dout_tmp;
always @ (posedge clk)
begin
  if(rst)
    blob_dout_tmp <= 0;
  else if(blob_din_en | auto_pad)
    blob_dout_tmp <= {blob_din,blob_dout_tmp[OUT_WIDTH-1:IN_WIDTH]};
  else
    blob_dout_tmp <= blob_dout_tmp;
end

assign blob_din_rdy  = blob_dout_rdy & (~auto_pad);
assign blob_dout_en  = (blob_din_en | auto_pad) & (&phase);
assign blob_dout_eop =(blob_din_eop | auto_pad) & (&phase);
assign blob_dout = (blob_din_en | auto_pad) ? {blob_din,blob_dout_tmp[OUT_WIDTH-1:IN_WIDTH]} : 0; 

endmodule
