module vector_muladd(
        clk,
        rst,
        op_din_en,
        op_din_eop,
        op_din,
        op_weight,
        op_bias,
        op_dout
    );

//========================================
//parameter define                        
//========================================
parameter CPF = 4;
parameter RELU = 0;
parameter Q = 8;
parameter DIN_Q = 6;
parameter DOUT_Q = 6;
parameter ACC_WIDTH = 40;
parameter BIAS_DW = 16;
parameter BN = 0;
parameter BN_SCALE_Q = 13;
parameter BN_BIAS_Q = 13;
parameter MID_Q = 13;
parameter DIN_DW = 16;
parameter DOUT_DW = 8; //bit-width of output 
parameter WW = 16; 	   //bit-width of weight

parameter MAT_DW = 32;
parameter DELTA_DELAY = 0;

parameter DATA_CHANNEL = 1; // when using 8bit, set to 2

//========================================
//input/output  declare
//========================================
input clk;
input rst;
input op_din_en;
input op_din_eop;
input [DIN_DW*CPF-1:0] op_din;
input [WW*DATA_CHANNEL*CPF-1:0] op_weight;
input [BIAS_DW*DATA_CHANNEL-1:0] op_bias;
output [DOUT_DW*DATA_CHANNEL-1:0] op_dout;		  	

wire [MAT_DW-1:0] mul[CPF-1:0];

//========================================
// Multiplier for 1bit/2bit/8bit/16bit
//========================================
genvar gv_i;
generate
	for ( gv_i = 0; gv_i < CPF; gv_i = gv_i +1 ) begin: gen_multiplier
		multiplier #(.C_WIDTH(DATA_CHANNEL),.D_WIDTH(DIN_DW),.W_WIDTH(WW*DATA_CHANNEL),.M_WIDTH(MAT_DW)) u_mult(
			.clk(clk),
			.d_i(op_din[DIN_DW*(gv_i+1)-1:DIN_DW*gv_i]),
			.w_i(op_weight[WW*DATA_CHANNEL*(gv_i+1)-1:WW*DATA_CHANNEL*gv_i]),
			.m_o(mul[gv_i])
		);
	end
endgenerate

//reg the bais in the end.
reg [BIAS_DW*DATA_CHANNEL-1:0] op_bias_d1;
always @ (posedge clk)
begin
  if(rst)
    op_bias_d1 <= {(BIAS_DW*DATA_CHANNEL){1'b0}};
  else if (op_din_eop)
    op_bias_d1 <= op_bias;
  else
    op_bias_d1 <= op_bias_d1;
end

//========================================
//delay op_din_en N clock
//========================================
wire op_din_en_d1;
delay #((CPF <2)?1:((CPF < 8)?2:((CPF < 32)?3:4)))u_delay_1(
  .clk(clk),
  .rst(rst),
  .in(op_din_en),
  .out(op_din_en_d1)
);

//========================================
//delay op_din_eop N+1 clock
//========================================
wire op_din_eop_d2;
delay #((CPF <2)?2:((CPF < 8)?3:((CPF < 32)?4:5)))u_delay_2(
  .clk(clk),
  .rst(rst),
  .in(op_din_eop),
  .out(op_din_eop_d2)
);

wire [ACC_WIDTH-1:0] a2_tmp;
wire [BIAS_DW-1:0] bias_tmp;

