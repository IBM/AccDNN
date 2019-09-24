
module top_dma_ddr
(
  //write_dma Interface
  write_req,
  write_start_addr,
  write_length,
  write_done,
  din,
  din_rdy,
  din_en,
  din_eop,
  //read_dma Interface
  dout,
  dout_en,
  dout_eop,
  
  read_req_0,
  read_start_addr_0,
  read_length_0,
  read_ack_0,  
  
  read_req_1,
  read_start_addr_1,
  read_length_1,
  read_ack_1,  
  
  read_req_2,
  read_start_addr_2,
  read_length_2,
  read_ack_2, 
  
  read_req_3,
  read_start_addr_3,
  read_length_3,
  read_ack_3,  
  
  read_req_4,
  read_start_addr_4,
  read_length_4,
  read_ack_4, 
  
  read_req_5,
  read_start_addr_5,
  read_length_5,
  read_ack_5,
  
  read_req_6,
  read_start_addr_6,
  read_length_6,
  read_ack_6,
  
  read_req_7,
  read_start_addr_7,
  read_length_7,
  read_ack_7, 
  
  read_req_8,
  read_start_addr_8,
  read_length_8,
  read_ack_8, 
  
  read_req_9,
  read_start_addr_9,
  read_length_9,
  read_ack_9,  
  
  read_req_10,
  read_start_addr_10,
  read_length_10,
  read_ack_10,
  
  read_req_11,
  read_start_addr_11,
  read_length_11,
  read_ack_11,
  
  read_req_12,
  read_start_addr_12,
  read_length_12,
  read_ack_12, 
  
  read_req_13,
  read_start_addr_13,
  read_length_13,
  read_ack_13,
  
  read_req_14,
  read_start_addr_14,
  read_length_14,
  read_ack_14, 
  
  read_req_15,
  read_start_addr_15,
  read_length_15,
  read_ack_15, 
  
  clk,
  rst,
  ddr_rst,
  init_calib_complete
);

//write_dma Interface
input             write_req;
input  [26:0]     write_start_addr;
input  [26:0]     write_length;
output            write_done;
input  [511:0]    din;
output            din_rdy;
input             din_en;
input             din_eop;

//read_dma Interface
output     [511:0]      dout;
output     [15:0]       dout_en;
output                  dout_eop;      

input                   read_req_0;
input  [26:0]           read_start_addr_0;
input  [26:0]           read_length_0;
output                  read_ack_0;


input                   read_req_1;
input  [26:0]           read_start_addr_1;
input  [26:0]           read_length_1;
output                  read_ack_1;


input                   read_req_2;
input  [26:0]           read_start_addr_2;
input  [26:0]           read_length_2;
output                  read_ack_2;


input                   read_req_3;
input  [26:0]           read_start_addr_3;
input  [26:0]           read_length_3;
output                  read_ack_3;


input                   read_req_4;
input  [26:0]           read_start_addr_4;
input  [26:0]           read_length_4;
output                  read_ack_4;


input                   read_req_5;
input  [26:0]           read_start_addr_5;
input  [26:0]           read_length_5;
output                  read_ack_5;


input                   read_req_6;
input  [26:0]           read_start_addr_6;
input  [26:0]           read_length_6;
output                  read_ack_6;


input                   read_req_7;
input  [26:0]           read_start_addr_7;
input  [26:0]           read_length_7;
output                  read_ack_7;


input                   read_req_8;
input  [26:0]           read_start_addr_8;
input  [26:0]           read_length_8;
output                  read_ack_8;


input                   read_req_9;
input  [26:0]           read_start_addr_9;
input  [26:0]           read_length_9;
output                  read_ack_9;


input                   read_req_10;
input  [26:0]           read_start_addr_10;
input  [26:0]           read_length_10;
output                  read_ack_10;


input                   read_req_11;
input  [26:0]           read_start_addr_11;
input  [26:0]           read_length_11;
output                  read_ack_11;


input                   read_req_12;
input  [26:0]           read_start_addr_12;
input  [26:0]           read_length_12;
output                  read_ack_12;


input                   read_req_13;
input  [26:0]           read_start_addr_13;
input  [26:0]           read_length_13;
output                  read_ack_13;


input                   read_req_14;
input  [26:0]           read_start_addr_14;
input  [26:0]           read_length_14;
output                  read_ack_14;


input                   read_req_15;
input  [26:0]           read_start_addr_15;
input  [26:0]           read_length_15;
output                  read_ack_15;

output                  init_calib_complete;
output                  clk;
input                   rst;
input                   ddr_rst;
  
wire [29:0]                           app_addr;
wire [2:0]                            app_cmd;
wire                                  app_en;
wire                                  app_rdy;
wire [511:0]                          app_rd_data;
wire                                  app_rd_data_end;
wire                                  app_rd_data_valid;
wire [511:0]                          app_wdf_data;
wire                                  app_wdf_wren;
wire                                  app_wdf_end;
wire                                  app_wdf_rdy;
wire [63:0]                           app_wdf_mask;

/*
assign  app_wdf_mask = 64'b0;
ddr3_sim_top  u_ddr3_sim_top
(
.init_calib_complete (init_calib_complete),
.app_addr            (app_addr),
.app_cmd             (app_cmd),
.app_en              (app_en),
.app_wdf_data        (app_wdf_data),
.app_wdf_end         (app_wdf_end),
.app_wdf_wren        (app_wdf_wren),
.app_rd_data         (app_rd_data),
.app_rd_data_end     (app_rd_data_end),
.app_rd_data_valid   (app_rd_data_valid),
.app_rdy             (app_rdy),
.app_wdf_rdy         (app_wdf_rdy),
.clk                 (clk),    
.rst                 (rst),
.app_wdf_mask        (app_wdf_mask)
);
*/

