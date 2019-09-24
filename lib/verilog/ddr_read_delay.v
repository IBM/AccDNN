module ddr_read_delay
(
    clk,
    rst,

    layer_ddr_read_req_0_i,
    layer_ddr_read_length_0_i,
    layer_ddr_read_addr_0_i,
    layer_ddr_read_ack_0_o,
    layer_ddr_dout_en_0_o,
    layer_ddr_dout_0_o,
    layer_ddr_dout_eop_0_o,

    layer_ddr_read_req_1_i,
    layer_ddr_read_length_1_i,
    layer_ddr_read_addr_1_i,
    layer_ddr_read_ack_1_o,
    layer_ddr_dout_en_1_o,
    layer_ddr_dout_1_o,
    layer_ddr_dout_eop_1_o,

    layer_ddr_read_req_2_i,
    layer_ddr_read_length_2_i,
    layer_ddr_read_addr_2_i,
    layer_ddr_read_ack_2_o,
    layer_ddr_dout_en_2_o,
    layer_ddr_dout_2_o,
    layer_ddr_dout_eop_2_o,

    layer_ddr_read_req_3_i,
    layer_ddr_read_length_3_i,
    layer_ddr_read_addr_3_i,
    layer_ddr_read_ack_3_o,
    layer_ddr_dout_en_3_o,
    layer_ddr_dout_3_o,
    layer_ddr_dout_eop_3_o,

    layer_ddr_read_req_4_i,
    layer_ddr_read_length_4_i,
    layer_ddr_read_addr_4_i,
    layer_ddr_read_ack_4_o,
    layer_ddr_dout_en_4_o,
    layer_ddr_dout_4_o,
    layer_ddr_dout_eop_4_o,

    layer_ddr_read_req_5_i,
    layer_ddr_read_length_5_i,
    layer_ddr_read_addr_5_i,
    layer_ddr_read_ack_5_o,
    layer_ddr_dout_en_5_o,
    layer_ddr_dout_5_o,
    layer_ddr_dout_eop_5_o,

    layer_ddr_read_req_6_i,
    layer_ddr_read_length_6_i,
    layer_ddr_read_addr_6_i,
    layer_ddr_read_ack_6_o,
    layer_ddr_dout_en_6_o,
    layer_ddr_dout_6_o,
    layer_ddr_dout_eop_6_o,

    layer_ddr_read_req_7_i,
    layer_ddr_read_length_7_i,
    layer_ddr_read_addr_7_i,
    layer_ddr_read_ack_7_o,
    layer_ddr_dout_en_7_o,
    layer_ddr_dout_7_o,
    layer_ddr_dout_eop_7_o,

    layer_ddr_read_req_8_i,
    layer_ddr_read_length_8_i,
    layer_ddr_read_addr_8_i,
    layer_ddr_read_ack_8_o,
    layer_ddr_dout_en_8_o,
    layer_ddr_dout_8_o,
    layer_ddr_dout_eop_8_o,

    layer_ddr_read_req_9_i,
    layer_ddr_read_length_9_i,
    layer_ddr_read_addr_9_i,
    layer_ddr_read_ack_9_o,
    layer_ddr_dout_en_9_o,
    layer_ddr_dout_9_o,
    layer_ddr_dout_eop_9_o,

    layer_ddr_read_req_10_i,
    layer_ddr_read_length_10_i,
    layer_ddr_read_addr_10_i,
    layer_ddr_read_ack_10_o,
    layer_ddr_dout_en_10_o,
    layer_ddr_dout_10_o,
    layer_ddr_dout_eop_10_o,

    layer_ddr_read_req_11_i,
    layer_ddr_read_length_11_i,
    layer_ddr_read_addr_11_i,
    layer_ddr_read_ack_11_o,
    layer_ddr_dout_en_11_o,
    layer_ddr_dout_11_o,
    layer_ddr_dout_eop_11_o,

    layer_ddr_read_req_12_i,
    layer_ddr_read_length_12_i,
    layer_ddr_read_addr_12_i,
    layer_ddr_read_ack_12_o,
    layer_ddr_dout_en_12_o,
    layer_ddr_dout_12_o,
    layer_ddr_dout_eop_12_o,

    layer_ddr_read_req_13_i,
    layer_ddr_read_length_13_i,
    layer_ddr_read_addr_13_i,
    layer_ddr_read_ack_13_o,
    layer_ddr_dout_en_13_o,
    layer_ddr_dout_13_o,
    layer_ddr_dout_eop_13_o,

    layer_ddr_read_req_14_i,
    layer_ddr_read_length_14_i,
    layer_ddr_read_addr_14_i,
    layer_ddr_read_ack_14_o,
    layer_ddr_dout_en_14_o,
    layer_ddr_dout_14_o,
    layer_ddr_dout_eop_14_o,


    engine_ddr_read_req_0_o,
    engine_ddr_read_length_0_o,
    engine_ddr_read_addr_0_o,
    engine_ddr_read_ack_0_i,

    engine_ddr_read_req_1_o,
    engine_ddr_read_length_1_o,
    engine_ddr_read_addr_1_o,
    engine_ddr_read_ack_1_i,

    engine_ddr_read_req_2_o,
    engine_ddr_read_length_2_o,
    engine_ddr_read_addr_2_o,
    engine_ddr_read_ack_2_i,

    engine_ddr_read_req_3_o,
    engine_ddr_read_length_3_o,
    engine_ddr_read_addr_3_o,
    engine_ddr_read_ack_3_i,

    engine_ddr_read_req_4_o,
    engine_ddr_read_length_4_o,
    engine_ddr_read_addr_4_o,
    engine_ddr_read_ack_4_i,

    engine_ddr_read_req_5_o,
    engine_ddr_read_length_5_o,
    engine_ddr_read_addr_5_o,
    engine_ddr_read_ack_5_i,

    engine_ddr_read_req_6_o,
    engine_ddr_read_length_6_o,
    engine_ddr_read_addr_6_o,
    engine_ddr_read_ack_6_i,

    engine_ddr_read_req_7_o,
    engine_ddr_read_length_7_o,
    engine_ddr_read_addr_7_o,
    engine_ddr_read_ack_7_i,

    engine_ddr_read_req_8_o,
    engine_ddr_read_length_8_o,
    engine_ddr_read_addr_8_o,
    engine_ddr_read_ack_8_i,

    engine_ddr_read_req_9_o,
    engine_ddr_read_length_9_o,
    engine_ddr_read_addr_9_o,
    engine_ddr_read_ack_9_i,

    engine_ddr_read_req_10_o,
    engine_ddr_read_length_10_o,
    engine_ddr_read_addr_10_o,
    engine_ddr_read_ack_10_i,

    engine_ddr_read_req_11_o,
    engine_ddr_read_length_11_o,
    engine_ddr_read_addr_11_o,
    engine_ddr_read_ack_11_i,

    engine_ddr_read_req_12_o,
    engine_ddr_read_length_12_o,
    engine_ddr_read_addr_12_o,
    engine_ddr_read_ack_12_i,

    engine_ddr_read_req_13_o,
    engine_ddr_read_length_13_o,
    engine_ddr_read_addr_13_o,
    engine_ddr_read_ack_13_i,

    engine_ddr_read_req_14_o,
    engine_ddr_read_length_14_o,
    engine_ddr_read_addr_14_o,
    engine_ddr_read_ack_14_i,

    engine_ddr_dout_en_i,
    engine_ddr_dout_i,
    engine_ddr_dout_eop_i
);

