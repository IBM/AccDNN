`timescale 1ns/1ps


//`define half_clk_cycle 50
`define total_input_count 1920 //96*2
`define total_weight_count 98610 //516262 //4568 //4544
`define iterations 1
`define databus_width 512
module model_tb();

//input
wire	          blob_din_eop;
reg    [`databus_width-1:0]    blob_din;
wire	          blob_din_en;
reg	              blob_dout_rdy;

reg               write_req;
reg    [26:0]     write_start_addr = 0;
reg    [26:0]     write_length = `total_weight_count;
wire              ddr_din_en;
wire              ddr_din_eop;
reg    [511:0]    ddr_din;

//output
wire	          blob_dout_en;
wire	          blob_dout_eop;
wire	          blob_din_rdy;
wire  [`databus_width-1:0]	      blob_dout;

wire              write_done;
wire              ddr_din_rdy;

wire              clk;
reg               ddr_rst;
reg               rst;
wire              init_calib_complete;

reg input_rdy;

wire ddr_read_req_0; 
wire ddr_read_req_1;  
wire ddr_read_req_2;  
wire ddr_read_req_3;  
wire ddr_read_req_4;  
wire ddr_read_req_5;  
wire ddr_read_req_6;  
wire ddr_read_req_7;  
wire ddr_read_req_8;  
wire ddr_read_req_9;  
wire ddr_read_req_10; 
wire ddr_read_req_11; 
wire ddr_read_req_12; 
wire ddr_read_req_13; 
wire ddr_read_req_14; 
wire ddr_read_req_15; 

wire [26:0] ddr_read_start_addr_0; 
wire [26:0] ddr_read_start_addr_1; 
wire [26:0] ddr_read_start_addr_2; 
wire [26:0] ddr_read_start_addr_3; 
wire [26:0] ddr_read_start_addr_4; 
wire [26:0] ddr_read_start_addr_5; 
wire [26:0] ddr_read_start_addr_6; 
wire [26:0] ddr_read_start_addr_7; 
wire [26:0] ddr_read_start_addr_8; 
wire [26:0] ddr_read_start_addr_9; 
wire [26:0] ddr_read_start_addr_10;
wire [26:0] ddr_read_start_addr_11;
wire [26:0] ddr_read_start_addr_12;
wire [26:0] ddr_read_start_addr_13;
wire [26:0] ddr_read_start_addr_14;
wire [26:0] ddr_read_start_addr_15;

wire [26:0] ddr_read_length_0; 
wire [26:0] ddr_read_length_1; 
wire [26:0] ddr_read_length_2; 
wire [26:0] ddr_read_length_3; 
wire [26:0] ddr_read_length_4; 
wire [26:0] ddr_read_length_5; 
wire [26:0] ddr_read_length_6; 
wire [26:0] ddr_read_length_7; 
wire [26:0] ddr_read_length_8;
wire [26:0] ddr_read_length_9; 
wire [26:0] ddr_read_length_10;
wire [26:0] ddr_read_length_11;
wire [26:0] ddr_read_length_12;
wire [26:0] ddr_read_length_13;
wire [26:0] ddr_read_length_14;
wire [26:0] ddr_read_length_15;

wire ddr_read_ack_0; 
wire ddr_read_ack_1; 
wire ddr_read_ack_2; 
wire ddr_read_ack_3; 
wire ddr_read_ack_4; 
wire ddr_read_ack_5;	
wire ddr_read_ack_6; 
wire ddr_read_ack_7; 
wire ddr_read_ack_8; 
wire ddr_read_ack_9; 
wire ddr_read_ack_10;
wire ddr_read_ack_11;
wire ddr_read_ack_12;
wire ddr_read_ack_13;
wire ddr_read_ack_14;
wire ddr_read_ack_15;	

wire [15:0] ddr_dout_en;
wire ddr_dout_eop;
wire [511:0] ddr_dout;

// Instantiate the Unit Under Test
model  u0_module (
    .clk                     ( clk                     ),
    .rst                     ( rst                     ),
                                                       
    .ddr_dout_en             ( ddr_dout_en             ),
    .ddr_dout_eop            ( ddr_dout_eop            ),
    .ddr_dout                ( ddr_dout                ),
	                                                   
	.blob_din_rdy            ( blob_din_rdy            ),
    .blob_din_en             ( blob_din_en             ),
    .blob_din_eop            ( blob_din_eop            ),
    .blob_din                ( blob_din                ),
	                                                   
    .blob_dout_rdy           ( blob_dout_rdy           ),
    .blob_dout_en            ( blob_dout_en            ),
    .blob_dout_eop           ( blob_dout_eop           ),
    .blob_dout               ( blob_dout               ),
                                                       
    .ddr_read_req_0          ( ddr_read_req_0          ),
    .ddr_read_req_1          ( ddr_read_req_1          ),
    .ddr_read_req_2          ( ddr_read_req_2          ),
    .ddr_read_req_3          ( ddr_read_req_3          ),
    .ddr_read_req_4          ( ddr_read_req_4          ),
    .ddr_read_req_5          ( ddr_read_req_5          ),
    .ddr_read_req_6          ( ddr_read_req_6          ),
    .ddr_read_req_7          ( ddr_read_req_7          ),
    .ddr_read_req_8          ( ddr_read_req_8          ),
    .ddr_read_req_9          ( ddr_read_req_9          ),
    .ddr_read_req_10         ( ddr_read_req_10         ),
    .ddr_read_req_11         ( ddr_read_req_11         ),
    .ddr_read_req_12         ( ddr_read_req_12         ),
    .ddr_read_req_13         ( ddr_read_req_13         ),
    .ddr_read_req_14         ( ddr_read_req_14         ),
	
    .ddr_read_start_addr_0   ( ddr_read_start_addr_0   ),
    .ddr_read_start_addr_1   ( ddr_read_start_addr_1   ),
    .ddr_read_start_addr_2   ( ddr_read_start_addr_2   ),
    .ddr_read_start_addr_3   ( ddr_read_start_addr_3   ),
    .ddr_read_start_addr_4   ( ddr_read_start_addr_4   ),	
    .ddr_read_start_addr_5   ( ddr_read_start_addr_5   ),	
    .ddr_read_start_addr_6   ( ddr_read_start_addr_6   ),
    .ddr_read_start_addr_7   ( ddr_read_start_addr_7   ),
    .ddr_read_start_addr_8   ( ddr_read_start_addr_8   ),	
    .ddr_read_start_addr_9   ( ddr_read_start_addr_9   ),
    .ddr_read_start_addr_10  ( ddr_read_start_addr_10  ),
    .ddr_read_start_addr_11  ( ddr_read_start_addr_11  ),
    .ddr_read_start_addr_12  ( ddr_read_start_addr_12  ),
    .ddr_read_start_addr_13  ( ddr_read_start_addr_13  ),
    .ddr_read_start_addr_14  ( ddr_read_start_addr_14  ),
	                                                  
    .ddr_read_length_0       ( ddr_read_length_0       ),
    .ddr_read_length_1       ( ddr_read_length_1       ),
    .ddr_read_length_2       ( ddr_read_length_2       ),
    .ddr_read_length_3       ( ddr_read_length_3       ),
    .ddr_read_length_4       ( ddr_read_length_4       ),
    .ddr_read_length_5       ( ddr_read_length_5       ),
    .ddr_read_length_6       ( ddr_read_length_6       ),
    .ddr_read_length_7       ( ddr_read_length_7       ),
    .ddr_read_length_8       ( ddr_read_length_8       ),
    .ddr_read_length_9       ( ddr_read_length_9       ),
    .ddr_read_length_10      ( ddr_read_length_10      ),
    .ddr_read_length_11      ( ddr_read_length_11      ),
    .ddr_read_length_12      ( ddr_read_length_12      ),
    .ddr_read_length_13      ( ddr_read_length_13      ),
    .ddr_read_length_14      ( ddr_read_length_14      ),

    .ddr_read_ack_0          ( ddr_read_ack_0          ),
    .ddr_read_ack_1          ( ddr_read_ack_1          ),
    .ddr_read_ack_2          ( ddr_read_ack_2          ),
    .ddr_read_ack_3          ( ddr_read_ack_3          ),
    .ddr_read_ack_4          ( ddr_read_ack_4          ),
    .ddr_read_ack_5          ( ddr_read_ack_5          ),
    .ddr_read_ack_6          ( ddr_read_ack_6          ),
    .ddr_read_ack_7          ( ddr_read_ack_7          ),
    .ddr_read_ack_8          ( ddr_read_ack_8          ),
    .ddr_read_ack_9          ( ddr_read_ack_9          ),
    .ddr_read_ack_10         ( ddr_read_ack_10         ),
    .ddr_read_ack_11         ( ddr_read_ack_11         ),
    .ddr_read_ack_12         ( ddr_read_ack_12         ),
    .ddr_read_ack_13         ( ddr_read_ack_13         ),	
    .ddr_read_ack_14         ( ddr_read_ack_14         )
);

top_dma_ddr  u0_top_dma_ddr (
    .clk                     ( clk                     ),
    .ddr_rst                 ( ddr_rst                 ),
    .rst                     ( rst                     ),
    .init_calib_complete     ( init_calib_complete     ),
                                                      
    .write_req               ( write_req               ),
    .write_start_addr        ( write_start_addr        ),
    .write_length            ( write_length            ),
    .write_done              ( write_done              ),
	.din_rdy                 ( ddr_din_rdy             ),
    .din_en                  ( ddr_din_en              ),
    .din_eop                 ( ddr_din_eop             ),
    .din                     ( ddr_din                 ),
                                                       
    .dout_en                 ( ddr_dout_en             ),
    .dout_eop                ( ddr_dout_eop            ),
    .dout                    ( ddr_dout                ),
	                                                  
    .read_req_0              ( ddr_read_req_0          ),
    .read_req_1              ( ddr_read_req_1          ),
    .read_req_2              ( ddr_read_req_2          ),
    .read_req_3              ( ddr_read_req_3          ),
    .read_req_4              ( ddr_read_req_4          ),
    .read_req_5              ( ddr_read_req_5          ),
    .read_req_6              ( ddr_read_req_6          ),
    .read_req_7              ( ddr_read_req_7          ),
    .read_req_8              ( ddr_read_req_8          ),
    .read_req_9              ( ddr_read_req_9          ),
    .read_req_10             ( ddr_read_req_10         ),
    .read_req_11             ( ddr_read_req_11         ),
    .read_req_12             ( ddr_read_req_12         ),
    .read_req_13             ( ddr_read_req_13         ),
    .read_req_14             ( ddr_read_req_14         ),
    .read_req_15             ( 1'b0                    ),

    .read_start_addr_0       ( ddr_read_start_addr_0   ),
    .read_start_addr_1       ( ddr_read_start_addr_1   ),
    .read_start_addr_2       ( ddr_read_start_addr_2   ),
    .read_start_addr_3       ( ddr_read_start_addr_3   ),
    .read_start_addr_4       ( ddr_read_start_addr_4   ),
    .read_start_addr_5       ( ddr_read_start_addr_5   ),
    .read_start_addr_6       ( ddr_read_start_addr_6   ),
    .read_start_addr_7       ( ddr_read_start_addr_7   ),
    .read_start_addr_8       ( ddr_read_start_addr_8   ),
    .read_start_addr_9       ( ddr_read_start_addr_9   ),
    .read_start_addr_10      ( ddr_read_start_addr_10  ),
    .read_start_addr_11      ( ddr_read_start_addr_11  ),	
    .read_start_addr_12      ( ddr_read_start_addr_12  ),
    .read_start_addr_13      ( ddr_read_start_addr_13  ),
    .read_start_addr_14      ( ddr_read_start_addr_14  ),
    .read_start_addr_15      ( 27'b0                   ),
                                                      
    .read_length_0           ( ddr_read_length_0       ),
    .read_length_1           ( ddr_read_length_1       ),
    .read_length_2           ( ddr_read_length_2       ),
    .read_length_3           ( ddr_read_length_3       ),
    .read_length_4           ( ddr_read_length_4       ),
    .read_length_5           ( ddr_read_length_5       ),
    .read_length_6           ( ddr_read_length_6       ),
    .read_length_7           ( ddr_read_length_7       ),
    .read_length_8           ( ddr_read_length_8       ),
    .read_length_9           ( ddr_read_length_9       ),
    .read_length_10          ( ddr_read_length_10      ),
    .read_length_11          ( ddr_read_length_11      ),
    .read_length_12          ( ddr_read_length_12      ),
    .read_length_13          ( ddr_read_length_13      ),
    .read_length_14          ( ddr_read_length_14      ),
    .read_length_15          ( 27'b0                   ),
                                                      
    .read_ack_0              ( ddr_read_ack_0          ),
    .read_ack_1              ( ddr_read_ack_1          ),
    .read_ack_2              ( ddr_read_ack_2          ),
    .read_ack_3              ( ddr_read_ack_3          ),
    .read_ack_4              ( ddr_read_ack_4          ),
    .read_ack_5              ( ddr_read_ack_5          ),
    .read_ack_6              ( ddr_read_ack_6          ),
    .read_ack_7              ( ddr_read_ack_7          ),
    .read_ack_8              ( ddr_read_ack_8          ),
    .read_ack_9              ( ddr_read_ack_9          ),
    .read_ack_10             ( ddr_read_ack_10         ),
    .read_ack_11             ( ddr_read_ack_11         ),
    .read_ack_12             ( ddr_read_ack_12         ),
    .read_ack_13             ( ddr_read_ack_13         ),
    .read_ack_14             ( ddr_read_ack_14         ),
    .read_ack_15             ( ddr_read_ack_15         )
);

//	initial
//    begin
//      $fsdbDumpfile("wave_model.fsdb");
//      $fsdbDumpvars;
//    end	
	
//always #`half_clk_cycle clk = ~clk;

initial 
  begin
    // Initialize Inputs
    ddr_rst = 1'b0;
    rst = 1'b0;
    blob_din = 512'h0;
    blob_dout_rdy = 1'b0;
    input_rdy = 1'b0;
    write_req = 1'b0;
    #10
    ddr_rst = 1'b1;
    #200;
    ddr_rst = 1'b0;
    #2000;
    rst = 1'b1;
    // Wait 100 ns for global reset to finish
    #10;
    rst = 1'b0;
    blob_dout_rdy = 1'b1;   

//    #100;    
//	input_rdy = 1'b1;
	
  end

initial 
begin
  wait(init_calib_complete)
  begin
    repeat (5000) @(posedge clk);
    write_req = 1'b1;
	repeat (1)   @(posedge clk);
    write_req = 1'b0;
  end
end

//file initializiation
integer file_read;
integer file_weight;
integer r1;
integer r2;
integer file_model;
integer file_conv1;
integer file_pool1;
integer file_conv2;
integer file_pool2;
integer file_conv3;
integer file_pool3;
integer file_conv4;
integer file_pool4;
integer file_conv5;
integer file_pool5;
integer file_conv6;
integer file_conv7;
integer file_conv8;
integer file_conv9;
integer file_out;

initial
  begin
    file_read  = $fopen({"../data/input_sim.dat"},"r");
	file_weight= $fopen({"../data/weights_sim.dat"},"r");
  	file_model = $fopen({"../data/output_sim.dat"},"w");
  	file_conv1 = $fopen({"../data/conv1_sim.dat"},"w");
	file_pool1 = $fopen({"../data/pool1_sim.dat"},"w");
    file_conv2 = $fopen({"../data/conv2_sim.dat"},"w");
	file_pool2 = $fopen({"../data/pool2_sim.dat"},"w");
    file_conv3 = $fopen({"../data/conv3_sim.dat"},"w");
    file_pool3 = $fopen({"../data/pool3_sim.dat"},"w");
    file_conv4 = $fopen({"../data/conv4_sim.dat"},"w");
    file_pool4 = $fopen({"../data/pool4_sim.dat"},"w");
    file_conv5 = $fopen({"../data/conv5_sim.dat"},"w");
	file_pool5 = $fopen({"../data/pool5_sim.dat"},"w");
    file_conv6 = $fopen({"../data/conv6_sim.dat"},"w");
    file_conv7 = $fopen({"../data/conv7_sim.dat"},"w");
    file_conv8 = $fopen({"../data/conv8_sim.dat"},"w");
    file_conv9 = $fopen({"../data/conv9_sim.dat"},"w");

    file_out   = $fopen({"../data/out_sim.dat"},"w");
  end

initial
begin
  wait(write_done)
  begin
    repeat (3000) @(posedge clk);
    input_rdy = 1'b1;
  end
end

reg [31:0] input_count;
always @ (posedge clk)
begin
   if (rst)
     input_count <= 32'b0;
   else if (blob_din_en == 1'b1)
     if (input_count == `total_input_count -1)
         input_count <= 32'b0;
     else
       input_count <= input_count + 1;
end


assign blob_din_en = input_rdy & blob_din_rdy & (input_count < `total_input_count);
assign blob_din_eop = blob_din_en & (input_count == `total_input_count -1);

reg rst_d1;
always @ (posedge clk)
begin
    rst_d1 <= rst;
end

//read data
always @(posedge clk)
begin
    if(rst == 1'b0 && rst_d1 == 1'b1)
      r1 <= $fscanf(file_read,"%h",blob_din);
    else if(blob_din_en == 1'b1) 
      r1 <= $fscanf(file_read,"%h",blob_din);
end
  
reg [31:0] weight_count;
always @ (posedge clk)
begin
   if (rst)
     weight_count <= 32'b0;
   else if (ddr_din_en == 1'b1)
     weight_count <= weight_count + 1;
end

assign ddr_din_en = init_calib_complete & ddr_din_rdy & (weight_count < `total_weight_count);
assign ddr_din_eop = ddr_din_en & (weight_count == `total_weight_count -1);

reg [31:0] iteration_count;
always @ (posedge clk)
begin
   if (rst)
     iteration_count <= 32'b0;
   else if (iteration_count == `iterations)
     begin
         $display("Simulation done at %t.", $time);
         $finish;
     end
   else if (blob_dout_eop == 1'b1)
     iteration_count <= iteration_count + 1;
end

//read weights
always @ (posedge clk)
begin
    if(rst == 1'b0 && rst_d1 == 1'b1)
        r2 <= $fscanf(file_weight,"%h",ddr_din);
    else if(ddr_din_en == 1'b1)
	    r2 <= $fscanf(file_weight,"%h",ddr_din);
end

//write data
always @(posedge clk)
begin
  if(blob_dout_en)
    begin
      $fdisplay(file_model,"%h",blob_dout);
    end
end       

always @(posedge clk)
  begin
    if(u0_module.u0_conv1_layer.blob_dout_en)
      begin
       $fdisplay(file_conv1,"%h",u0_module.u0_conv1_layer.blob_dout);
      end
  end       

always @(posedge clk)
  begin
    if(u0_module.u0_pool1_layer.blob_dout_en)
      begin
       $fdisplay(file_pool1,"%h",u0_module.u0_pool1_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_conv2_layer.blob_dout_en)
      begin
       $fdisplay(file_conv2,"%h",u0_module.u0_conv2_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_pool2_layer.blob_dout_en)
      begin
       $fdisplay(file_pool2,"%h",u0_module.u0_pool2_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_conv3_layer.blob_dout_en)
      begin
       $fdisplay(file_conv3,"%h",u0_module.u0_conv3_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_pool3_layer.blob_dout_en)
      begin
       $fdisplay(file_pool3,"%h",u0_module.u0_pool3_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_conv4_layer.blob_dout_en)
      begin
       $fdisplay(file_conv4,"%h",u0_module.u0_conv4_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_pool4_layer.blob_dout_en)
      begin
       $fdisplay(file_pool4,"%h",u0_module.u0_pool4_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_conv5_layer.blob_dout_en)
      begin
       $fdisplay(file_conv5,"%h",u0_module.u0_conv5_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_pool5_layer.blob_dout_en)
      begin
       $fdisplay(file_pool5,"%h",u0_module.u0_pool5_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_conv6_layer.blob_dout_en)
      begin
       $fdisplay(file_conv6,"%h",u0_module.u0_conv6_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_conv7_layer.blob_dout_en)
      begin
       $fdisplay(file_conv7,"%h",u0_module.u0_conv7_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_conv8_layer.blob_dout_en)
      begin
       $fdisplay(file_conv8,"%h",u0_module.u0_conv8_layer.blob_dout);
      end
  end

always @(posedge clk)
  begin
    if(u0_module.u0_conv9_layer.blob_dout_en)
      begin
       $fdisplay(file_conv9,"%h",u0_module.u0_conv9_layer.blob_dout);
      end
  end

  
always @(posedge clk)
  begin
    if(blob_dout_en)
      begin
       $fdisplay(file_out,"%h",blob_dout);
       $fflush(file_out);
      end
  end

endmodule