ddr_mode  u_ddr3_sim_top
(
.init_done           (init_calib_complete),
.app_addr            (app_addr),
.app_cmd             (app_cmd),
.app_en              (app_en),
.app_wdf_data        (app_wdf_data),
.app_wdf_end         (app_wdf_end),
.app_wdf_wren        (app_wdf_wren),
.app_rd_data         (app_rd_data),
.app_rd_data_end     (app_rd_data_end),
.app_rd_data_valid   (app_rd_data_valid),
.app_rdy             (app_rdy),
.app_wdf_rdy         (app_wdf_rdy),
.clk_ddr             (clk),
.reset               (ddr_rst)
);


ddr3_dma_engineer  u_ddr3_dma_engineer 
(
    .clk                     ( clk                   ),
    .ddr_clk                 ( clk                   ),
    .rst                     ( rst                   ),
    .write_req               ( write_req             ),
    .write_start_addr        ( write_start_addr      ),
    .write_length            ( write_length          ),
    .din                     ( din                   ),
    .din_en                  ( din_en                ),
    .din_eop                 ( din_eop               ),
    .read_req_0              ( read_req_0            ),
    .read_start_addr_0       ( read_start_addr_0     ),
    .read_length_0           ( read_length_0         ),
    .read_req_1              ( read_req_1            ),
    .read_start_addr_1       ( read_start_addr_1     ),
    .read_length_1           ( read_length_1         ),
    .read_req_2              ( read_req_2            ),
    .read_start_addr_2       ( read_start_addr_2     ),
    .read_length_2           ( read_length_2         ),
    .read_req_3              ( read_req_3            ),
    .read_start_addr_3       ( read_start_addr_3     ),
    .read_length_3           ( read_length_3         ),
    .read_req_4              ( read_req_4            ),
    .read_start_addr_4       ( read_start_addr_4     ),
    .read_length_4           ( read_length_4         ),
    .read_req_5              ( read_req_5            ),
    .read_start_addr_5       ( read_start_addr_5     ),
    .read_length_5           ( read_length_5         ),
    .read_req_6              ( read_req_6            ),
    .read_start_addr_6       ( read_start_addr_6     ),
    .read_length_6           ( read_length_6         ),
    .read_req_7              ( read_req_7            ),
    .read_start_addr_7       ( read_start_addr_7     ),
    .read_length_7           ( read_length_7         ),
    .read_req_8              ( read_req_8            ),
    .read_start_addr_8       ( read_start_addr_8     ),
    .read_length_8           ( read_length_8         ),
    .read_req_9              ( read_req_9            ),
    .read_start_addr_9       ( read_start_addr_9     ),
    .read_length_9           ( read_length_9         ),
    .read_req_10             ( read_req_10           ),
    .read_start_addr_10      ( read_start_addr_10    ),
    .read_length_10          ( read_length_10        ),
    .read_req_11             ( read_req_11           ),
    .read_start_addr_11      ( read_start_addr_11    ),
    .read_length_11          ( read_length_11        ),
    .read_req_12             ( read_req_12           ),
    .read_start_addr_12      ( read_start_addr_12    ),
    .read_length_12          ( read_length_12        ),
    .read_req_13             ( read_req_13           ),
    .read_start_addr_13      ( read_start_addr_13    ),
    .read_length_13          ( read_length_13        ),
    .read_req_14             ( read_req_14           ),
    .read_start_addr_14      ( read_start_addr_14    ),
    .read_length_14          ( read_length_14        ),
    .read_req_15             ( read_req_15           ),
    .read_start_addr_15      ( read_start_addr_15    ),
    .read_length_15          ( read_length_15        ),
    .init_calib_complete     ( init_calib_complete   ),
    .app_rdy                 ( app_rdy               ),
    .app_rd_data             ( app_rd_data           ),
    .app_rd_data_end         ( app_rd_data_end       ),
    .app_rd_data_valid       ( app_rd_data_valid     ),
    .app_wdf_rdy             ( app_wdf_rdy           ),
                                                    
    .write_done              ( write_done            ),
    .din_rdy                 ( din_rdy               ),
    .dout_rdy                ( 1'b1                  ),
    .dout                    ( dout                  ),
    .dout_en                 ( dout_en               ),
    .dout_eop                ( dout_eop              ),
    .read_ack_0              ( read_ack_0            ),
    .read_ack_1              ( read_ack_1            ),
    .read_ack_2              ( read_ack_2            ),
    .read_ack_3              ( read_ack_3            ),
    .read_ack_4              ( read_ack_4            ),
    .read_ack_5              ( read_ack_5            ),
    .read_ack_6              ( read_ack_6            ),
    .read_ack_7              ( read_ack_7            ),
    .read_ack_8              ( read_ack_8            ),
    .read_ack_9              ( read_ack_9            ),
    .read_ack_10             ( read_ack_10           ),
    .read_ack_11             ( read_ack_11           ),
    .read_ack_12             ( read_ack_12           ),
    .read_ack_13             ( read_ack_13           ),
    .read_ack_14             ( read_ack_14           ),
    .read_ack_15             ( read_ack_15           ),
    .app_addr                ( app_addr              ),
    .app_cmd                 ( app_cmd               ),
    .app_en                  ( app_en                ),
    .app_wdf_data            ( app_wdf_data          ),
    .app_wdf_wren            ( app_wdf_wren          ),
    .app_wdf_end             ( app_wdf_end           )
);

endmodule