parameter   DDR_DATA_WIDTH      = 512;

parameter	delay_req_port0		= -1;
parameter	delay_req_port1		= -1;
parameter	delay_req_port2		= -1;
parameter	delay_req_port3		= -1;
parameter	delay_req_port4		= -1;
parameter	delay_req_port5		= -1;
parameter	delay_req_port6		= -1;
parameter	delay_req_port7		= -1;
parameter	delay_req_port8		= -1;
parameter	delay_req_port9		= -1;
parameter	delay_req_port10	= -1;
parameter	delay_req_port11	= -1;
parameter	delay_req_port12	= -1;
parameter	delay_req_port13	= -1;
parameter	delay_req_port14	= -1;

parameter	delay_dout_port0	= delay_req_port0;
parameter	delay_dout_port1	= delay_req_port1;
parameter	delay_dout_port2	= delay_req_port2;
parameter	delay_dout_port3	= delay_req_port3;
parameter	delay_dout_port4	= delay_req_port4;
parameter	delay_dout_port5	= delay_req_port5;
parameter	delay_dout_port6	= delay_req_port6;
parameter	delay_dout_port7	= delay_req_port7;
parameter	delay_dout_port8	= delay_req_port8;
parameter	delay_dout_port9	= delay_req_port9;
parameter	delay_dout_port10	= delay_req_port10;
parameter	delay_dout_port11	= delay_req_port11;
parameter	delay_dout_port12	= delay_req_port12;
parameter	delay_dout_port13	= delay_req_port13;
parameter	delay_dout_port14	= delay_req_port14;

input				clk;
input				rst;

input				layer_ddr_read_req_0_i;
input	[26:0]		layer_ddr_read_length_0_i;
input	[26:0]		layer_ddr_read_addr_0_i;
output				layer_ddr_read_ack_0_o;
output				layer_ddr_dout_en_0_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_0_o;
output				layer_ddr_dout_eop_0_o;

input				layer_ddr_read_req_1_i;
input	[26:0]		layer_ddr_read_length_1_i;
input	[26:0]		layer_ddr_read_addr_1_i;
output				layer_ddr_read_ack_1_o;
output				layer_ddr_dout_en_1_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_1_o;
output				layer_ddr_dout_eop_1_o;

input				layer_ddr_read_req_2_i;
input	[26:0]		layer_ddr_read_length_2_i;
input	[26:0]		layer_ddr_read_addr_2_i;
output				layer_ddr_read_ack_2_o;
output				layer_ddr_dout_en_2_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_2_o;
output				layer_ddr_dout_eop_2_o;

input				layer_ddr_read_req_3_i;
input	[26:0]		layer_ddr_read_length_3_i;
input	[26:0]		layer_ddr_read_addr_3_i;
output				layer_ddr_read_ack_3_o;
output				layer_ddr_dout_en_3_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_3_o;
output				layer_ddr_dout_eop_3_o;

input				layer_ddr_read_req_4_i;
input	[26:0]		layer_ddr_read_length_4_i;
input	[26:0]		layer_ddr_read_addr_4_i;
output				layer_ddr_read_ack_4_o;
output				layer_ddr_dout_en_4_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_4_o;
output				layer_ddr_dout_eop_4_o;

input				layer_ddr_read_req_5_i;
input	[26:0]		layer_ddr_read_length_5_i;
input	[26:0]		layer_ddr_read_addr_5_i;
output				layer_ddr_read_ack_5_o;
output				layer_ddr_dout_en_5_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_5_o;
output				layer_ddr_dout_eop_5_o;

input				layer_ddr_read_req_6_i;
input	[26:0]		layer_ddr_read_length_6_i;
input	[26:0]		layer_ddr_read_addr_6_i;
output				layer_ddr_read_ack_6_o;
output				layer_ddr_dout_en_6_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_6_o;
output				layer_ddr_dout_eop_6_o;

input				layer_ddr_read_req_7_i;
input	[26:0]		layer_ddr_read_length_7_i;
input	[26:0]		layer_ddr_read_addr_7_i;
output				layer_ddr_read_ack_7_o;
output				layer_ddr_dout_en_7_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_7_o;
output				layer_ddr_dout_eop_7_o;

input				layer_ddr_read_req_8_i;
input	[26:0]		layer_ddr_read_length_8_i;
input	[26:0]		layer_ddr_read_addr_8_i;
output				layer_ddr_read_ack_8_o;
output				layer_ddr_dout_en_8_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_8_o;
output				layer_ddr_dout_eop_8_o;

input				layer_ddr_read_req_9_i;
input	[26:0]		layer_ddr_read_length_9_i;
input	[26:0]		layer_ddr_read_addr_9_i;
output				layer_ddr_read_ack_9_o;
output				layer_ddr_dout_en_9_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_9_o;
output				layer_ddr_dout_eop_9_o;

input				layer_ddr_read_req_10_i;
input	[26:0]		layer_ddr_read_length_10_i;
input	[26:0]		layer_ddr_read_addr_10_i;
output				layer_ddr_read_ack_10_o;
output				layer_ddr_dout_en_10_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_10_o;
output				layer_ddr_dout_eop_10_o;

input				layer_ddr_read_req_11_i;
input	[26:0]		layer_ddr_read_length_11_i;
input	[26:0]		layer_ddr_read_addr_11_i;
output				layer_ddr_read_ack_11_o;
output				layer_ddr_dout_en_11_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_11_o;
output				layer_ddr_dout_eop_11_o;

