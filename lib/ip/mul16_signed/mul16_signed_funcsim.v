// Copyright 1986-1999, 2001-2013 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2013.4 (lin64) Build 353583 Mon Dec  9 17:26:26 MST 2013
// Date        : Tue Jan 12 17:54:19 2016
// Host        : wangjs-desktop running 64-bit Ubuntu 14.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/uchen/workspace/ipcores-13/ipcores-13.srcs/sources_1/ip/mul16_signed/mul16_signed_funcsim.v
// Design      : mul16_signed
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx690tffg1157-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0,Vivado 2013.4" *) (* CHECK_LICENSE_TYPE = "mul16_signed,mult_gen_v12_0,{}" *) 
(* core_generation_info = "mul16_signed,mult_gen_v12_0,{x_ipProduct=Vivado 2013.4,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=mult_gen,x_ipVersion=12.0,x_ipCoreRevision=3,x_ipLanguage=VERILOG,C_VERBOSITY=0,C_MODEL_TYPE=0,C_OPTIMIZE_GOAL=1,C_XDEVICEFAMILY=virtex7,C_HAS_CE=0,C_HAS_SCLR=0,C_LATENCY=1,C_A_WIDTH=16,C_A_TYPE=0,C_B_WIDTH=16,C_B_TYPE=0,C_OUT_HIGH=31,C_OUT_LOW=0,C_MULT_TYPE=1,C_CE_OVERRIDES_SCLR=0,C_CCM_IMP=0,C_B_VALUE=10000001,C_HAS_ZERO_DETECT=0,C_ROUND_OUTPUT=0,C_ROUND_PT=0}" *) 
(* NotValidForBitStream *)
module mul16_signed
   (CLK,
    A,
    B,
    P);
  input CLK;
  input [15:0]A;
  input [15:0]B;
  output [31:0]P;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]A;
  wire [15:0]B;
  wire CLK;
  wire [31:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

GND GND
       (.G(\<const0> ));
(* C_A_TYPE = "0" *) 
   (* C_A_WIDTH = "16" *) 
   (* C_B_TYPE = "0" *) 
   (* C_B_VALUE = "10000001" *) 
   (* C_B_WIDTH = "16" *) 
   (* C_CCM_IMP = "0" *) 
   (* C_CE_OVERRIDES_SCLR = "0" *) 
   (* C_HAS_CE = "0" *) 
   (* C_HAS_SCLR = "0" *) 
   (* C_HAS_ZERO_DETECT = "0" *) 
   (* C_LATENCY = "1" *) 
   (* C_MODEL_TYPE = "0" *) 
   (* C_MULT_TYPE = "1" *) 
   (* C_OPTIMIZE_GOAL = "1" *) 
   (* C_OUT_HIGH = "31" *) 
   (* C_OUT_LOW = "0" *) 
   (* C_ROUND_OUTPUT = "0" *) 
   (* C_ROUND_PT = "0" *) 
   (* C_VERBOSITY = "0" *) 
   (* C_XDEVICEFAMILY = "virtex7" *) 
   (* DONT_TOUCH *) 
   (* downgradeipidentifiedwarnings = "yes" *) 
   mul16_signedmult_gen_v12_0__parameterized0 U0
       (.A(A),
        .B(B),
        .CE(\<const1> ),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(\<const0> ),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
VCC VCC
       (.P(\<const1> ));
endmodule

(* ORIG_REF_NAME = "mult_gen_v12_0" *) (* C_VERBOSITY = "0" *) (* C_MODEL_TYPE = "0" *) 
(* C_OPTIMIZE_GOAL = "1" *) (* C_XDEVICEFAMILY = "virtex7" *) (* C_HAS_CE = "0" *) 
(* C_HAS_SCLR = "0" *) (* C_LATENCY = "1" *) (* C_A_WIDTH = "16" *) 
(* C_A_TYPE = "0" *) (* C_B_WIDTH = "16" *) (* C_B_TYPE = "0" *) 
(* C_OUT_HIGH = "31" *) (* C_OUT_LOW = "0" *) (* C_MULT_TYPE = "1" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_CCM_IMP = "0" *) (* C_B_VALUE = "10000001" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mul16_signedmult_gen_v12_0__parameterized0
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [15:0]A;
  input [15:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [31:0]P;
  output [47:0]PCASC;

  wire [15:0]A;
  wire [15:0]B;
  wire CE;
  wire CLK;
  wire [31:0]P;
  wire [47:0]PCASC;
  wire SCLR;
  wire [1:0]ZERO_DETECT;

(* C_A_TYPE = "0" *) 
   (* C_A_WIDTH = "16" *) 
   (* C_B_TYPE = "0" *) 
   (* C_B_VALUE = "10000001" *) 
   (* C_B_WIDTH = "16" *) 
   (* C_CCM_IMP = "0" *) 
   (* C_CE_OVERRIDES_SCLR = "0" *) 
   (* C_HAS_CE = "0" *) 
   (* C_HAS_SCLR = "0" *) 
   (* C_HAS_ZERO_DETECT = "0" *) 
   (* C_LATENCY = "1" *) 
   (* C_MODEL_TYPE = "0" *) 
   (* C_MULT_TYPE = "1" *) 
   (* C_OPTIMIZE_GOAL = "1" *) 
   (* C_OUT_HIGH = "31" *) 
   (* C_OUT_LOW = "0" *) 
   (* C_ROUND_OUTPUT = "0" *) 
   (* C_ROUND_PT = "0" *) 
   (* C_VERBOSITY = "0" *) 
   (* C_XDEVICEFAMILY = "virtex7" *) 
   (* downgradeipidentifiedwarnings = "yes" *) 
   mul16_signedmult_gen_v12_0_viv__parameterized0 i_mult
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(PCASC),
        .SCLR(SCLR),
        .ZERO_DETECT(ZERO_DETECT));
endmodule

(* ORIG_REF_NAME = "mult_gen_v12_0_viv" *) (* C_VERBOSITY = "0" *) (* C_MODEL_TYPE = "0" *) 
(* C_OPTIMIZE_GOAL = "1" *) (* C_XDEVICEFAMILY = "virtex7" *) (* C_HAS_CE = "0" *) 
(* C_HAS_SCLR = "0" *) (* C_LATENCY = "1" *) (* C_A_WIDTH = "16" *) 
(* C_A_TYPE = "0" *) (* C_B_WIDTH = "16" *) (* C_B_TYPE = "0" *) 
(* C_OUT_HIGH = "31" *) (* C_OUT_LOW = "0" *) (* C_MULT_TYPE = "1" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_CCM_IMP = "0" *) (* C_B_VALUE = "10000001" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mul16_signedmult_gen_v12_0_viv__parameterized0
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [15:0]A;
  input [15:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [31:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]A;
  wire [15:0]B;
  wire CLK;
  wire GND_2;
  wire [31:0]P;
  wire VCC_2;
  wire [33:0]\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i ;
  wire \NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_CARRYCASCOUT_UNCONNECTED ;
  wire \NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_MULTSIGNOUT_UNCONNECTED ;
  wire \NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_OVERFLOW_UNCONNECTED ;
  wire \NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_PATTERNBDETECT_UNCONNECTED ;
  wire \NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_PATTERNDETECT_UNCONNECTED ;
  wire \NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_UNDERFLOW_UNCONNECTED ;
  wire [29:0]\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_ACOUT_UNCONNECTED ;
  wire [17:0]\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_BCOUT_UNCONNECTED ;
  wire [3:0]\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_CARRYOUT_UNCONNECTED ;
  wire [47:34]\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_P_UNCONNECTED ;
  wire [47:0]\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_PCOUT_UNCONNECTED ;

  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
GND GND
       (.G(\<const0> ));
GND GND_1
       (.G(GND_2));
VCC VCC
       (.P(\<const1> ));
VCC VCC_1
       (.P(VCC_2));
DSP48E1 #(
    .ACASCREG(0),
    .ADREG(0),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(1),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(1),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
     \gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg 
       (.A({A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A[15],A}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ACOUT(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_ACOUT_UNCONNECTED [29:0]),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({B[15],B[15],B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .BCOUT(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_BCOUT_UNCONNECTED [17:0]),
        .C({VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2,VCC_2}),
        .CARRYCASCIN(\<const0> ),
        .CARRYCASCOUT(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_CARRYCASCOUT_UNCONNECTED ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CARRYOUT(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_CARRYOUT_UNCONNECTED [3:0]),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const1> ),
        .CLK(CLK),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .MULTSIGNOUT(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_MULTSIGNOUT_UNCONNECTED ),
        .OPMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .OVERFLOW(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_OVERFLOW_UNCONNECTED ),
        .P({\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_P_UNCONNECTED [47:34],\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i }),
        .PATTERNBDETECT(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_PATTERNBDETECT_UNCONNECTED ),
        .PATTERNDETECT(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_PATTERNDETECT_UNCONNECTED ),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .PCOUT(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_PCOUT_UNCONNECTED [47:0]),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ),
        .UNDERFLOW(\NLW_gDSP.gDSP_only.iDSP/inferred_dsp.reg_mult.m_reg_reg_UNDERFLOW_UNCONNECTED ));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_0 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [31]),
        .O(P[31]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_1 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [30]),
        .O(P[30]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_10 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [21]),
        .O(P[21]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_11 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [20]),
        .O(P[20]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_12 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [19]),
        .O(P[19]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_13 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [18]),
        .O(P[18]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_14 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [17]),
        .O(P[17]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_15 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [16]),
        .O(P[16]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_16 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [15]),
        .O(P[15]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_17 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [14]),
        .O(P[14]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_18 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [13]),
        .O(P[13]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_19 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [12]),
        .O(P[12]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_2 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [29]),
        .O(P[29]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_20 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [11]),
        .O(P[11]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_21 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [10]),
        .O(P[10]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_22 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [9]),
        .O(P[9]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_23 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [8]),
        .O(P[8]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_24 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [7]),
        .O(P[7]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_25 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [6]),
        .O(P[6]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_26 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [5]),
        .O(P[5]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_27 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [4]),
        .O(P[4]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_28 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [3]),
        .O(P[3]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_29 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [2]),
        .O(P[2]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_3 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [28]),
        .O(P[28]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_30 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [1]),
        .O(P[1]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_31 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [0]),
        .O(P[0]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_4 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [27]),
        .O(P[27]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_5 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [26]),
        .O(P[26]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_6 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [25]),
        .O(P[25]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_7 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [24]),
        .O(P[24]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_8 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [23]),
        .O(P[23]));
LUT1 #(
    .INIT(2'h2)) 
     \inferred_dsp.Pdelayi_9 
       (.I0(\gDSP.gDSP_only.iDSP/inferred_dsp.Pdelay/dout_i [22]),
        .O(P[22]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
