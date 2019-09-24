module controller_v2_a(
  clk,
  rst,
//blob data interface
  blob_din_rdy,
  blob_din_en,
  blob_din_eop,
  blob_dout_rdy,
  blob_dout_en,
  blob_dout_eop,
//operation interface
  op_din_en,
  op_din_eop,
//address generator interface
  rm_wr_en,
  rm_wr_addr,
  rm_rd_addr
);

//========================================
//parameter define                        
//======================================== 
parameter  DB_W_IN =8;
parameter  DB_H_IN =8;
parameter  DB_C_IN =8;
parameter  DB_W_OUT =8;
parameter  DB_H_OUT =8;
parameter  DB_C_OUT =8;
parameter  WB_W = 4;
parameter  WB_H = 4;
parameter  WB_C = 8;
parameter  WB_K = 4;
parameter  KPF  = 2;
parameter  STRIDE_H = 2;
parameter  STRIDE_W = 2;
parameter  PAD = 1;
parameter  OP_DELAY = 3;
parameter  RM_RING_LENGTH = 6;
parameter  RM_RD_PHY_ADDR_JUMP = 1;
parameter  RM_WR_ADDR_WIDTH = 6;
parameter  RM_RD_ADDR_WIDTH = 10;
parameter  KG = WB_K/KPF;
parameter  RM_WR_NUM_PER_CHANNEL = 4;
parameter  RM_WR_STRIDE = 4;
parameter  COUNT_PER_LAYER = DB_W_OUT*DB_H_OUT*KG*WB_W*WB_H;
parameter  DATA_ACCESS_DELAY = 5;

//========================================
//input/output  declare
//========================================
input                                 clk;
input                                 rst;
//blob data interface
output                                blob_din_rdy;
input                                 blob_din_en;
input                                 blob_din_eop;
input                                 blob_dout_rdy;
output                                blob_dout_en;
output                                blob_dout_eop;
//operation interface
output                                op_din_en;
output                                op_din_eop;
//address generator interface
output                                rm_wr_en;
output [RM_WR_ADDR_WIDTH-1:0]         rm_wr_addr;
output [RM_RD_ADDR_WIDTH-1:0]         rm_rd_addr;

//========================================
//generate frame_end and module_en                    
//======================================== 
wire    frame_end;
wire    frame_rst = frame_end;

wire    data_blob_rdy;     
wire    module_en;
reg blob_dout_rdy_d;
always @ (posedge clk)
begin
  blob_dout_rdy_d <= blob_dout_rdy;
end
assign  module_en = data_blob_rdy & blob_dout_rdy_d;

//========================================
//generate op_din_eop and blob_dout_en         
//generate blob_dout_eop                  
//======================================== 

//generate op_din_eop 
reg [31:0] op_din_c;           //Count of W'*H'
always @ (posedge clk)          
begin
  if(rst | frame_end)
    op_din_c <=0;
  else if(module_en)
    if(op_din_c == (WB_W*WB_H)-1)
      op_din_c <= 0;
    else
      op_din_c <= op_din_c + 1;
  else
    op_din_c <= op_din_c;
end

assign op_din_eop_tmp = module_en && (op_din_c == WB_W*WB_H-1);

delay #(DATA_ACCESS_DELAY) u_delay_1(
  .clk(clk),
  .rst(rst),
  .in(op_din_eop_tmp),
  .out(op_din_eop)
);

//generate blob_dout_en  
delay #(DATA_ACCESS_DELAY+OP_DELAY) u_delay_2(
  .clk(clk),
  .rst(rst),
  .in(op_din_eop_tmp),
  .out(blob_dout_en)
);

//generate blob_dout_eop               
reg[31:0] module_c;          //Count of H'*W'*KG*H*W
always @ (posedge clk)
begin
  if(rst | frame_end)
    module_c <=0;  
  else if (module_en)
    if (module_c == COUNT_PER_LAYER - 1)
      module_c <= 0;
    else
      module_c <= module_c + 1;
  else
    module_c <= module_c;
end

assign frame_end = module_en && (module_c == COUNT_PER_LAYER - 1);