input				layer_ddr_read_req_12_i;
input	[26:0]		layer_ddr_read_length_12_i;
input	[26:0]		layer_ddr_read_addr_12_i;
output				layer_ddr_read_ack_12_o;
output				layer_ddr_dout_en_12_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_12_o;
output				layer_ddr_dout_eop_12_o;

input				layer_ddr_read_req_13_i;
input	[26:0]		layer_ddr_read_length_13_i;
input	[26:0]		layer_ddr_read_addr_13_i;
output				layer_ddr_read_ack_13_o;
output				layer_ddr_dout_en_13_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_13_o;
output				layer_ddr_dout_eop_13_o;

input				layer_ddr_read_req_14_i;
input	[26:0]		layer_ddr_read_length_14_i;
input	[26:0]		layer_ddr_read_addr_14_i;
output				layer_ddr_read_ack_14_o;
output				layer_ddr_dout_en_14_o;
output	[DDR_DATA_WIDTH-1:0]		layer_ddr_dout_14_o;
output				layer_ddr_dout_eop_14_o;


output				engine_ddr_read_req_0_o;
output	[26:0]		engine_ddr_read_length_0_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_0_o;
input				engine_ddr_read_ack_0_i;

output				engine_ddr_read_req_1_o;
output	[26:0]		engine_ddr_read_length_1_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_1_o;
input				engine_ddr_read_ack_1_i;

output				engine_ddr_read_req_2_o;
output	[26:0]		engine_ddr_read_length_2_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_2_o;
input				engine_ddr_read_ack_2_i;

output				engine_ddr_read_req_3_o;
output	[26:0]		engine_ddr_read_length_3_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_3_o;
input				engine_ddr_read_ack_3_i;

output				engine_ddr_read_req_4_o;
output	[26:0]		engine_ddr_read_length_4_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_4_o;
input				engine_ddr_read_ack_4_i;

output				engine_ddr_read_req_5_o;
output	[26:0]		engine_ddr_read_length_5_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_5_o;
input				engine_ddr_read_ack_5_i;

output				engine_ddr_read_req_6_o;
output	[26:0]		engine_ddr_read_length_6_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_6_o;
input				engine_ddr_read_ack_6_i;

output				engine_ddr_read_req_7_o;
output	[26:0]		engine_ddr_read_length_7_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_7_o;
input				engine_ddr_read_ack_7_i;

output				engine_ddr_read_req_8_o;
output	[26:0]		engine_ddr_read_length_8_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_8_o;
input				engine_ddr_read_ack_8_i;

output				engine_ddr_read_req_9_o;
output	[26:0]		engine_ddr_read_length_9_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_9_o;
input				engine_ddr_read_ack_9_i;

output				engine_ddr_read_req_10_o;
output	[26:0]		engine_ddr_read_length_10_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_10_o;
input				engine_ddr_read_ack_10_i;

output				engine_ddr_read_req_11_o;
output	[26:0]		engine_ddr_read_length_11_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_11_o;
input				engine_ddr_read_ack_11_i;

output				engine_ddr_read_req_12_o;
output	[26:0]		engine_ddr_read_length_12_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_12_o;
input				engine_ddr_read_ack_12_i;

output				engine_ddr_read_req_13_o;
output	[26:0]		engine_ddr_read_length_13_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_13_o;
input				engine_ddr_read_ack_13_i;

output				engine_ddr_read_req_14_o;
output	[26:0]		engine_ddr_read_length_14_o;
(*mark_debug = "true"*)output	[26:0]		engine_ddr_read_addr_14_o;
input				engine_ddr_read_ack_14_i;

input	[15:0]		engine_ddr_dout_en_i;
input	[DDR_DATA_WIDTH-1:0]		engine_ddr_dout_i;
input				engine_ddr_dout_eop_i;


assign engine_ddr_read_length_0_o		= layer_ddr_read_length_0_i;
assign engine_ddr_read_length_1_o		= layer_ddr_read_length_1_i;
assign engine_ddr_read_length_2_o		= layer_ddr_read_length_2_i;
assign engine_ddr_read_length_3_o		= layer_ddr_read_length_3_i;
assign engine_ddr_read_length_4_o		= layer_ddr_read_length_4_i;
assign engine_ddr_read_length_5_o		= layer_ddr_read_length_5_i;
assign engine_ddr_read_length_6_o		= layer_ddr_read_length_6_i;
assign engine_ddr_read_length_7_o		= layer_ddr_read_length_7_i;
assign engine_ddr_read_length_8_o		= layer_ddr_read_length_8_i;
assign engine_ddr_read_length_9_o		= layer_ddr_read_length_9_i;
assign engine_ddr_read_length_10_o		= layer_ddr_read_length_10_i;
assign engine_ddr_read_length_11_o		= layer_ddr_read_length_11_i;
assign engine_ddr_read_length_12_o		= layer_ddr_read_length_12_i;
assign engine_ddr_read_length_13_o		= layer_ddr_read_length_13_i;
assign engine_ddr_read_length_14_o		= layer_ddr_read_length_14_i;

assign engine_ddr_read_addr_0_o	= layer_ddr_read_addr_0_i;
assign engine_ddr_read_addr_1_o	= layer_ddr_read_addr_1_i;
assign engine_ddr_read_addr_2_o	= layer_ddr_read_addr_2_i;
assign engine_ddr_read_addr_3_o	= layer_ddr_read_addr_3_i;
assign engine_ddr_read_addr_4_o	= layer_ddr_read_addr_4_i;
assign engine_ddr_read_addr_5_o	= layer_ddr_read_addr_5_i;
assign engine_ddr_read_addr_6_o	= layer_ddr_read_addr_6_i;
assign engine_ddr_read_addr_7_o	= layer_ddr_read_addr_7_i;
assign engine_ddr_read_addr_8_o	= layer_ddr_read_addr_8_i;
assign engine_ddr_read_addr_9_o	= layer_ddr_read_addr_9_i;
assign engine_ddr_read_addr_10_o	= layer_ddr_read_addr_10_i;
assign engine_ddr_read_addr_11_o	= layer_ddr_read_addr_11_i;
assign engine_ddr_read_addr_12_o	= layer_ddr_read_addr_12_i;
assign engine_ddr_read_addr_13_o	= layer_ddr_read_addr_13_i;
assign engine_ddr_read_addr_14_o	= layer_ddr_read_addr_14_i;






