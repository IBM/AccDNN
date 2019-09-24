module fraction_table (clk, rst, index, fraction);
input clk;
input rst;
input [5:0] index;
output reg[15:0] fraction;

always @ (posedge clk)
begin 
  if (rst)
    fraction <= 16'hFFFF;
  else
    begin
      case (index)
        6'd0:  fraction <= 16'd8192;
        6'd1:  fraction <= 16'd4096;
        6'd2:  fraction <= 16'd2730;
        6'd3:  fraction <= 16'd2048;
        6'd4:  fraction <= 16'd1638;
        6'd5:  fraction <= 16'd1365;
        6'd6:  fraction <= 16'd1170;
        6'd7:  fraction <= 16'd1024;
        6'd8:  fraction <= 16'd910;
        6'd9:  fraction <= 16'd819;
        6'd10:  fraction <= 16'd744;
        6'd11:  fraction <= 16'd682;
        6'd12:  fraction <= 16'd630;
        6'd13:  fraction <= 16'd585;
        6'd14:  fraction <= 16'd546;
        6'd15:  fraction <= 16'd512;
        6'd16:  fraction <= 16'd481;
        6'd17:  fraction <= 16'd455;
        6'd18:  fraction <= 16'd431;
        6'd19:  fraction <= 16'd409;
        6'd20:  fraction <= 16'd390;
        6'd21:  fraction <= 16'd372;
        6'd22:  fraction <= 16'd356;
        6'd23:  fraction <= 16'd341;
        6'd24:  fraction <= 16'd327;
        6'd25:  fraction <= 16'd315;
        6'd26:  fraction <= 16'd303;
        6'd27:  fraction <= 16'd292;
        6'd28:  fraction <= 16'd282;
        6'd29:  fraction <= 16'd273;
        6'd30:  fraction <= 16'd264;
        6'd31:  fraction <= 16'd256;
        6'd32:  fraction <= 16'd248;
        6'd33:  fraction <= 16'd240;
        6'd34:  fraction <= 16'd234;
        6'd35:  fraction <= 16'd227;
        6'd36:  fraction <= 16'd221;
        6'd37:  fraction <= 16'd215;
        6'd38:  fraction <= 16'd210;
        6'd39:  fraction <= 16'd204;
        6'd40:  fraction <= 16'd199;
        6'd41:  fraction <= 16'd195;
        6'd42:  fraction <= 16'd190;
        6'd43:  fraction <= 16'd186;
        6'd44:  fraction <= 16'd182;
        6'd45:  fraction <= 16'd178;
        6'd46:  fraction <= 16'd174;
        6'd47:  fraction <= 16'd170;
        6'd48:  fraction <= 16'd167;
        6'd49:  fraction <= 16'd163;
        6'd50:  fraction <= 16'd160;
        6'd51:  fraction <= 16'd157;
        6'd52:  fraction <= 16'd154;
        6'd53:  fraction <= 16'd151;
        6'd54:  fraction <= 16'd148;
        6'd55:  fraction <= 16'd146;
        6'd56:  fraction <= 16'd143;
        6'd57:  fraction <= 16'd141;
        6'd58:  fraction <= 16'd138;
        6'd59:  fraction <= 16'd136;
        6'd60:  fraction <= 16'd134;
        6'd61:  fraction <= 16'd132;
        6'd62:  fraction <= 16'd130;
        6'd63:  fraction <= 16'd128;
      endcase
    end
  end
endmodule
