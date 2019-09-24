module ddr3_dma_mux
(
  clk,
  rst,

  write_req,
  write_app_cmd,
  write_app_addr,
  write_app_en,

  read_req,
  read_app_cmd,
  read_app_addr,
  read_app_en, 

  app_cmd,
  app_addr,
  app_en
);

input               clk;
input               rst;

input               write_req;
input   [2:0]       write_app_cmd;
input   [29:0]      write_app_addr;
input               write_app_en;

input               read_req;
input   [2:0]       read_app_cmd;
input   [29:0]      read_app_addr;
input               read_app_en;

output  [2:0]       app_cmd;
output  [29:0]      app_addr;
output              app_en;


//  DDR read and write will not happen simultaneously
(*mark_debug = "true"*)reg                 sel;

always @ (posedge clk)
begin
  if(rst)
    sel <= 1'b1;
  else if (read_req)
    sel <= 1'b1;
  else if (write_req)
    sel <= 1'b0;
end

assign app_cmd  = sel ? read_app_cmd : write_app_cmd;
assign app_addr = sel ? read_app_addr : write_app_addr;
assign app_en   = sel ? read_app_en : write_app_en;




endmodule