delay #(DATA_ACCESS_DELAY+OP_DELAY) u_delay_3(
  .clk(clk),
  .rst(rst),
  .in(frame_end),
  .out(blob_dout_eop)
);
//========================================
//count address h'->w'->k -> h;                  
//======================================== 
reg [15:0] h_w_count;
always @ (posedge clk)      //generate h' address
begin
  if(rst | frame_end)
   h_w_count <=0;
  else if(module_en)
    if(h_w_count == WB_H-1)
      h_w_count <= 0;
    else
      h_w_count <= h_w_count + 1;
end

reg [15:0] w_w_count;
always @ (posedge clk)      //generate w' address
begin
  if(rst | frame_end) 
    w_w_count <=0;
  else if(module_en && (h_w_count == WB_H-1))
    if(w_w_count == WB_H-1)
      w_w_count <= 0;
    else
      w_w_count <= w_w_count + 1;
end

reg [31:0] w_w_c;           //Count of w'
always @ (posedge clk)          
begin
  if(rst | frame_end)
    w_w_c <=0;
  else if(module_en)
    if(w_w_c == (WB_W*WB_H)-1)
      w_w_c <= 0;
    else
      w_w_c <= w_w_c + 1;
end

reg [15:0] k_count;
always @ (posedge clk)         //generate k address
begin
  if(rst | frame_end)
   k_count <=0;
  else if(module_en && (w_w_c == (WB_W*WB_H)-1))
    if(k_count == KG-1)
      k_count <= 0;
    else
      k_count <= k_count + 1;
end

reg [31:0] k_c;           //Count of k
always @ (posedge clk)          
begin
  if(rst | frame_end)
    k_c <=0;
  else if(module_en)
    if(k_c == (KG*WB_W*WB_H)-1)
      k_c <= 0;
    else
      k_c <= k_c + 1;
end

reg [15:0] h_count;
always @ (posedge clk)      //generate h address
begin
  if(rst | frame_end)   
    h_count <=0;
  else if(module_en && (k_c == (KG*WB_W*WB_H)-1))
    if(h_count == (DB_H_OUT-1)*STRIDE_H)
      h_count <= 0;
    else
      h_count <= h_count + STRIDE_H;
end

//================================================
// generate rm_wr_log_addr  and  rm_rd_log_addr 
// generate rm_wr_full ; rm_rd_empty ; data_blob_rdy        
//================================================ 
reg [15:0] rm_wr_log_addr;
reg [15:0] rm_rd_log_addr;
//wire [15:0] rm_wr_log_addr_fake;

wire       rm_wr_full;
wire       rm_rd_empty;
assign     rm_wr_full   = ((rm_wr_log_addr - rm_rd_log_addr) >= ( RM_RING_LENGTH - PAD)) ? 1'b1 : 1'b0;
//assign     rm_wr_log_addr_fake = (rm_wr_log_addr == DB_W_IN) ? rm_wr_log_addr + PAD : rm_wr_log_addr;
assign     rm_rd_empty  = ((rm_wr_log_addr - rm_rd_log_addr) <  (WB_W - PAD)) ? 1'b1 : 1'b0;
assign     data_blob_rdy = (~rm_rd_empty) || ((rm_wr_log_addr == DB_W_IN) && (rm_rd_log_addr < DB_W_IN));


reg [31:0] rm_wr_cnt;
always @ (posedge clk)   //Count of RM_WR_NUM_PER_CHANNEL*H
begin
  if(rst)
    rm_wr_cnt <= 32'b0;
  else if(blob_din_en)
    begin
      if(rm_wr_cnt == RM_WR_NUM_PER_CHANNEL*DB_H_IN - 1)
	    rm_wr_cnt <= 32'b0;
	  else
	    rm_wr_cnt <= rm_wr_cnt + 1'b1;
	end
  else
    rm_wr_cnt <= rm_wr_cnt;  
end

always @ (posedge clk)
begin
  if(rst)
    rm_wr_log_addr <= 16'b0;
  else if (frame_end)
    begin
      if(blob_din_en && (rm_wr_cnt == RM_WR_NUM_PER_CHANNEL*DB_H_IN - 1))
        rm_wr_log_addr <= rm_wr_log_addr + 1 - DB_W_IN;
      else
        rm_wr_log_addr <= rm_wr_log_addr - DB_W_IN;
    end
  else if(blob_din_en && (rm_wr_cnt == RM_WR_NUM_PER_CHANNEL*DB_H_IN - 1))
    rm_wr_log_addr <= rm_wr_log_addr + 1'b1;
  else
    rm_wr_log_addr <= rm_wr_log_addr;
