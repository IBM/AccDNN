module multiplier(
	clk,
	d_i,
	w_i,
	m_o
	);
parameter C_WIDTH = 2; // data channel, set to 2 when using 8 bit 
parameter D_WIDTH = 8;
parameter W_WIDTH = 16;
parameter M_WIDTH = 32;
/* W_WIDTH should be 1/2/8/16 */
input clk;
input [D_WIDTH-1:0] d_i;
input [W_WIDTH-1:0] w_i;
output wire [M_WIDTH-1:0] m_o;

reg  [M_WIDTH-1:0] m_o_reg;
wire  [M_WIDTH-1:0] m_o_tmp;

wire [23:0] w_i_tmp;

assign w_i_tmp = {{w_i[15:8] + {8{w_i[7]}}},{8{w_i[7]}}, w_i[7:0]};

generate 
case (W_WIDTH/C_WIDTH)
	1: 	always @(posedge clk)
		begin
			m_o_reg <= w_i[0]?(~d_i[D_WIDTH-1:0]+1):D_WIDTH[D_WIDTH-1:0];
		end
	2:  always @ (posedge clk)
        begin
			m_o_reg <= w_i[1]?(~d_i[D_WIDTH-1:0]+1):(w_i[0]?d_i[D_WIDTH-1:0]:{D_WIDTH{1'b0}});
        end
	8:  if (D_WIDTH == 8) begin
			mul24x8_signed u_mul24x8_signed (
			.CLK(clk),
			.A(w_i_tmp),
			.B(d_i[7:0]),
			.P(m_o_tmp) // output
			);
			assign m_o[15:0] = m_o_tmp[15:0];
			assign m_o[31:16] = m_o_tmp[31:16]-{16{m_o_tmp[15]}};
			end
		else 
			mul16x16_signed u_mul16x16_signed (
			.CLK(clk),
			.A(w_i[15:0]),
			.B(d_i[15:0]),
			.P(m_o) // output
			);
	default: mul16x16_signed u_mul16x16_signed (
			.CLK(clk),
			.A(w_i[15:0]),
			.B(d_i[15:0]),
			.P(m_o) // output
			);
endcase
    if (W_WIDTH < 3) begin: gen_mo
        assign m_o = m_o_reg;
    end
endgenerate

endmodule