(*mark_debug = "true"*)reg		[14:0]		ddr_read_ack_d1;
(*mark_debug = "true"*)reg		[15:0]		ddr_dout_en_d1;
(*mark_debug = "true"*)reg		[DDR_DATA_WIDTH-1:0]		ddr_dout_d1;
(*mark_debug = "true"*)reg					ddr_dout_eop_d1;

(*mark_debug = "true"*)reg		[14:0]		ddr_read_ack_d2;
(*mark_debug = "true"*)reg		[15:0]		ddr_dout_en_d2;
(*mark_debug = "true"*)reg		[DDR_DATA_WIDTH-1:0]		ddr_dout_d2;
(*mark_debug = "true"*)reg					ddr_dout_eop_d2;

(*mark_debug = "true"*)reg		[14:0]		ddr_read_req_d1;
(*mark_debug = "true"*)reg		[14:0]		ddr_read_req_d2;

always @ (posedge clk)
begin
	ddr_dout_en_d1	<= engine_ddr_dout_en_i;
	ddr_dout_d1		<= engine_ddr_dout_i;
	ddr_dout_eop_d1	<= engine_ddr_dout_eop_i;

	ddr_dout_en_d2	<= ddr_dout_en_d1;
	ddr_dout_d2		<= ddr_dout_d1;
	ddr_dout_eop_d2	<= ddr_dout_eop_d1;
end



