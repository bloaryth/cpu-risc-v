//id_ex.v
`include "defs.v"

module id_ex(
	// from risc-v.v
	input wire clk,
	input wire rst,
	
	// from id.v
	input wire[`InstAddrBus] id_pc,
	input wire[`AluOpBus] id_aluop,
	input wire[`AluFunct3Bus] id_alufunct3,
	input wire[`AluFunct7Bus] id_alufunct7,
	input wire[`RegBus] id_reg1,
	input wire[`RegBus] id_reg2,
	input wire[`RegBus] id_imm,
	input wire id_wreg,
	input wire[`RegAddrBus] id_wd,
	
	// to ex.v
	output reg[`InstAddrBus] ex_pc,
	output reg[`AluOpBus] ex_aluop,
	output reg[`AluFunct3Bus] ex_alufunct3,
	output reg[`AluFunct7Bus] ex_alufunct7,
	output reg[`RegBus] ex_reg1,
	output reg[`RegBus] ex_reg2,
	output reg[`RegBus] ex_imm,
	output reg ex_wreg,
	output reg[`RegAddrBus] ex_wd,
	
	// from ctrl.v
	input wire[`CtrlWidth] stall

);

	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			ex_pc <= `NopInst;
			ex_aluop <= `NOP;
			ex_alufunct3 <= `NOP_FUNCT3;
			ex_alufunct7 <= `NOP_FUNCT7;
			ex_reg1 <= `ZeroWord;
			ex_reg2 <= `ZeroWord;
			ex_imm <= `ZeroWord;
			ex_wd <= `NopRegAddr;
			ex_wreg <= `WriteDisable;
		end
		else if(stall[`EX_BIT] == `Stop) begin
			// stall -> 向后传新值 最后一个还要不传有效值
			if(stall[`MEM_BIT] == `Continue) begin
				ex_pc <= `NopInst;
				ex_aluop <= `NOP;
				ex_alufunct3 <= `NOP_FUNCT3;
				ex_alufunct7 <= `NOP_FUNCT7;
				ex_reg1 <= `ZeroWord;
				ex_reg2 <= `ZeroWord;
				ex_imm <= `ZeroWord;
				ex_wd <= `NopRegAddr;
				ex_wreg <= `WriteDisable;				
			end
			else begin			
			// 什么也不做
			end
		end
		else begin
			ex_pc <= id_pc;
			ex_aluop <= id_aluop;
			ex_alufunct3 <= id_alufunct3;
			ex_alufunct7 <= id_alufunct7;
			ex_reg1 <= id_reg1;
			ex_reg2 <= id_reg2;
			ex_imm <= id_imm;
			ex_wreg <= id_wreg;
			ex_wd <= id_wd;
		end
	end

endmodule