module acc_addr(
	clk,
	rst,
    mul,
	op_din_eop_d2,
	op_din_en_d1,
	a_o
	);
parameter CPF = 4;
parameter ACC_WIDTH = 40;
parameter M_DW = 32; // 16 for 8bit

localparam A1_WIDTH = (CPF == 1)? M_DW:
                     ((CPF <= 3)? M_DW+1:
					 ((CPF == 4)? M_DW+2:
					 ((CPF == 8)? M_DW+3:
					 ((CPF == 16)?M_DW+4:
					 ((CPF == 32)?M_DW+5:M_DW+6)))));

input clk;
input rst;
input op_din_eop_d2;
input op_din_en_d1;
input wire [M_DW-1:0] mul[CPF-1:0];
output [ACC_WIDTH-1:0] a_o;

wire [A1_WIDTH-1:0] a1;

genvar gv_i;
generate

    wire [M_DW+1:0] a1_i[CPF/4-1:0];
    wire [M_DW+3:0] b1_i[CPF/16-1:0];
    
	// Adder tree layer 1
	case (CPF)
	1: begin: cpf_1_adder1
		assign a1 = mul[0];
	   end
	2: begin: cpf_2_adder1
		addr2 #(.IN_WIDTH(M_DW)) u_addr2(.clk(clk), .rst(rst), .d0_i(mul[0]), .d1_i(mul[1]), .d_o(a1));
	   end
	3: begin: cpf_3_adder1
		addr3 #(.IN_WIDTH(M_DW)) u_addr3(.clk(clk), .rst(rst), .d0_i(mul[0]), .d1_i(mul[1]), .d2_i(mul[2]), .d_o(a1));
	   end
	default: begin: cpf_other_adder1
			for ( gv_i = 0; gv_i < CPF; gv_i = gv_i + 4 ) begin: gen_addtree_layer1
				addr4 #(.IN_WIDTH(M_DW)) u_addr4(.clk(clk), .rst(rst), .d0_i(mul[gv_i]), .d1_i(mul[gv_i+1]), .d2_i(mul[gv_i+2]),
						.d3_i(mul[gv_i+3]), .d_o(a1_i[gv_i/4]));
			end
			end
	endcase
	// Adder tree layer 2
	if (CPF == 4) begin:cpf_4_adder2
		assign a1 = a1_i[0];
	end
	else if (CPF == 8) begin:cpf_8_adder2
		addr2 #(.IN_WIDTH(M_DW+2)) u1_addr2(.clk(clk), .rst(rst), .d0_i(a1_i[0]), .d1_i(a1_i[1]), .d_o(a1));
	end
	else if (CPF == 16) begin:cpf_16_adder2
		addr4 #(.IN_WIDTH(M_DW+2)) u1_addr4(.clk(clk), .rst(rst), .d0_i(a1_i[0]), .d1_i(a1_i[1]), .d2_i(a1_i[2]),
					.d3_i(a1_i[3]), .d_o(a1));
	end
	else if (CPF > 16) begin: cpf_3264_adder2
		
		for ( gv_i = 0; gv_i < CPF/4; gv_i = gv_i + 4 ) begin: gen_addtree_layer2
		addr4 #(.IN_WIDTH(M_DW+2)) u1_addr4(.clk(clk), .rst(rst), .d0_i(a1_i[gv_i]), .d1_i(a1_i[gv_i+1]), .d2_i(a1_i[gv_i+2]),
					.d3_i(a1_i[gv_i+3]), .d_o(b1_i[gv_i/4]));
		end
	end
	
	// Adder tree layer 3
	if (CPF == 32) begin: cpf_32_adder3
		addr2 #(.IN_WIDTH(M_DW+4)) u1_addr2(.clk(clk), .rst(rst), .d0_i(b1_i[0]), .d1_i(b1_i[1]), .d_o(a1));
	end
	else if (CPF == 64) begin: cpf_64_adder3
		addr4 #(.IN_WIDTH(M_DW+4)) u1_addr4(.clk(clk), .rst(rst), .d0_i(b1_i[0]), .d1_i(b1_i[1]), .d2_i(b1_i[2]),
					.d3_i(b1_i[3]), .d_o(a1));
	end
endgenerate

    //========================================
    //accumulation with signal
    //========================================
    reg [ACC_WIDTH-1:0] a2_tmp_reg;
    always @ (posedge clk)
    begin
      if(rst)
        a2_tmp_reg <= {ACC_WIDTH{1'b0}};
      else if ((op_din_eop_d2 == 1) && (op_din_en_d1 == 1))
        a2_tmp_reg <= {{(ACC_WIDTH-A1_WIDTH){a1[A1_WIDTH-1]}}, a1};
      else if ((op_din_eop_d2 == 1) && (op_din_en_d1 == 0))
        a2_tmp_reg <= {ACC_WIDTH{1'b0}};
      else if ((op_din_eop_d2 == 0) && (op_din_en_d1 == 1))
        a2_tmp_reg <= a2_tmp_reg + {{(ACC_WIDTH-A1_WIDTH){a1[A1_WIDTH-1]}}, a1};
      else  
        a2_tmp_reg <= a2_tmp_reg;
    end
	
	assign a_o = a2_tmp_reg;

endmodule





