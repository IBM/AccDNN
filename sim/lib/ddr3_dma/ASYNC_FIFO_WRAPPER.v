/* ============================================================
*
* Copyright (c) 2008
* National Research Center for Intelligent Computing Systems
* Key Laboratory of Computer System and Architecture,
* Institute of Computing Technology, Chinese Academy of Sciences
*
* All rights reserved.
*
* THIS MATERIAL IS PROVIDED BY THE INSTITUTE OF COMPUTING TECHNOLOGY,
* CHINESE ACADEMY OF SCIENCES AND ANY COPYRIGHT
* HOLDERS AND CONTRIBUTORS "AS IS" IN ITS CURRENT CONDITION AND WITHOUT ANY
* REPRESENTATIONS, GUARANTEE, OR WARRANTY OF ANY KIND OR IN ANY WAY RELATED
* TO SUPPORT, INDEMNITY, ERROR FREE OR UNINTERRUPTED OPERATION, OR THAT IT
* IS FREE FROM DEFECTS OR VIRUSES.
* 
* National Research Center for Intelligent Computing Systems
* Key Laboratory of Computer System and Architecture,
* Institute of Computing Technology, Chinese Academy of Sciences
*
* kexueyuan south road
* 100080 Beijing
* China
* http://www.ncic.ac.cn
* http://www.ict.ac.cn
*
*
* Author(s):    chenfei
*				chenfei@ncic.ac.cn
*
* Create Date:  3.01.2008
* 
* Description:  show-ahead	asynchronous fifo
* ===========================================================*/

//	show-ahead	asynchronous fifo

`timescale 1ns/100ps

module	ASYNC_FIFO_WRAPPER
(
	asyn_reset_i,

	w_clk_i,
	w_en_i,
	w_din_i,

	r_clk_i,
	r_en_i,
	r_dout_o,

	w_full_o,
	r_empty_o
);

parameter aw = 3, dw = 8;

input				asyn_reset_i;
input				w_clk_i;
input				w_en_i;
input	[dw-1:0]	w_din_i;

input				r_clk_i;
input				r_en_i;
output	[dw-1:0]	r_dout_o;

output				w_full_o;
output				r_empty_o;




//----------------------------------------------------------------------------//
//--------------------------    control logic    -----------------------------//
//----------------------------------------------------------------------------//




reg		[aw-1:0]	w_addr;						// write address
reg		[aw-1:0]	w_addr_next;				// write address + 1
reg		[aw-1:0]	w_addr_grey;				// grey code of write address
wire	[aw-1:0]	w_addr_next_grey;			// grey code of write address + 1
reg					full_reg;					// RAM is full
wire				w_allow;					// write RAM permission

reg		[aw-1:0]	wsyn1_rgrey;				// read grey address asyn to w_clk the first time
reg		[aw-1:0]	wsyn2_rgrey;				// read grey address asyn to w_clk the second time



reg		[aw-1:0]	r_addr;						// read address
reg		[aw-1:0]	r_addr_next;				// read address + 1
reg		[aw-1:0]	r_addr_grey;				// grey code of read address
wire	[aw-1:0]	r_addr_next_grey;			// grey code of read address + 1
reg					empty_reg;					// RAM is empty
wire				r_allow;					// read RAM permission
wire	[aw-1:0]	read_ram_addr;

reg		[aw-1:0]	rsyn1_wgrey;				// write grey address asyn to w_clk the first time
reg		[aw-1:0]	rsyn2_wgrey;				// write grey address asyn to w_clk the second time


assign	r_allow = r_en_i & (~empty_reg);
assign	w_allow	= w_en_i & (~full_reg); 

//----------------------------------------------------------------------------//
//--------------------------    Write processing    --------------------------//
//----------------------------------------------------------------------------//

always	@ (posedge w_clk_i or posedge asyn_reset_i)
begin
	if (asyn_reset_i)
	begin
		w_addr		<= 0;
		w_addr_next	<= 1;
		w_addr_grey	<= 0;
	end
	else if (w_allow)
	begin
		w_addr		<= w_addr_next;
		w_addr_next	<= w_addr_next + 1;
		w_addr_grey	<= w_addr_next_grey;
	end
end

assign	w_addr_next_grey	= (w_addr_next >> 1) ^ w_addr_next;


always	@ (negedge w_clk_i or posedge asyn_reset_i)			// asyn read address to w_clk region the first time
begin
	if (asyn_reset_i)
		wsyn1_rgrey	<= 0;
	else
		wsyn1_rgrey	<= r_addr_grey;
end


always	@ (posedge w_clk_i or posedge asyn_reset_i)			// asyn read address to w_clk region the second time
begin
	if (asyn_reset_i)
	begin
		full_reg		<= 0;
		wsyn2_rgrey		<= 0;
	end
	else
	begin
		if (w_allow & (w_addr_next_grey == wsyn2_rgrey))
			full_reg	<= 1;
		else if (w_addr_grey != wsyn2_rgrey)
			full_reg	<= 0;
		
		wsyn2_rgrey			<= wsyn1_rgrey;
	end
end


assign	w_full_o		= full_reg;





//----------------------------------------------------------------------------//
//--------------------------    Read processing    ---------------------------//
//----------------------------------------------------------------------------//

always	@ (posedge r_clk_i or posedge asyn_reset_i)
begin
	if (asyn_reset_i)
	begin
		r_addr		<= 0;
		r_addr_next	<= 1;
		r_addr_grey	<= 0;
	end
	else if (r_allow)
	begin
		r_addr		<= r_addr_next;
		r_addr_next	<= r_addr_next + 1;
		r_addr_grey	<= r_addr_next_grey;
	end
end

assign	r_addr_next_grey = (r_addr_next >> 1) ^ r_addr_next;


always	@ (negedge r_clk_i or posedge asyn_reset_i)			// asyn write address to r_clk region the first time
begin
	if (asyn_reset_i)
		rsyn1_wgrey	<= 0;
	else
		rsyn1_wgrey	<= w_addr_grey;
end


always	@ (posedge r_clk_i or posedge asyn_reset_i)			// asyn read address to w_clk region the second time
begin
	if (asyn_reset_i)
	begin
		empty_reg		<= 1;
		rsyn2_wgrey		<= 0;
	end
	else
	begin
		if (r_allow & (r_addr_next_grey == rsyn2_wgrey))
			empty_reg	<= 1;
		else if (r_addr_grey != rsyn2_wgrey)
			empty_reg	<= 0;
		
		rsyn2_wgrey		<= rsyn1_wgrey;
	end
end


assign	read_ram_addr	= r_allow ? r_addr_next : r_addr;
assign	r_empty_o		= empty_reg;



//----------------------------------------------------------------------------//
//-------------------------------    RAM    ----------------------------------//
//----------------------------------------------------------------------------//
 

reg		[dw-1:0]	mem [(1<<aw)-1:0] /*synthesis syn_ramstyle="no_rw_check"*/; 
reg 	[aw-1:0] 	addr_reg;


always @(posedge w_clk_i)
	if(w_allow)
		mem[w_addr] <= w_din_i;


always @(posedge r_clk_i)
	addr_reg <= read_ram_addr;	

assign r_dout_o = mem[addr_reg];

endmodule 
