// data_ram.v
`include "defs.v"

module data_ram(
	// from rsic-v.v
	input wire clk,
	input wire ce,
	
	// 写端口 --- from mem.v
	input wire we,
	input wire waddr,
	input wire[`DataBus] wdata_i,
	
	// 读端口 --- from mem.v --- to mem.v
	input wire re,
	input wire raddr,
	output wire[`DataBus] data_o

);

	reg[`DataBus] data_mem[0:`DataMemNum-1];
	
	// 写操作
	always @ (*) begin
		if(ce == `ChipDisable) begin
			// data_O <= `ZeroWord;	
		end
		else if(we == `WriteEnable) begin
			data_mem[addr] <= data_i;
		end
	end

	// 读操作
	always @ (*) begin
		if(ce == `ChipDisable) begin
			data_o <= `ZeroWord;
		end
		else if((raddr == waddr) && (we == `WriteEnable) && (re == `ReadEnable)) begin
			data_o <= data_i;
		end
		else if(re == `ReadEnable) begin
			data_o <= data_mem[addr];
		end
		else begin
			data_o <= `ZeroWord;
		end
	end

endmodule