generate
	if (delay_req_port0 < 0) begin
		assign	engine_ddr_read_req_0_o	= 1'h0;
		assign	layer_ddr_read_ack_0_o	= 1'h0;
		assign	layer_ddr_dout_en_0_o	= 1'h0;
		assign	layer_ddr_dout_0_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_0_o	= 1'h0;
	end
	else if (delay_req_port0 == 0) begin
		assign	engine_ddr_read_req_0_o	= layer_ddr_read_req_0_i;
		assign	layer_ddr_read_ack_0_o	= engine_ddr_read_ack_0_i;
		assign	layer_ddr_dout_en_0_o	= engine_ddr_dout_en_i [0];
		assign	layer_ddr_dout_0_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_0_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [0];
	end
	else if (delay_req_port0 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [0]	<= layer_ddr_read_req_0_i;
			ddr_read_ack_d1 [0]	<= engine_ddr_read_ack_0_i;
		end
		assign	engine_ddr_read_req_0_o	= ddr_read_req_d1 [0];
		assign	layer_ddr_read_ack_0_o	= ddr_read_ack_d1 [0];
		assign	layer_ddr_dout_en_0_o	= ddr_dout_en_d1 [0];
		assign	layer_ddr_dout_0_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_0_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [0];
	end
	else if (delay_req_port0 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [0]	<= layer_ddr_read_req_0_i;
			ddr_read_req_d1 [0]	<= ddr_read_req_d2 [0];

			ddr_read_ack_d1 [0]	<= engine_ddr_read_ack_0_i;
			ddr_read_ack_d2 [0]	<= ddr_read_ack_d1 [0];
		end
		assign	engine_ddr_read_req_0_o	= ddr_read_req_d1 [0];
		assign	layer_ddr_read_ack_0_o	= ddr_read_ack_d2 [0];
		assign	layer_ddr_dout_en_0_o	= ddr_dout_en_d2 [0];
		assign	layer_ddr_dout_0_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_0_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [0];
	end
endgenerate


generate
	if (delay_req_port1 < 0) begin
		assign	engine_ddr_read_req_1_o	= 1'h0;
		assign	layer_ddr_read_ack_1_o	= 1'h0;
		assign	layer_ddr_dout_en_1_o	= 1'h0;
		assign	layer_ddr_dout_1_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_1_o	= 1'h0;
	end
	else if (delay_req_port1 == 0) begin
		assign	engine_ddr_read_req_1_o	= layer_ddr_read_req_1_i;
		assign	layer_ddr_read_ack_1_o	= engine_ddr_read_ack_1_i;
		assign	layer_ddr_dout_en_1_o	= engine_ddr_dout_en_i [1];
		assign	layer_ddr_dout_1_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_1_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [1];
	end
	else if (delay_req_port1 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [1]	<= layer_ddr_read_req_1_i;
			ddr_read_ack_d1 [1]	<= engine_ddr_read_ack_1_i;
		end
		assign	engine_ddr_read_req_1_o	= ddr_read_req_d1 [1];
		assign	layer_ddr_read_ack_1_o	= ddr_read_ack_d1 [1];
		assign	layer_ddr_dout_en_1_o	= ddr_dout_en_d1 [1];
		assign	layer_ddr_dout_1_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_1_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [1];
	end
	else if (delay_req_port1 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [1]	<= layer_ddr_read_req_1_i;
			ddr_read_req_d1 [1]	<= ddr_read_req_d2 [1];

			ddr_read_ack_d1 [1]	<= engine_ddr_read_ack_1_i;
			ddr_read_ack_d2 [1]	<= ddr_read_ack_d1 [1];
		end
		assign	engine_ddr_read_req_1_o	= ddr_read_req_d1 [1];
		assign	layer_ddr_read_ack_1_o	= ddr_read_ack_d2 [1];
		assign	layer_ddr_dout_en_1_o	= ddr_dout_en_d2 [1];
		assign	layer_ddr_dout_1_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_1_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [1];
	end
endgenerate


generate
	if (delay_req_port2 < 0) begin
		assign	engine_ddr_read_req_2_o	= 1'h0;
		assign	layer_ddr_read_ack_2_o	= 1'h0;
		assign	layer_ddr_dout_en_2_o	= 1'h0;
		assign	layer_ddr_dout_2_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_2_o	= 1'h0;
	end
	else if (delay_req_port2 == 0) begin
		assign	engine_ddr_read_req_2_o	= layer_ddr_read_req_2_i;
		assign	layer_ddr_read_ack_2_o	= engine_ddr_read_ack_2_i;
		assign	layer_ddr_dout_en_2_o	= engine_ddr_dout_en_i [2];
		assign	layer_ddr_dout_2_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_2_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [2];
	end
	else if (delay_req_port2 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [2]	<= layer_ddr_read_req_2_i;
			ddr_read_ack_d1 [2]	<= engine_ddr_read_ack_2_i;
		end
		assign	engine_ddr_read_req_2_o	= ddr_read_req_d1 [2];
		assign	layer_ddr_read_ack_2_o	= ddr_read_ack_d1 [2];
		assign	layer_ddr_dout_en_2_o	= ddr_dout_en_d1 [2];
		assign	layer_ddr_dout_2_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_2_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [2];
	end
	else if (delay_req_port2 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [2]	<= layer_ddr_read_req_2_i;
			ddr_read_req_d1 [2]	<= ddr_read_req_d2 [2];

			ddr_read_ack_d1 [2]	<= engine_ddr_read_ack_2_i;
			ddr_read_ack_d2 [2]	<= ddr_read_ack_d1 [2];
		end
		assign	engine_ddr_read_req_2_o	= ddr_read_req_d1 [2];
		assign	layer_ddr_read_ack_2_o	= ddr_read_ack_d2 [2];
		assign	layer_ddr_dout_en_2_o	= ddr_dout_en_d2 [2];
		assign	layer_ddr_dout_2_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_2_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [2];
	end
endgenerate


generate
	if (delay_req_port3 < 0) begin
		assign	engine_ddr_read_req_3_o	= 1'h0;
		assign	layer_ddr_read_ack_3_o	= 1'h0;
		assign	layer_ddr_dout_en_3_o	= 1'h0;
		assign	layer_ddr_dout_3_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_3_o	= 1'h0;
	end
	else if (delay_req_port3 == 0) begin
		assign	engine_ddr_read_req_3_o	= layer_ddr_read_req_3_i;
		assign	layer_ddr_read_ack_3_o	= engine_ddr_read_ack_3_i;
		assign	layer_ddr_dout_en_3_o	= engine_ddr_dout_en_i [3];
		assign	layer_ddr_dout_3_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_3_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [3];
	end
	else if (delay_req_port3 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [3]	<= layer_ddr_read_req_3_i;
			ddr_read_ack_d1 [3]	<= engine_ddr_read_ack_3_i;
		end
		assign	engine_ddr_read_req_3_o	= ddr_read_req_d1 [3];
		assign	layer_ddr_read_ack_3_o	= ddr_read_ack_d1 [3];
		assign	layer_ddr_dout_en_3_o	= ddr_dout_en_d1 [3];
		assign	layer_ddr_dout_3_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_3_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [3];
	end
	else if (delay_req_port3 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [3]	<= layer_ddr_read_req_3_i;
			ddr_read_req_d1 [3]	<= ddr_read_req_d2 [3];

			ddr_read_ack_d1 [3]	<= engine_ddr_read_ack_3_i;
			ddr_read_ack_d2 [3]	<= ddr_read_ack_d1 [3];
		end
		assign	engine_ddr_read_req_3_o	= ddr_read_req_d1 [3];
		assign	layer_ddr_read_ack_3_o	= ddr_read_ack_d2 [3];
		assign	layer_ddr_dout_en_3_o	= ddr_dout_en_d2 [3];
		assign	layer_ddr_dout_3_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_3_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [3];
	end
endgenerate


generate
	if (delay_req_port4 < 0) begin
		assign	engine_ddr_read_req_4_o	= 1'h0;
		assign	layer_ddr_read_ack_4_o	= 1'h0;
		assign	layer_ddr_dout_en_4_o	= 1'h0;
		assign	layer_ddr_dout_4_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_4_o	= 1'h0;
	end
	else if (delay_req_port4 == 0) begin
		assign	engine_ddr_read_req_4_o	= layer_ddr_read_req_4_i;
		assign	layer_ddr_read_ack_4_o	= engine_ddr_read_ack_4_i;
		assign	layer_ddr_dout_en_4_o	= engine_ddr_dout_en_i [4];
		assign	layer_ddr_dout_4_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_4_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [4];
	end
	else if (delay_req_port4 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [4]	<= layer_ddr_read_req_4_i;
			ddr_read_ack_d1 [4]	<= engine_ddr_read_ack_4_i;
		end
		assign	engine_ddr_read_req_4_o	= ddr_read_req_d1 [4];
		assign	layer_ddr_read_ack_4_o	= ddr_read_ack_d1 [4];
		assign	layer_ddr_dout_en_4_o	= ddr_dout_en_d1 [4];
		assign	layer_ddr_dout_4_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_4_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [4];
	end
	else if (delay_req_port4 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [4]	<= layer_ddr_read_req_4_i;
			ddr_read_req_d1 [4]	<= ddr_read_req_d2 [4];

			ddr_read_ack_d1 [4]	<= engine_ddr_read_ack_4_i;
			ddr_read_ack_d2 [4]	<= ddr_read_ack_d1 [4];
		end
		assign	engine_ddr_read_req_4_o	= ddr_read_req_d1 [4];
		assign	layer_ddr_read_ack_4_o	= ddr_read_ack_d2 [4];
		assign	layer_ddr_dout_en_4_o	= ddr_dout_en_d2 [4];
		assign	layer_ddr_dout_4_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_4_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [4];
	end
endgenerate


generate
	if (delay_req_port5 < 0) begin
		assign	engine_ddr_read_req_5_o	= 1'h0;
		assign	layer_ddr_read_ack_5_o	= 1'h0;
		assign	layer_ddr_dout_en_5_o	= 1'h0;
		assign	layer_ddr_dout_5_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_5_o	= 1'h0;
	end
	else if (delay_req_port5 == 0) begin
		assign	engine_ddr_read_req_5_o	= layer_ddr_read_req_5_i;
		assign	layer_ddr_read_ack_5_o	= engine_ddr_read_ack_5_i;
		assign	layer_ddr_dout_en_5_o	= engine_ddr_dout_en_i [5];
		assign	layer_ddr_dout_5_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_5_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [5];
	end
	else if (delay_req_port5 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [5]	<= layer_ddr_read_req_5_i;
			ddr_read_ack_d1 [5]	<= engine_ddr_read_ack_5_i;
		end
		assign	engine_ddr_read_req_5_o	= ddr_read_req_d1 [5];
		assign	layer_ddr_read_ack_5_o	= ddr_read_ack_d1 [5];
		assign	layer_ddr_dout_en_5_o	= ddr_dout_en_d1 [5];
		assign	layer_ddr_dout_5_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_5_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [5];
	end
	else if (delay_req_port5 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [5]	<= layer_ddr_read_req_5_i;
			ddr_read_req_d1 [5]	<= ddr_read_req_d2 [5];

			ddr_read_ack_d1 [5]	<= engine_ddr_read_ack_5_i;
			ddr_read_ack_d2 [5]	<= ddr_read_ack_d1 [5];
		end
		assign	engine_ddr_read_req_5_o	= ddr_read_req_d1 [5];
		assign	layer_ddr_read_ack_5_o	= ddr_read_ack_d2 [5];
		assign	layer_ddr_dout_en_5_o	= ddr_dout_en_d2 [5];
		assign	layer_ddr_dout_5_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_5_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [5];
	end
endgenerate


generate
	if (delay_req_port6 < 0) begin
		assign	engine_ddr_read_req_6_o	= 1'h0;
		assign	layer_ddr_read_ack_6_o	= 1'h0;
		assign	layer_ddr_dout_en_6_o	= 1'h0;
		assign	layer_ddr_dout_6_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_6_o	= 1'h0;
	end
	else if (delay_req_port6 == 0) begin
		assign	engine_ddr_read_req_6_o	= layer_ddr_read_req_6_i;
		assign	layer_ddr_read_ack_6_o	= engine_ddr_read_ack_6_i;
		assign	layer_ddr_dout_en_6_o	= engine_ddr_dout_en_i [6];
		assign	layer_ddr_dout_6_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_6_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [6];
	end
	else if (delay_req_port6 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [6]	<= layer_ddr_read_req_6_i;
			ddr_read_ack_d1 [6]	<= engine_ddr_read_ack_6_i;
		end
		assign	engine_ddr_read_req_6_o	= ddr_read_req_d1 [6];
		assign	layer_ddr_read_ack_6_o	= ddr_read_ack_d1 [6];
		assign	layer_ddr_dout_en_6_o	= ddr_dout_en_d1 [6];
		assign	layer_ddr_dout_6_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_6_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [6];
	end
	else if (delay_req_port6 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [6]	<= layer_ddr_read_req_6_i;
			ddr_read_req_d1 [6]	<= ddr_read_req_d2 [6];

			ddr_read_ack_d1 [6]	<= engine_ddr_read_ack_6_i;
			ddr_read_ack_d2 [6]	<= ddr_read_ack_d1 [6];
		end
		assign	engine_ddr_read_req_6_o	= ddr_read_req_d1 [6];
		assign	layer_ddr_read_ack_6_o	= ddr_read_ack_d2 [6];
		assign	layer_ddr_dout_en_6_o	= ddr_dout_en_d2 [6];
		assign	layer_ddr_dout_6_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_6_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [6];
	end
endgenerate


generate
	if (delay_req_port7 < 0) begin
		assign	engine_ddr_read_req_7_o	= 1'h0;
		assign	layer_ddr_read_ack_7_o	= 1'h0;
		assign	layer_ddr_dout_en_7_o	= 1'h0;
		assign	layer_ddr_dout_7_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_7_o	= 1'h0;
	end
	else if (delay_req_port7 == 0) begin
		assign	engine_ddr_read_req_7_o	= layer_ddr_read_req_7_i;
		assign	layer_ddr_read_ack_7_o	= engine_ddr_read_ack_7_i;
		assign	layer_ddr_dout_en_7_o	= engine_ddr_dout_en_i [7];
		assign	layer_ddr_dout_7_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_7_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [7];
	end
	else if (delay_req_port7 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [7]	<= layer_ddr_read_req_7_i;
			ddr_read_ack_d1 [7]	<= engine_ddr_read_ack_7_i;
		end
		assign	engine_ddr_read_req_7_o	= ddr_read_req_d1 [7];
		assign	layer_ddr_read_ack_7_o	= ddr_read_ack_d1 [7];
		assign	layer_ddr_dout_en_7_o	= ddr_dout_en_d1 [7];
		assign	layer_ddr_dout_7_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_7_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [7];
	end
	else if (delay_req_port7 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [7]	<= layer_ddr_read_req_7_i;
			ddr_read_req_d1 [7]	<= ddr_read_req_d2 [7];

			ddr_read_ack_d1 [7]	<= engine_ddr_read_ack_7_i;
			ddr_read_ack_d2 [7]	<= ddr_read_ack_d1 [7];
		end
		assign	engine_ddr_read_req_7_o	= ddr_read_req_d1 [7];
		assign	layer_ddr_read_ack_7_o	= ddr_read_ack_d2 [7];
		assign	layer_ddr_dout_en_7_o	= ddr_dout_en_d2 [7];
		assign	layer_ddr_dout_7_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_7_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [7];
	end
endgenerate


generate
	if (delay_req_port8 < 0) begin
		assign	engine_ddr_read_req_8_o	= 1'h0;
		assign	layer_ddr_read_ack_8_o	= 1'h0;
		assign	layer_ddr_dout_en_8_o	= 1'h0;
		assign	layer_ddr_dout_8_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_8_o	= 1'h0;
	end
	else if (delay_req_port8 == 0) begin
		assign	engine_ddr_read_req_8_o	= layer_ddr_read_req_8_i;
		assign	layer_ddr_read_ack_8_o	= engine_ddr_read_ack_8_i;
		assign	layer_ddr_dout_en_8_o	= engine_ddr_dout_en_i [8];
		assign	layer_ddr_dout_8_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_8_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [8];
	end
	else if (delay_req_port8 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [8]	<= layer_ddr_read_req_8_i;
			ddr_read_ack_d1 [8]	<= engine_ddr_read_ack_8_i;
		end
		assign	engine_ddr_read_req_8_o	= ddr_read_req_d1 [8];
		assign	layer_ddr_read_ack_8_o	= ddr_read_ack_d1 [8];
		assign	layer_ddr_dout_en_8_o	= ddr_dout_en_d1 [8];
		assign	layer_ddr_dout_8_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_8_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [8];
	end
	else if (delay_req_port8 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [8]	<= layer_ddr_read_req_8_i;
			ddr_read_req_d1 [8]	<= ddr_read_req_d2 [8];

			ddr_read_ack_d1 [8]	<= engine_ddr_read_ack_8_i;
			ddr_read_ack_d2 [8]	<= ddr_read_ack_d1 [8];
		end
		assign	engine_ddr_read_req_8_o	= ddr_read_req_d1 [8];
		assign	layer_ddr_read_ack_8_o	= ddr_read_ack_d2 [8];
		assign	layer_ddr_dout_en_8_o	= ddr_dout_en_d2 [8];
		assign	layer_ddr_dout_8_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_8_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [8];
	end
endgenerate


generate
	if (delay_req_port9 < 0) begin
		assign	engine_ddr_read_req_9_o	= 1'h0;
		assign	layer_ddr_read_ack_9_o	= 1'h0;
		assign	layer_ddr_dout_en_9_o	= 1'h0;
		assign	layer_ddr_dout_9_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_9_o	= 1'h0;
	end
	else if (delay_req_port9 == 0) begin
		assign	engine_ddr_read_req_9_o	= layer_ddr_read_req_9_i;
		assign	layer_ddr_read_ack_9_o	= engine_ddr_read_ack_9_i;
		assign	layer_ddr_dout_en_9_o	= engine_ddr_dout_en_i [9];
		assign	layer_ddr_dout_9_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_9_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [9];
	end
	else if (delay_req_port9 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [9]	<= layer_ddr_read_req_9_i;
			ddr_read_ack_d1 [9]	<= engine_ddr_read_ack_9_i;
		end
		assign	engine_ddr_read_req_9_o	= ddr_read_req_d1 [9];
		assign	layer_ddr_read_ack_9_o	= ddr_read_ack_d1 [9];
		assign	layer_ddr_dout_en_9_o	= ddr_dout_en_d1 [9];
		assign	layer_ddr_dout_9_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_9_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [9];
	end
	else if (delay_req_port9 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [9]	<= layer_ddr_read_req_9_i;
			ddr_read_req_d1 [9]	<= ddr_read_req_d2 [9];

			ddr_read_ack_d1 [9]	<= engine_ddr_read_ack_9_i;
			ddr_read_ack_d2 [9]	<= ddr_read_ack_d1 [9];
		end
		assign	engine_ddr_read_req_9_o	= ddr_read_req_d1 [9];
		assign	layer_ddr_read_ack_9_o	= ddr_read_ack_d2 [9];
		assign	layer_ddr_dout_en_9_o	= ddr_dout_en_d2 [9];
		assign	layer_ddr_dout_9_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_9_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [9];
	end
endgenerate


generate
	if (delay_req_port10 < 0) begin
		assign	engine_ddr_read_req_10_o	= 1'h0;
		assign	layer_ddr_read_ack_10_o	= 1'h0;
		assign	layer_ddr_dout_en_10_o	= 1'h0;
		assign	layer_ddr_dout_10_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_10_o	= 1'h0;
	end
	else if (delay_req_port10 == 0) begin
		assign	engine_ddr_read_req_10_o	= layer_ddr_read_req_10_i;
		assign	layer_ddr_read_ack_10_o	= engine_ddr_read_ack_10_i;
		assign	layer_ddr_dout_en_10_o	= engine_ddr_dout_en_i [10];
		assign	layer_ddr_dout_10_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_10_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [10];
	end
	else if (delay_req_port10 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [10]	<= layer_ddr_read_req_10_i;
			ddr_read_ack_d1 [10]	<= engine_ddr_read_ack_10_i;
		end
		assign	engine_ddr_read_req_10_o	= ddr_read_req_d1 [10];
		assign	layer_ddr_read_ack_10_o	= ddr_read_ack_d1 [10];
		assign	layer_ddr_dout_en_10_o	= ddr_dout_en_d1 [10];
		assign	layer_ddr_dout_10_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_10_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [10];
	end
	else if (delay_req_port10 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [10]	<= layer_ddr_read_req_10_i;
			ddr_read_req_d1 [10]	<= ddr_read_req_d2 [10];

			ddr_read_ack_d1 [10]	<= engine_ddr_read_ack_10_i;
			ddr_read_ack_d2 [10]	<= ddr_read_ack_d1 [10];
		end
		assign	engine_ddr_read_req_10_o	= ddr_read_req_d1 [10];
		assign	layer_ddr_read_ack_10_o	= ddr_read_ack_d2 [10];
		assign	layer_ddr_dout_en_10_o	= ddr_dout_en_d2 [10];
		assign	layer_ddr_dout_10_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_10_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [10];
	end
endgenerate


generate
	if (delay_req_port11 < 0) begin
		assign	engine_ddr_read_req_11_o	= 1'h0;
		assign	layer_ddr_read_ack_11_o	= 1'h0;
		assign	layer_ddr_dout_en_11_o	= 1'h0;
		assign	layer_ddr_dout_11_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_11_o	= 1'h0;
	end
	else if (delay_req_port11 == 0) begin
		assign	engine_ddr_read_req_11_o	= layer_ddr_read_req_11_i;
		assign	layer_ddr_read_ack_11_o	= engine_ddr_read_ack_11_i;
		assign	layer_ddr_dout_en_11_o	= engine_ddr_dout_en_i [11];
		assign	layer_ddr_dout_11_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_11_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [11];
	end
	else if (delay_req_port11 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [11]	<= layer_ddr_read_req_11_i;
			ddr_read_ack_d1 [11]	<= engine_ddr_read_ack_11_i;
		end
		assign	engine_ddr_read_req_11_o	= ddr_read_req_d1 [11];
		assign	layer_ddr_read_ack_11_o	= ddr_read_ack_d1 [11];
		assign	layer_ddr_dout_en_11_o	= ddr_dout_en_d1 [11];
		assign	layer_ddr_dout_11_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_11_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [11];
	end
	else if (delay_req_port11 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [11]	<= layer_ddr_read_req_11_i;
			ddr_read_req_d1 [11]	<= ddr_read_req_d2 [11];

			ddr_read_ack_d1 [11]	<= engine_ddr_read_ack_11_i;
			ddr_read_ack_d2 [11]	<= ddr_read_ack_d1 [11];
		end
		assign	engine_ddr_read_req_11_o	= ddr_read_req_d1 [11];
		assign	layer_ddr_read_ack_11_o	= ddr_read_ack_d2 [11];
		assign	layer_ddr_dout_en_11_o	= ddr_dout_en_d2 [11];
		assign	layer_ddr_dout_11_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_11_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [11];
	end
endgenerate


generate
	if (delay_req_port12 < 0) begin
		assign	engine_ddr_read_req_12_o	= 1'h0;
		assign	layer_ddr_read_ack_12_o	= 1'h0;
		assign	layer_ddr_dout_en_12_o	= 1'h0;
		assign	layer_ddr_dout_12_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_12_o	= 1'h0;
	end
	else if (delay_req_port12 == 0) begin
		assign	engine_ddr_read_req_12_o	= layer_ddr_read_req_12_i;
		assign	layer_ddr_read_ack_12_o	= engine_ddr_read_ack_12_i;
		assign	layer_ddr_dout_en_12_o	= engine_ddr_dout_en_i [12];
		assign	layer_ddr_dout_12_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_12_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [12];
	end
	else if (delay_req_port12 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [12]	<= layer_ddr_read_req_12_i;
			ddr_read_ack_d1 [12]	<= engine_ddr_read_ack_12_i;
		end
		assign	engine_ddr_read_req_12_o	= ddr_read_req_d1 [12];
		assign	layer_ddr_read_ack_12_o	= ddr_read_ack_d1 [12];
		assign	layer_ddr_dout_en_12_o	= ddr_dout_en_d1 [12];
		assign	layer_ddr_dout_12_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_12_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [12];
	end
	else if (delay_req_port12 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [12]	<= layer_ddr_read_req_12_i;
			ddr_read_req_d1 [12]	<= ddr_read_req_d2 [12];

			ddr_read_ack_d1 [12]	<= engine_ddr_read_ack_12_i;
			ddr_read_ack_d2 [12]	<= ddr_read_ack_d1 [12];
		end
		assign	engine_ddr_read_req_12_o	= ddr_read_req_d1 [12];
		assign	layer_ddr_read_ack_12_o	= ddr_read_ack_d2 [12];
		assign	layer_ddr_dout_en_12_o	= ddr_dout_en_d2 [12];
		assign	layer_ddr_dout_12_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_12_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [12];
	end
endgenerate


generate
	if (delay_req_port13 < 0) begin
		assign	engine_ddr_read_req_13_o	= 1'h0;
		assign	layer_ddr_read_ack_13_o	= 1'h0;
		assign	layer_ddr_dout_en_13_o	= 1'h0;
		assign	layer_ddr_dout_13_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_13_o	= 1'h0;
	end
	else if (delay_req_port13 == 0) begin
		assign	engine_ddr_read_req_13_o	= layer_ddr_read_req_13_i;
		assign	layer_ddr_read_ack_13_o	= engine_ddr_read_ack_13_i;
		assign	layer_ddr_dout_en_13_o	= engine_ddr_dout_en_i [13];
		assign	layer_ddr_dout_13_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_13_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [13];
	end
	else if (delay_req_port13 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [13]	<= layer_ddr_read_req_13_i;
			ddr_read_ack_d1 [13]	<= engine_ddr_read_ack_13_i;
		end
		assign	engine_ddr_read_req_13_o	= ddr_read_req_d1 [13];
		assign	layer_ddr_read_ack_13_o	= ddr_read_ack_d1 [13];
		assign	layer_ddr_dout_en_13_o	= ddr_dout_en_d1 [13];
		assign	layer_ddr_dout_13_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_13_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [13];
	end
	else if (delay_req_port13 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [13]	<= layer_ddr_read_req_13_i;
			ddr_read_req_d1 [13]	<= ddr_read_req_d2 [13];

			ddr_read_ack_d1 [13]	<= engine_ddr_read_ack_13_i;
			ddr_read_ack_d2 [13]	<= ddr_read_ack_d1 [13];
		end
		assign	engine_ddr_read_req_13_o	= ddr_read_req_d1 [13];
		assign	layer_ddr_read_ack_13_o	= ddr_read_ack_d2 [13];
		assign	layer_ddr_dout_en_13_o	= ddr_dout_en_d2 [13];
		assign	layer_ddr_dout_13_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_13_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [13];
	end
endgenerate


generate
	if (delay_req_port14 < 0) begin
		assign	engine_ddr_read_req_14_o	= 1'h0;
		assign	layer_ddr_read_ack_14_o	= 1'h0;
		assign	layer_ddr_dout_en_14_o	= 1'h0;
		assign	layer_ddr_dout_14_o		= {DDR_DATA_WIDTH{1'b0}};
		assign	layer_ddr_dout_eop_14_o	= 1'h0;
	end
	else if (delay_req_port14 == 0) begin
		assign	engine_ddr_read_req_14_o	= layer_ddr_read_req_14_i;
		assign	layer_ddr_read_ack_14_o	= engine_ddr_read_ack_14_i;
		assign	layer_ddr_dout_en_14_o	= engine_ddr_dout_en_i [14];
		assign	layer_ddr_dout_14_o		= engine_ddr_dout_i;
		assign	layer_ddr_dout_eop_14_o	= engine_ddr_dout_eop_i & engine_ddr_dout_en_i [14];
	end
	else if (delay_req_port14 == 1) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d1 [14]	<= layer_ddr_read_req_14_i;
			ddr_read_ack_d1 [14]	<= engine_ddr_read_ack_14_i;
		end
		assign	engine_ddr_read_req_14_o	= ddr_read_req_d1 [14];
		assign	layer_ddr_read_ack_14_o	= ddr_read_ack_d1 [14];
		assign	layer_ddr_dout_en_14_o	= ddr_dout_en_d1 [14];
		assign	layer_ddr_dout_14_o		= ddr_dout_d1;
		assign	layer_ddr_dout_eop_14_o	= ddr_dout_eop_d1 & ddr_dout_en_d1 [14];
	end
	else if (delay_req_port14 == 2) begin
		always @ (posedge clk)
		begin
			ddr_read_req_d2 [14]	<= layer_ddr_read_req_14_i;
			ddr_read_req_d1 [14]	<= ddr_read_req_d2 [14];

			ddr_read_ack_d1 [14]	<= engine_ddr_read_ack_14_i;
			ddr_read_ack_d2 [14]	<= ddr_read_ack_d1 [14];
		end
		assign	engine_ddr_read_req_14_o	= ddr_read_req_d1 [14];
		assign	layer_ddr_read_ack_14_o	= ddr_read_ack_d2 [14];
		assign	layer_ddr_dout_en_14_o	= ddr_dout_en_d2 [14];
		assign	layer_ddr_dout_14_o		= ddr_dout_d2;
		assign	layer_ddr_dout_eop_14_o	= ddr_dout_eop_d2 & ddr_dout_en_d2 [14];
	end
endgenerate

// Following constaints must be dynamically added to the xdc file after the
// delay of each port is determined.

// for i in range (0,15) :
//	if delay_req_portXXX >= 0 :
//		print "set_multicycle_path -from [get_nets {a0/afu0/acc_module/u_module/u_ddr_read_delay/engine_ddr_read_addr_%s_o[*]}] -setup %d" % (i, 2+delay_req_portXXX)
//		print "set_multicycle_path -from [get_nets {a0/afu0/acc_module/u_module/u_ddr_read_delay/engine_ddr_read_addr_%s_o[*]}] -hold 1" % i
//		print ""


endmodule
