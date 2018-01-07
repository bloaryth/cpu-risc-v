//pc_reg.v
`include "defs.v"

module pc_reg(
	// from risc-v.v
	input wire clk,
	input wire rst,
	
	// to inst_rom.v, if_id.v
	output reg[`InstAddrBus] pc,
	
	// to ???
	output reg ce
);
	
	always @ (posedge clk) begin
		// 控制pc_reg是否正常工作
		if(rst == `RstEnable) begin
			ce <= `ChipDisable;			//复位的时候指令存储器被禁用
		end
		else begin
			ce <= `ChipEnable;			//复位的时候指令存储器使能
		end
		
	end
	
	always @ (posedge clk) begin
		// 正常工作时每次pc += 4
		if(ce == `ChipDisable) begin
			pc <= `ZeroWord;			//指令寄存器禁用时, pc = 0	(32位)
		end
		else begin
			pc <= pc + 4'h4;			//指令寄存器使能时, pc += 4		
		end	
	end
	
endmodule