end

reg [31:0] rm_rd_cnt;   //Count of H'*W'KG*H
always @ (posedge clk)
begin
  if(rst | frame_end)
    rm_rd_cnt <= 32'b0;
  else if( module_en)
    begin
      if(rm_rd_cnt == WB_H*WB_W*KG*DB_H_OUT - 1)
	    rm_rd_cnt <= 32'b0;
	  else
	    rm_rd_cnt <= rm_rd_cnt + 1'b1;
	end
  else
    rm_rd_cnt <= rm_rd_cnt;  
end

always @ (posedge clk)
begin
  if(rst | frame_end)
    rm_rd_log_addr <= 16'b0;
  else if(module_en && (rm_rd_cnt == WB_H*WB_W*KG*DB_H_OUT - 1))
    rm_rd_log_addr <= rm_rd_log_addr + STRIDE_W;
  else
    rm_rd_log_addr <= rm_rd_log_addr;
end


//assign blob_din_rdy = (rm_wr_log_addr < DB_W_IN) & ( ~rm_wr_full ) & blob_din_en;
//assign blob_din_rdy = (rm_wr_log_addr < DB_W_IN) & ( ~rm_wr_full );
assign blob_din_rdy = ~rm_wr_full;
//========================================
// generate rm_wr_phy_addr  and  rm_rd_phy_addr 
// generate rm_wr_en and rm_wr_addr           
//======================================== 

