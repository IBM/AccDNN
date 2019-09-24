module ddr3_dma_write
(
  clk,
  ddr_clk,
  rst,

  //ddr3 Interface
  init_calib_complete,
  app_addr,
  app_cmd,
  app_rdy,
  app_en,
  app_wdf_data,
  app_wdf_rdy,  
  app_wdf_wren,
  app_wdf_end,

  //dma Interface
  write_req,
  write_start_addr,
  write_length,
  write_done,

  din_rdy,
  din_en,
  din,
  din_eop
);

input                   clk;
input					ddr_clk;
input                   rst;

//ddr3 Interface
input                   init_calib_complete;
output     [29:0]		app_addr;
output     [2:0]		app_cmd;
input			        app_rdy;
output   		        app_en;
output     [511:0]      app_wdf_data;
input			        app_wdf_rdy;  
output			        app_wdf_wren;
output			        app_wdf_end;

//dma Interface
input                   write_req;
input  [26:0]           write_start_addr;
input  [26:0]           write_length;
output reg              write_done;

output                  din_rdy;
input                   din_en;
input  [511:0]          din;
input                   din_eop;


reg     [26:0]          write_left;
reg                     pre_done;
reg                     write_en;



reg     [29:0]			write_addr;

always @ (posedge clk)
begin
  write_addr [2:0]	<= 3'h0;

  if(write_req)
	write_addr [29:3] <= write_start_addr;
  else if (din_en)
	write_addr [29:3] <= write_addr [29:3] + 1;
end

// Assuming the write_length is always >= 2
always @ (posedge clk)
begin
  if(write_req)
	write_left  <= write_length;
  else if (din_en & write_en)
	write_left  <= write_left - 1;
end

always @ (posedge clk)
begin
  if (write_req)
    pre_done    <= 0;
  else if (din_en & (~|write_left [26:2]) & write_left [1] & (~write_left [0]))
    pre_done    <= 1;
end

always @ (posedge clk)
begin
  if (rst)
    write_en    <= 0;
  else if (write_req)
    write_en    <= 1;
  else if (din_en & (pre_done | din_eop))
    write_en    <= 0;
end

always @ (posedge clk)
  write_done    <= din_en & write_en & (pre_done | din_eop);


wire				ddr_write_fifo_wen;
wire				ddr_write_fifo_afull;

// There is no buffer here, so follow control happens outside
assign	ddr_write_fifo_wen	= din_en & write_en;
assign	din_rdy				= write_en & ~ddr_write_fifo_afull;


/*
SYNC_FIFO_WRAPPER # (9, 542, 480)	ddr_write_fifo
(
	.reset_i(rst),
	.clk_i(clk),
	.w_en_i(ddr_write_fifo_wen),
	.w_din_i({write_addr, din}),

	.r_en_i(ddr_write_fifo_rd),
	.r_dout_o({app_addr, app_wdf_data}),

	.full_o(),
	.afull_o(ddr_write_fifo_afull),
	.empty_o(ddr_write_fifo_empty)
);
*/

ddr_write_fifo	ddr_write_fifo
(
	.rst(rst),
	.wr_clk(clk),
	.wr_en(ddr_write_fifo_wen),
	.din({write_addr, din}),

	.rd_clk(ddr_clk),
	.rd_en(ddr_write_fifo_rd),
	.dout({app_addr, app_wdf_data}),

	.full(),
	.empty(ddr_write_fifo_empty),
	.prog_full(ddr_write_fifo_afull)
);


assign	ddr_write_fifo_rd	= app_wdf_rdy & app_rdy & ~(ddr_write_fifo_empty);
assign	app_wdf_wren		= ddr_write_fifo_rd;
assign	app_wdf_end			= ddr_write_fifo_rd;

assign	app_en				= ddr_write_fifo_rd;
assign	app_cmd				= 3'b0; //ddr write command.  

endmodule
