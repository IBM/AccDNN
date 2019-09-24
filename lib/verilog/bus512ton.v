module bus512ton(
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

parameter IN_WIDTH  = 512 ;
parameter OUT_WIDTH = 32;
parameter COUNT     = 4;
parameter N         = 320;

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

reg [COUNT-1:0] dout_cnt;
reg [31:0] dout_cnt_total;
always @ (posedge clk)
begin
  if(rst | (dout_cnt_total == N-1))
    dout_cnt <= 0;
  else if(blob_dout_en)
    dout_cnt <= dout_cnt + 1'b1;
  else
    dout_cnt <= dout_cnt;
end

always @ (posedge clk)
begin
  if(rst)
    dout_cnt_total <= 32'b0;
  else if(blob_dout_en)
  begin
    if(dout_cnt_total == N-1)
      dout_cnt_total <= 32'b0;
    else
      dout_cnt_total <= dout_cnt_total + 1'b1;
  end
  else
    dout_cnt_total <= dout_cnt_total;
end

reg last_blob_din;
always @ (posedge clk)
begin
  if (rst)
     last_blob_din <= 1'b0;
  else if (blob_din_en)
     last_blob_din <= blob_din_eop;
  else
     last_blob_din <= last_blob_din;
end

reg trunc_en;
always @ (posedge clk)
begin
  if(rst)
      trunc_en <= 1'b0;
  else if(blob_din_eop)
      trunc_en <= 1'b0;
  else if(blob_dout_eop & (~last_blob_din)) 
      trunc_en <= 1'b1;
  else
      trunc_en <= trunc_en;
end

reg read_write_sel;
always @ (posedge clk)
begin
  if(rst)
    read_write_sel <= 1'b0;
  else if(blob_din_en & (~trunc_en))
    read_write_sel <= 1'b1;
  else if(blob_dout_en & ((&dout_cnt)|(dout_cnt_total == N-1)))
    read_write_sel <= 1'b0;
  else
    read_write_sel <= read_write_sel;
end

reg  [IN_WIDTH-1:0]  din_tmp;
always @ (posedge clk)
begin
  if(rst)
    din_tmp <= 0;
  else if(blob_din_en & (~trunc_en))
    din_tmp <= blob_din;
  else if(blob_dout_rdy)
    din_tmp <= (din_tmp >> OUT_WIDTH);
  else
    din_tmp <= din_tmp;
end

assign blob_dout = din_tmp[OUT_WIDTH-1:0];
assign blob_din_rdy = ~read_write_sel;
assign blob_dout_en = read_write_sel & blob_dout_rdy;
assign blob_dout_eop = blob_dout_en & (dout_cnt_total == N-1);

endmodule
