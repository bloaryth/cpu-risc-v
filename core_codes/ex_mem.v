//ex_mem.v
`include "defs.v"

module ex_mem(
	// from risc-v.v
	input wire clk,
	input wire rst,
	
	// to ( riscv.v -> data_ram.v )
	output reg ce,						// rst时禁止
	
	// from ex.v
	input wire[`AluOpBus] ex_aluop,
	input wire[`AluFunct3Bus] ex_alufunct3,
	input wire ex_me,				// 这个好像是多余的, 但是不高兴改了
	input wire[`MemAddrBus] ex_maddr,
	input wire ex_wreg,
	input wire[`RegAddrBus] ex_wd,
	input wire[`RegBus] ex_wdata,
	
	// to mem.v
	output reg[`AluOpBus] mem_aluop,
	output reg[`AluFunct3Bus] mem_alufunct3,
	output reg mem_me,				// 这个好像是多余的, 但是不高兴改了
	output reg[`MemAddrBus] mem_maddr,
	output reg mem_wreg,
	output reg[`RegAddrBus] mem_wd,
	output reg[`RegBus] mem_wdata

);
	
	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			ce <= `ChipDisable;			//复位的时候指令存储器被禁用
		end
		else begin
			ce <= `ChipEnable;			//复位的时候指令存储器使能
		end
	end
	
	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			mem_aluop <= `NOP;
			mem_alufunct3 <= `NOP_FUNCT3;
			mem_me <= `MemDisable;
			mem_maddr <= `NopMem;
			mem_wreg <= `WriteDisable;
			mem_wd <= `NopRegAddr;
			mem_wdata <= `ZeroWord;
		end
		else begin
			mem_aluop <= ex_aluop;
			mem_alufunct3 <= ex_alufunct3;
			mem_me <= ex_me;
			mem_maddr <= ex_maddr;
			mem_wreg <= ex_wreg;
			mem_wd <= ex_wd;
			mem_wdata <= ex_wdata;
		end
	end

endmodule