//========================================
// accumulator
//========================================
generate
	if (DIN_DW == 8 && WW == 8) begin: gen_adder_8b
		wire [MAT_DW/2-1:0] mul0[CPF-1:0];
		wire [MAT_DW/2-1:0] mul1[CPF-1:0];
		wire [ACC_WIDTH-1:0] a2_tmp_0;
		wire [ACC_WIDTH-1:0] a2_tmp_1;
		
		for ( gv_i = 0; gv_i < CPF; gv_i = gv_i +1 ) begin: gen_mul_8
			assign mul0[gv_i] = mul[gv_i][MAT_DW/2-1:0];
			assign mul1[gv_i] = mul[gv_i][MAT_DW-1:MAT_DW/2];
		end
			acc_addr #(.CPF(CPF),.M_DW(MAT_DW/2),.ACC_WIDTH(ACC_WIDTH)) u_acc_addr0(
				.clk(clk),
				.rst(rst), 
				.mul(mul0),
				.op_din_eop_d2(op_din_eop_d2),
				.op_din_en_d1(op_din_en_d1),
				.a_o(a2_tmp_0));
			acc_addr #(.CPF(CPF),.M_DW(MAT_DW/2),.ACC_WIDTH(ACC_WIDTH)) u_acc_addr1(
				.clk(clk),
				.rst(rst), 
				.mul(mul1),
				.op_din_eop_d2(op_din_eop_d2),
				.op_din_en_d1(op_din_en_d1),
				.a_o(a2_tmp_1));
		//reg the last accumulated data for multiplexing
		reg[2*ACC_WIDTH-1:0] a2_tmp_reg;
		always @ (posedge clk)
		begin
		if(rst)
			a2_tmp_reg <= {(2*ACC_WIDTH){1'b0}};
		else if (op_din_eop_d2 == 1'b1)
			a2_tmp_reg <= {a2_tmp_1, a2_tmp_0};
		end
		
		reg a2_tmp_sel;
		always @ (posedge clk)
		begin
		if(rst)
			a2_tmp_sel <= 1'b0;
		else if (op_din_eop_d2 == 1'b1)
			a2_tmp_sel <= 1'b0;
		else
			a2_tmp_sel <= ~a2_tmp_sel;
		end
	    assign a2_tmp = a2_tmp_sel ? a2_tmp_reg[2*ACC_WIDTH-1:ACC_WIDTH] : a2_tmp_reg[ACC_WIDTH-1:0];
		assign bias_tmp = a2_tmp_sel ? op_bias_d1[2*BIAS_DW-1:BIAS_DW] : op_bias_d1[BIAS_DW-1:0];
	end
	else begin: gen_adder_16b // 16 bit
		acc_addr #(.CPF(CPF),.M_DW(MAT_DW),.ACC_WIDTH(ACC_WIDTH)) u_acc_addr0(
			.clk(clk),
			.rst(rst), 
			.mul(mul),
			.op_din_eop_d2(op_din_eop_d2),
			.op_din_en_d1(op_din_en_d1),
			.a_o(a2_tmp));
		assign bias_tmp = op_bias_d1;
	end
endgenerate	
 
wire [DOUT_DW-1:0] op_dout_tmp;
bn_bias_relu #(
  .RELU(RELU),
  .Q(Q),
  .DIN_Q(DIN_Q),
  .DOUT_DW(DOUT_DW),
  .DOUT_Q(DOUT_Q),
  .ACC_WIDTH(ACC_WIDTH),
  .BIAS_DW(BIAS_DW),
  .BN(BN),
  .BN_SCALE_Q(BN_SCALE_Q),
  .BN_BIAS_Q(BN_BIAS_Q),
  .MID_Q(MID_Q)
) u_bn_bias_relu (
  .clk(clk),
  .rst(rst),
  .acc_in(a2_tmp),
  .op_bias(bias_tmp),
  .op_dout(op_dout_tmp)
);

generate
  if (DIN_DW == 8 && WW == 8) begin: gen_out_8bits
    reg [DOUT_DW-1:0] op_dout_reg;
    always @ (posedge clk)
    begin
      if(rst)
        op_dout_reg <= {(DOUT_DW){1'b0}};
      else
        op_dout_reg <= op_dout_tmp;
    end
    assign op_dout = {op_dout_tmp, op_dout_reg};
  end
  else begin:gen_out
    assign op_dout = op_dout_tmp;
  end
endgenerate

endmodule