reg [15:0] rm_wr_phy_addr;
always @ (posedge clk)
begin
  if(rst)
    rm_wr_phy_addr <= 16'b0;
  else if((rm_wr_cnt == RM_WR_NUM_PER_CHANNEL*DB_H_IN - 1) && (blob_din_en == 1'b1))
    begin
	  if((rm_wr_phy_addr + 1) >= RM_RING_LENGTH)
	    rm_wr_phy_addr <= (rm_wr_phy_addr + 1) - RM_RING_LENGTH;
	  else
	    rm_wr_phy_addr <= rm_wr_phy_addr + 1;
	end
  else
    rm_wr_phy_addr <= rm_wr_phy_addr;
end

reg [15:0] rm_rd_phy_addr;
always @ (posedge clk)
begin
  if(rst)
    rm_rd_phy_addr <= 16'b0;
  else if(frame_end)
    begin
      if((rm_rd_phy_addr + RM_RD_PHY_ADDR_JUMP) >= RM_RING_LENGTH)
        rm_rd_phy_addr <= rm_rd_phy_addr + RM_RD_PHY_ADDR_JUMP - RM_RING_LENGTH;
      else
        rm_rd_phy_addr <= rm_rd_phy_addr + RM_RD_PHY_ADDR_JUMP;
    end
  else if ((rm_rd_cnt == WB_H*WB_W*DB_H_OUT*KG - 1) && (module_en == 1'b1))
    begin
	  if((rm_rd_phy_addr + STRIDE_W) >= RM_RING_LENGTH)
	    rm_rd_phy_addr <= rm_rd_phy_addr + STRIDE_W - RM_RING_LENGTH;
	  else
	    rm_rd_phy_addr <= rm_rd_phy_addr + STRIDE_W;
	end
  else
    rm_rd_phy_addr <= rm_rd_phy_addr;
end

assign rm_wr_en =  blob_din_en;

reg [31:0] rm_wr_addr_offset;
always @ (posedge clk)
begin
  if(rst)
    rm_wr_addr_offset <= 32'b0;
  else if((blob_din_en) && (rm_wr_full == 1'b0))
    begin
	  if(rm_wr_addr_offset == RM_WR_NUM_PER_CHANNEL*DB_H_IN-1)
	    rm_wr_addr_offset <= 32'b0;
	  else if((rm_wr_addr_offset + RM_WR_STRIDE) > (RM_WR_NUM_PER_CHANNEL*DB_H_IN-1))
	    rm_wr_addr_offset <= (rm_wr_addr_offset + RM_WR_STRIDE) - (RM_WR_NUM_PER_CHANNEL*DB_H_IN-1);
	  else
	    rm_wr_addr_offset <= rm_wr_addr_offset + RM_WR_STRIDE;
	end
  else
    rm_wr_addr_offset <= rm_wr_addr_offset;
end

reg [31:0] rm_wr_addr_base_cnt;
always @ (posedge clk)   //Count of RM_WR_NUM_PER_CHANNEL*H*(WB_W+STRIDE_W)
begin
  if(rst)
    rm_wr_addr_base_cnt <= 32'b0;
  else if( blob_din_en && (~rm_wr_full) )
    begin
      if(rm_wr_addr_base_cnt == RM_WR_NUM_PER_CHANNEL*DB_H_IN * RM_RING_LENGTH - 1)
	    rm_wr_addr_base_cnt <= 32'b0;
	  else
	    rm_wr_addr_base_cnt <= rm_wr_addr_base_cnt + 1'b1;
	end
  else
    rm_wr_addr_base_cnt <= rm_wr_addr_base_cnt;  
end

reg [31:0] rm_wr_addr_base;
always @ (posedge clk)
begin
  if(rst)
    rm_wr_addr_base <= 32'b0;
  else if((blob_din_en) && (rm_wr_full == 1'b0))
    begin
	  if(rm_wr_addr_base_cnt == RM_WR_NUM_PER_CHANNEL*DB_H_IN*RM_RING_LENGTH - 1)
	    rm_wr_addr_base <= 32'b0;
	  else if(rm_wr_addr_offset == RM_WR_NUM_PER_CHANNEL*DB_H_IN-1)
	    rm_wr_addr_base <= rm_wr_addr_base + RM_WR_NUM_PER_CHANNEL*DB_H_IN;
	  else
	    rm_wr_addr_base <= rm_wr_addr_base;
	end
end

wire [31:0] rm_wr_addr_tmp;
assign rm_wr_addr_tmp = rm_wr_addr_offset + rm_wr_addr_base;
 
assign rm_wr_addr = rm_wr_addr_tmp[RM_WR_ADDR_WIDTH-1:0];

//========================================
//generate rm_rd_addr             
//======================================== 
wire [15:0] h_add = h_w_count + h_count;
wire [15:0] pos_h = h_add - PAD;

reg [15:0] pos_h_d;
always @ (posedge clk)
begin
  pos_h_d <= pos_h;
end

wire [15:0] w_add_tmp = w_w_count + rm_rd_phy_addr;
reg [15:0] w_add;
always @ (posedge clk)
begin
  w_add <= (w_add_tmp < RM_RING_LENGTH) ? w_add_tmp : w_add_tmp - RM_RING_LENGTH;
end
wire [15:0] pos_w = w_add < PAD ? w_add + RM_RING_LENGTH - PAD : w_add - PAD;

//generate op_din_en
//delay 5 clock, 3 for address generatoin, 2 for block memory ready delay
wire [15:0] rm_rd_log_addr_tmp = rm_rd_log_addr > DB_W_IN? DB_W_IN : rm_rd_log_addr;
wire rm_addr_val = module_en & ((rm_rd_log_addr_tmp + w_w_count - PAD) < DB_W_IN) & (pos_h < DB_H_IN);
delay #(DATA_ACCESS_DELAY) u_delay_4(
  .clk(clk),
  .rst(rst),
  .in(rm_addr_val),
  .out(op_din_en)
);

wire [31:0] rm_h;
wire [31:0] rm_w;
mul16_unsigned u_mul16_unsigned_2 (
  .CLK(clk),
  .A(pos_h_d),
  .B(KG),
  .P(rm_h)
);

mul16_unsigned u_mul16_unsigned_3 (
  .CLK(clk),
  .A(pos_w),
  .B(KG * DB_H_IN),
  .P(rm_w)
);

reg [31:0] k_d;
always @(posedge clk) //delay 1 clock
begin
  if(rst)
    k_d <= 0;
  else
    k_d <= k_count;
end

reg [31:0] k_d2;
always @(posedge clk) //delay 1 clock
begin
  if(rst)
    k_d2 <= 0;
  else
    k_d2 <= k_d;
end

reg [31:0] rm_rd_addr_tmp;
always @(posedge clk)
begin
  if(rst)
    rm_rd_addr_tmp <= 0;
  else
    rm_rd_addr_tmp <= k_d2 + rm_h + rm_w;
end

assign rm_rd_addr = rm_rd_addr_tmp[RM_RD_ADDR_WIDTH-1:0];

endmodule
