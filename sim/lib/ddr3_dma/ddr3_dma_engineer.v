module ddr3_dma_engineer
(
  clk,
  ddr_clk,
  rst,
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
  dout_rdy,
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
 //ddr3 Interface
  init_calib_complete,
  app_addr,
  app_cmd,
  app_rdy,
  app_en,
  app_rd_data,
  app_rd_data_end,
  app_rd_data_valid,
  app_wdf_data,
  app_wdf_rdy,  
  app_wdf_wren,
  app_wdf_end
);

input                   clk;
input					ddr_clk;
input                   rst;
//write_dma Interface
input                   write_req;
input  [26:0]           write_start_addr;
input  [26:0]           write_length;
output                  write_done;
input  [511:0]          din;
output                  din_rdy;
input                   din_en;
input                   din_eop;

//read_dma Interface
input                   dout_rdy;
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

//ddr3 Interface
input                   init_calib_complete;
output  [29:0]		    app_addr;
output  [2:0]		    app_cmd;
input		     	    app_rdy;
output                  app_en;
input  [511:0]          app_rd_data;
input                   app_rd_data_end;
input                   app_rd_data_valid;
                        
output [511:0]          app_wdf_data;
input			        app_wdf_rdy;  
output			        app_wdf_wren;
output			        app_wdf_end;
                        
                        
wire [29:0]		        write_app_addr;
wire [2:0]		        write_app_cmd;
wire                    write_app_en;
wire                    read_req;
wire [29:0]		        read_app_addr;
wire [2:0]		        read_app_cmd;
wire                    read_app_en;

ddr3_dma_write  u_ddr3_dma_write 
(
    .clk                     ( clk                  ),
    .ddr_clk                 ( ddr_clk              ),
    .rst                     ( rst                  ),
    .init_calib_complete     ( init_calib_complete  ),
    .app_rdy                 ( app_rdy              ),
    .app_wdf_rdy             ( app_wdf_rdy          ),
    .write_req               ( write_req            ),
    .write_start_addr        ( write_start_addr     ),
    .write_length            ( write_length         ),
    .write_done              ( write_done           ),
    .din                     ( din                  ),
    .din_en                  ( din_en               ),
    .din_eop                 ( din_eop              ),

    .app_addr                ( write_app_addr       ),
    .app_cmd                 ( write_app_cmd        ),
    .app_en                  ( write_app_en         ),
    .app_wdf_data            ( app_wdf_data         ),
    .app_wdf_wren            ( app_wdf_wren         ),
    .app_wdf_end             ( app_wdf_end          ),
    .din_rdy                 ( din_rdy              )
);


ddr3_dma_read   u_ddr3_dma_read 
(
    .clk                     ( clk                  ),
    .ddr_clk                 ( ddr_clk              ),
    .rst                     ( rst                  ),
    .init_calib_complete     ( init_calib_complete  ),
    .app_rdy                 ( app_rdy              ),
    .app_rd_data             ( app_rd_data          ),
    .app_rd_data_end         ( app_rd_data_end      ),
    .app_rd_data_valid       ( app_rd_data_valid    ),
    .read_req_0              ( read_req_0           ),
    .read_start_addr_0       ( read_start_addr_0    ),
    .read_length_0           ( read_length_0        ),
    .read_req_1              ( read_req_1           ),
    .read_start_addr_1       ( read_start_addr_1    ),
    .read_length_1           ( read_length_1        ),
    .read_req_2              ( read_req_2           ),
    .read_start_addr_2       ( read_start_addr_2    ),
    .read_length_2           ( read_length_2        ),
    .read_req_3              ( read_req_3           ),
    .read_start_addr_3       ( read_start_addr_3    ),
    .read_length_3           ( read_length_3        ),
    .read_req_4              ( read_req_4           ),
    .read_start_addr_4       ( read_start_addr_4    ),
    .read_length_4           ( read_length_4        ),
    .read_req_5              ( read_req_5           ),
    .read_start_addr_5       ( read_start_addr_5    ),
    .read_length_5           ( read_length_5        ),
    .read_req_6              ( read_req_6           ),
    .read_start_addr_6       ( read_start_addr_6    ),
    .read_length_6           ( read_length_6        ),
    .read_req_7              ( read_req_7           ),
    .read_start_addr_7       ( read_start_addr_7    ),
    .read_length_7           ( read_length_7        ),
    .read_req_8              ( read_req_8           ),
    .read_start_addr_8       ( read_start_addr_8    ),
    .read_length_8           ( read_length_8        ),
    .read_req_9              ( read_req_9           ),
    .read_start_addr_9       ( read_start_addr_9    ),
    .read_length_9           ( read_length_9        ),
    .read_req_10             ( read_req_10          ),
    .read_start_addr_10      ( read_start_addr_10   ),
    .read_length_10          ( read_length_10       ),
    .read_req_11             ( read_req_11          ),
    .read_start_addr_11      ( read_start_addr_11   ),
    .read_length_11          ( read_length_11       ),
    .read_req_12             ( read_req_12          ),
    .read_start_addr_12      ( read_start_addr_12   ),
    .read_length_12          ( read_length_12       ),
    .read_req_13             ( read_req_13          ),
    .read_start_addr_13      ( read_start_addr_13   ),
    .read_length_13          ( read_length_13       ),
    .read_req_14             ( read_req_14          ),
    .read_start_addr_14      ( read_start_addr_14   ),
    .read_length_14          ( read_length_14       ),
    .read_req_15             ( read_req_15          ),
    .read_start_addr_15      ( read_start_addr_15   ),
    .read_length_15          ( read_length_15       ),

    .app_addr                ( read_app_addr        ),
    .app_cmd                 ( read_app_cmd         ),
    .app_en                  ( read_app_en          ),
    .ddr_read                ( read_req             ),
    .dout_rdy                ( dout_rdy             ),
    .dout                    ( dout                 ),
    .dout_en                 ( dout_en              ),
    .dout_eop                ( dout_eop             ),
    .read_ack_0              ( read_ack_0           ),
    .read_ack_1              ( read_ack_1           ),
    .read_ack_2              ( read_ack_2           ),
    .read_ack_3              ( read_ack_3           ),
    .read_ack_4              ( read_ack_4           ),
    .read_ack_5              ( read_ack_5           ),
    .read_ack_6              ( read_ack_6           ),
    .read_ack_7              ( read_ack_7           ),
    .read_ack_8              ( read_ack_8           ),
    .read_ack_9              ( read_ack_9           ),
    .read_ack_10             ( read_ack_10          ),
    .read_ack_11             ( read_ack_11          ),
    .read_ack_12             ( read_ack_12          ),
    .read_ack_13             ( read_ack_13          ),
    .read_ack_14             ( read_ack_14          ),
    .read_ack_15             ( read_ack_15          )
);

ddr3_dma_mux  u_ddr3_dma_mux 
(
    .clk                     ( clk                  ),
    .rst                     ( rst                  ),

    .write_req               ( write_req            ),
    .write_app_cmd           ( write_app_cmd        ),
    .write_app_addr          ( write_app_addr       ),
    .write_app_en            ( write_app_en         ),

    .read_req                ( read_req             ),
    .read_app_cmd            ( read_app_cmd         ),
    .read_app_addr           ( read_app_addr        ),
    .read_app_en             ( read_app_en          ),
                                                    
    .app_cmd                 ( app_cmd              ),
    .app_addr                ( app_addr             ),
    .app_en                  ( app_en               )
);

endmodule
