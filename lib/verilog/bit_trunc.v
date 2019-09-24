module bit_trunc(
          din,
          dout
    );

//========================================
//parameter define                        
//========================================
	 parameter WIDTH = 16;
	 parameter MSB   = 15;
	 parameter LSB   = 0;
     parameter ROUND = 0;
                          
//========================================
//input/output  declare
//========================================
   input      [WIDTH -1:0]    din ;
   output reg [MSB : LSB]     dout;


//========================================
//code begin here
//========================================	 
	 
wire [WIDTH -1:0] din_tmp;	 
generate
  if (ROUND == 1 && LSB > 0) begin: round
    assign din_tmp = din[LSB-1] == 1'b1 ? din + {{(WIDTH-LSB-1){din[WIDTH-1]}},1'b1,{(LSB){1'b0}}} : din;
  end
  else begin
    assign din_tmp = din;
  end
endgenerate

always@( * )
  begin
    if(din_tmp[WIDTH-1] == 1'b0 && ((|din_tmp[WIDTH-1 : MSB])) == 1'b1) //overflow	 
      dout <= {1'b0, {(MSB - LSB){1'b1}}};
    else if(din_tmp[WIDTH-1] == 1'b1 && ((&din_tmp[WIDTH-1 : MSB])) == 1'b0) //underflow  
      dout <= {1'b1, {(MSB - LSB){1'b0}}};
    else //without flow
      dout <= din_tmp[MSB : LSB];
  end

endmodule
