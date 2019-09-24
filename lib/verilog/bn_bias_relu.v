module bn_bias_relu(
  clk,
  rst,
  acc_in,
  op_bias,
  op_dout
);

//========================================
//parameter define                        
//========================================
parameter RELU = 0;
parameter Q = 8;
parameter DIN_Q = 6;
parameter DOUT_DW = 16;
parameter DOUT_Q = 6;
parameter ACC_WIDTH = 40;
parameter BIAS_DW = 16;
parameter BN = 0;
parameter BN_SCALE_Q = 13;
parameter BN_BIAS_Q = 13;
parameter MID_Q = 13;

//========================================
//input/output  declare
//========================================
input clk;
input rst;
input [ACC_WIDTH-1: 0] acc_in;
input [BIAS_DW-1:0] op_bias;
output reg[DOUT_DW-1:0] op_dout;

//========================================
// BN or bias
//========================================
wire [DOUT_DW-1:0] op_dout_tmp;
generate
  //Without BN, use bias
  if (BN == 0) begin: gen_block_without_bn
    reg [ACC_WIDTH-1:0] op_acc;
    always @ (posedge clk)
    begin
      if(rst)
        op_acc <= {ACC_WIDTH{1'b0}};
      else
        op_acc <= acc_in + ({{(ACC_WIDTH-BIAS_DW){op_bias[BIAS_DW-1]}}, op_bias} << DIN_Q);  //bias with bw=BIAS_DW, Q=Q
    //acc_in with bw=ACC_WIDTH, Q=DIN_Q+Q(from weight)
    //op_acc with bw=ACC_WIDTH, Q=DIN_Q+Q
    end
    bit_trunc #(
      .ROUND(1),
      .WIDTH(ACC_WIDTH),
      .MSB(Q+DIN_Q-DOUT_Q+DOUT_DW-1),
      .LSB(Q+DIN_Q-DOUT_Q)
    )
    u0_bit_trunc(
      .din(op_acc),
      .dout(op_dout_tmp)
    );
  end
  // With BN enable
  else begin: gen_block_with_bn
    wire[15:0] acc_mid; //with Q=MID_Q
    //assign acc_mid = acc_in[Q+DIN_Q-MID_Q+15: Q+DIN_Q-MID_Q];
    bit_trunc #(
      .ROUND(0),
      .WIDTH(ACC_WIDTH),
      .MSB(Q+DIN_Q-MID_Q+15),
      .LSB(Q+DIN_Q-MID_Q)
    )
    u1_bit_trunc(
      .din(acc_in),
      .dout(acc_mid)
    );
    wire[15:0] bn_scale = op_bias[15:0];//with Q=BN_SCALE_Q
    reg[15:0] bn_bias_d1;
    always @ (posedge clk)
    begin
        bn_bias_d1 <= op_bias[31:16];
    end
    wire[31:0] acc_scaled;
    mul16_signed u_mul16_signed_bn (
      .CLK(clk),
      .A(acc_mid),
      .B(bn_scale),
      .P(acc_scaled) //with 32bit, Q=MID_Q+BN_SCALE_Q
    );
    reg[31:0] batch_out;
    always @(posedge clk)
    begin
      if (rst)
        batch_out <= 32'b0;
      else
        batch_out <= acc_scaled + ({{16{bn_bias_d1[15]}}, bn_bias_d1} << (MID_Q+BN_SCALE_Q-BN_BIAS_Q));
    end    
    bit_trunc #(
    //  .WIDTH(ACC_WIDTH),
      .ROUND(1),
      .WIDTH(32),
      .MSB(MID_Q+BN_SCALE_Q-DOUT_Q+DOUT_DW-1),
      .LSB(MID_Q+BN_SCALE_Q-DOUT_Q)
    )
    u2_bit_trunc(
      .din(batch_out),
      .dout(op_dout_tmp)
    );
  end
endgenerate

//========================================
//non-linearization deal
//========================================
always @(posedge clk)
begin
  if (rst)
    op_dout <= {DOUT_DW{1'b0}};
  else 
    op_dout <= RELU ? (op_dout_tmp[DOUT_DW-1] ? 0 : op_dout_tmp) : op_dout_tmp;
end
endmodule
