module ddr_mode
(
  reset,

  clk_ddr,
  init_done,
  app_rdy,
  app_cmd,
  app_addr,
  app_en,

  app_rd_data,
  app_rd_data_end,
  app_rd_data_valid,

  app_wdf_rdy,
  app_wdf_data,
  app_wdf_wren,
  app_wdf_end
);

parameter SIM_DDR_SIZE		= 128*1024*1024;
parameter APP_DATA_WIDTH	= 512;
parameter APP_ADDR_WIDTH	= 30;



input                           reset;

output                          clk_ddr;
output                          init_done;

output							app_rdy;
input  [2:0]					app_cmd;
input  [APP_ADDR_WIDTH-1:0]		app_addr;
input							app_en;

output   [APP_DATA_WIDTH-1:0]   app_rd_data;
output                          app_rd_data_end;
output                          app_rd_data_valid;

output                          app_wdf_rdy;
input  [APP_DATA_WIDTH-1:0]		app_wdf_data;
input							app_wdf_wren;
input							app_wdf_end;


/*
assign	init_done	= 1;
assign	app_rdy		= 1;
assign	app_wdf_rdy	= 1;

reg         app_rd_data_valid;
reg         app_rd_data_end;
reg [0:APP_DATA_WIDTH-1]  app_rd_data;

reg             app_en_dly1;
reg             app_en_dly2;
reg             app_en_dly3;
reg             app_en_dly4;

always @ (posedge clk_acc)
begin
	app_en_dly1 <= app_en & (app_cmd == 3'h1);
	app_en_dly2 <= app_en_dly1;
	app_en_dly3 <= app_en_dly2;
	app_en_dly4 <= app_en_dly3;
	app_rd_data_valid   <= app_en_dly4;
	app_rd_data_end		<= app_en_dly4;
	app_rd_data			<= app_wdf_data | {{DDR_DATA_WIDTH{1'b0}}, app_wdf_wren, app_wdf_end, app_addr};
end
*/



reg								clk_ddr;
reg								init_done;
reg								app_rdy;
reg	   [APP_DATA_WIDTH-1:0]		app_rd_data;
reg								app_rd_data_end;
reg								app_rd_data_valid;
reg								app_wdf_rdy;




reg		[31:0]		time_click;
bit		[APP_DATA_WIDTH-1:0]	ddr_array [0:SIM_DDR_SIZE*8/APP_DATA_WIDTH-1];
bit		[APP_DATA_WIDTH+31:0]	wdf_data_queue [$];
bit		[APP_ADDR_WIDTH+31:0]	app_write_queue [$];
bit		[APP_ADDR_WIDTH+31:0]	app_read_queue [$];

initial
begin
	clk_ddr	= 0;
	time_click = 0;
	fork
		gen_clk ();
		receive_cmd ();
		receive_wdf ();
		read_thread ();
		write_thread ();
		forever #5ns time_click = time_click + 1; 
	join
end

task gen_clk ();
	wait (reset === 1'b1);
	init_done = 0;
	wait (reset === 1'b0);

	#1us;
	app_rd_data_end = 0;
	app_rd_data_valid = 0;
	app_rdy = 0;
	app_wdf_rdy = 0;

	while (1)
	begin
		# 2.5ns clk_ddr = ~clk_ddr;
		init_done = 1;
	end
endtask

task receive_cmd ();
	wait (init_done === 1'b1);
	while (1)
	begin
		@ (posedge clk_ddr);
		# 0.5ns;
		app_rdy = 0;

		if ({$random}%100 > 70)
		begin
			app_rdy = 0;
			continue;
		end
		else
			app_rdy = 1;

		@ (negedge clk_ddr);
		if (app_en & (app_cmd == 3'h0))
		begin
			app_write_queue.push_back({time_click, app_addr});
		end

		if (app_en & (app_cmd == 3'h1))
			app_read_queue.push_back({time_click, app_addr});
	end
endtask


task receive_wdf ();
	wait (init_done === 1'b1);
	while (1)
	begin
		@ (posedge clk_ddr);
		# 0.5ns;
		app_wdf_rdy = 0;

		if ({$random}%100 > 70)
		begin
			app_wdf_rdy = 0;
			continue;
		end
		else
			app_wdf_rdy = 1;

		@ (negedge clk_ddr);
		if (app_wdf_wren && app_wdf_end)
		begin
			wdf_data_queue.push_back({time_click, app_wdf_data});
		end
	end
endtask


task read_thread ();
	bit		[31:0]		current_app_time;
	bit		[APP_ADDR_WIDTH-1:0]	current_app_addr;
	bit		[APP_DATA_WIDTH-1:0]	current_data;

	while (1)
	begin
		@ (negedge clk_ddr);
		app_rd_data_end = 0;
		app_rd_data_valid = 0;

		if (app_read_queue.size() == 0)
			continue;

		{current_app_time, current_app_addr} = app_read_queue [0];

		if ((time_click - current_app_time) < 12)
			continue;

		if ({$random}%100 > 80)
			continue;

		current_data = ddr_array[current_app_addr[APP_ADDR_WIDTH-1:3]];
		app_read_queue.pop_front();

		app_rd_data_end = 1;
		app_rd_data_valid = 1;
		app_rd_data = current_data;
	end
endtask



task write_thread ();
	bit		[31:0]		current_app_time;
	bit		[31:0]		current_data_time;
	bit		[APP_ADDR_WIDTH-1:0]	current_app_addr;
	bit		[APP_DATA_WIDTH-1:0]	current_data;

	while (1)
	begin
		@ (negedge clk_ddr);
		if (wdf_data_queue.size() == 0)
			continue;

		if (app_write_queue.size() == 0)
			continue;

		{current_app_time, current_app_addr} = app_write_queue [0];
		{current_data_time, current_data} = wdf_data_queue [0];

		//if ((current_app_time >= current_data_time) && ((current_app_time - current_data_time) > 3))
		//	$stop;
		//if ((current_data_time >= current_app_time) && ((current_data_time - current_app_time) > 3))
		//	$stop;

		if ((time_click - current_app_time) < 12)
			continue;

		if ({$random}%100 > 50)
			continue;

		ddr_array[current_app_addr[APP_ADDR_WIDTH-1:3]] = current_data;
		app_write_queue.pop_front();
		wdf_data_queue.pop_front();
	end
endtask


endmodule
