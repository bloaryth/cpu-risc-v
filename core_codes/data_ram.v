// data_ram.v
`include "defs.v"

module data_ram(
	// from rsicv_min_sopc.v
	input wire ce,
	
	// 写端口 --- from ( mem.v -> risc-v.v)
	input wire we,
	input wire[`DataAddrBus] waddr,
	input wire[`DataBus] data_i,
	
	// 读端口 --- from ( mem.v -> risc-v.v ) --- to ( risc-v.v -> mem.v )
	input wire re,
	input wire[`DataAddrBus] raddr,
	output reg[`DataBus] data_o

);

	reg[`DataBus] data_mem[0:`DataMemNum-1];
	
	// 写操作
	always @ (*) begin
		if(ce == `ChipDisable) begin
			// data_O <= `ZeroWord;	
		end
		else if(we == `WriteEnable) begin
			data_mem[waddr] <= {data_i[7:0], data_i[15:8], data_i[23:16], data_i[31:24]};		// CPU是大端序, 只有在内存里才是小端序
			// data_mem[waddr] <= data_i;
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
			data_o <= {data_mem[raddr][7:0],data_mem[raddr][15:8],data_mem[raddr][23:16],data_mem[raddr][31:24]}; // CPU是大端序, 只有在内存里才是小端序
			// data_o <= data_mem[raddr];
		end
		else begin
			data_o <= `ZeroWord;
		end
	end

endmodule