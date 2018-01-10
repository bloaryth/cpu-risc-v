//pc_reg.v
`include "defs.v"

module pc_reg(
	// from risc-v.v
	input wire clk,
	input wire rst,
	
	// from ctrl.v
	input wire[`CtrlWidth] stall,
	
	// from ex.v
	input wire jumpout,
	input wire[`InstAddrBus] pc_i,
	
	// to inst_rom.v, if_id.v
	output reg[`InstAddrBus] pc,
	
	// to inst_rom.v
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
	
	// 用时序加组合实现  --- 这样会不会不可综合 ?
	always @ (posedge clk) begin
		// 正常工作时每次pc += 4
		if(ce == `ChipDisable) begin
			pc <= `ZeroWord;			//指令寄存器禁用时, pc = 0	(32位)
		end
		else if(stall[`PC_BIT] == `Stop) begin
			// 什么也不做
		end								//这里和书上有些不一样
		else begin
			pc <= pc + 4'h4;			//指令寄存器使能时, pc += 4		
		end	
	end
	
	// 跳转指令立刻修改pc (不用管有没有stall ? )
	always @ (*) begin
		if(jumpout == `Jump) begin
			pc <= pc_i;
		end
		else begin
			// 什么也不做
		end
	end
	
endmodule