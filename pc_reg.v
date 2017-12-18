`include "defs.v"

module pc_reg(
	input wire clk,
	input wire rst,
	output reg[`InstAddrBus] pc,
	output reg ce
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
		if(ce == `ChipDisable) begin
			pc <= `ZeroWord;			//指令寄存器禁用时, pc = 0	(32位)
		end
		else begin
			pc <= pc + 4'h4;			//指令寄存器使能时, pc += 4		
		end
	end
	
endmodule