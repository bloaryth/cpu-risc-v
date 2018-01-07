//id.v
`include "defs.v"

module id(
	//from risc-v.v
	input wire rst,

	//from if.v
	input wire[`InstAddrBus] pc_i,
	input wire[`InstBus] inst_i,
	
	//from regfile.v
	input wire reg1_suc,
	input wire[`RegBus] reg1_data_i,
	input wire reg2_suc,
	input wire[`RegBus] reg2_data_i,
	
	//to regfile.v
	output reg reg1_read_o,
	output reg reg2_read_o,
	output reg[`RegAddrBus] reg1_addr_o,
	output reg[`RegAddrBus] reg2_addr_o,
	
	//to id_ex.v
	output reg[`InstAddrBus] pc_o,
	output reg[`AluOpBus] aluop_o,
	output reg[`AluFunct3Bus] alufunct3_o,
	output reg[`AluFunct7Bus] alufunct7_o,
	output reg[`RegBus] reg1_o,
	output reg[`RegBus] reg2_o,
	output reg[`RegBus] imm_o,
	output reg[`RegAddrBus] wd_o,
	output reg wreg_o

);
	
	wire[6:0] op = inst_i[6:0];
	// wire[4:0] rd = inst_i[11:7];
	// wire[4:0] rs1 = inst_i[19:15];
	// wire[4:0] rs2 = inst_i[24:20];
	// wire[2:0] funct3 = inst_i[14:12];
	// wire[6:0] funct7 = inst_i[31:25];
	// wire[4:0] op2 = inst_i[10:6];
	// wire[5:0] op3 = inst_i[5:0];
	// wire[4:0] op4 = inst_i[20:16];
	
	reg[2:0] inst_type;
	reg[`RegBus] imm;
	
	// reg instvalid;
	
	//指令分类 
	always @ (*) begin
		if(rst == `RstEnable) begin
			inst_type <= `IType;		//NOP指令
		end
		else begin
			inst_type <= `IType;
			case(op)
				`LUI : inst_type <= `UType;
				`AUIPC : inst_type <= `UType;
				`JAL : inst_type <= `JType;
				`JALR : inst_type <= `IType;
				`BRANCH : inst_type <= `BType;
				`LOAD : inst_type <= `IType;
				`STORE : inst_type <= `SType;
				`EXE_IMM : inst_type <= `IType;
				`EXE : inst_type <= `RType;
				// `MEM :
				// `SYSTEM : 			//暂时未写
			endcase
		end
	end
	
	// 准备好 pc aluop alufunct3 alufunct7 imm wd wreg
	always @ (*) begin
		if(rst == `RstEnable) begin
			pc_o <= `NopInst;
			aluop_o <= `NOP;
			alufunct3_o <= `NOP_FUNCT3;
			alufunct7_o <= `NOP_FUNCT7;
			imm <= `ZeroWord;
			wreg_o <= `WriteDisable;
			wd_o <= `NopRegAddr;
			// instvalid <= `InstValid;
		end
		else begin
			pc_o <= pc_i;
			aluop_o <= inst_i[6:0];
			alufunct3_o <= inst_i[14:12];
			alufunct7_o <= inst_i[31:25];
			imm <= `ZeroWord;
			wreg_o <= `WriteDisable;
			wd_o <= inst_i[11:7];	
			// instvalid <= `InstValid;
		
			case(inst_type)
				`RType : begin
					wreg_o <= `WriteEnable;
					// instvalid <= `InstValid;
				end
				`IType : begin
					imm <= {{21{inst_i[31]}}, inst_i[30:20]};
					wreg_o <= `WriteEnable;
					// instvalid <= `InstValid;
				end
				`SType : begin
					imm <= {{21{inst_i[31]}}, inst_i[30:25], inst_i[11:8], inst_i[7]};
					wreg_o <= `WriteDisable;
					// instvalid <= `InstValid;
				end
				`BType : begin
					imm <= {{20{inst_i[31]}}, inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
					wreg_o <= `WriteDisable;
					// instvalid <= `InstValid;
				end
				`UType : begin
					imm <= {inst_i[31:12], {12{1'b0}}};
					wreg_o <= `WriteEnable;
					// instvalid <= `InstValid;
				end
				`JType : begin
					imm <= {{12{inst_i[31]}}, inst_i[19:12], inst_i[20], inst_i[30:25], inst_i[24:21], 1'b0};
					wreg_o <= `WriteEnable;
					// instvalid <= `InstValid;
				end
			endcase
		end
	end
	
	// 通知regfile取数据 
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_read_o <= `ReadDisable;		//modified  1'b0 -> `ReadDisable
			reg2_read_o <= `ReadDisable;		//modified
			reg1_addr_o <= `NopRegAddr;
			reg2_addr_o <= `NopRegAddr;		
		end
		else begin
			reg1_read_o <= `ReadDisable;		//modified  1'b0 -> `ReadDisable
			reg2_read_o <= `ReadDisable;		//modified
			reg1_addr_o <= inst_i[19:15];
			reg2_addr_o <= inst_i[24:20];
			
			case(inst_type)
				`RType : begin
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadEnable;
				end
				`IType : begin
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadDisable;
				end
				`SType : begin
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadEnable;
				end
				`BType : begin
					reg1_read_o <= `ReadEnable;
					reg2_read_o <= `ReadEnable;
				end
				`UType : begin
					reg1_read_o <= `ReadDisable;
					reg2_read_o <= `ReadDisable;
				end
				`JType : begin
					reg1_read_o <= `ReadDisable;
					reg2_read_o <= `ReadDisable;
				end
			endcase
		end
	end
	
	// 输出 reg1
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end
		else if(reg1_read_o == `ReadEnable) begin
			reg1_o <= reg1_data_i;
		end
		else if(reg1_read_o == `ReadDisable) begin
			reg1_o <= imm;
		end
		else begin
			reg1_o <= `ZeroWord;
		end
	end
	
	// 输出 reg2
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end
		else if(reg2_read_o == `ReadEnable) begin
			reg2_o <= reg2_data_i;
		end
		else if(reg2_read_o == `ReadDisable) begin
			reg2_o <= imm;
		end
		else begin
			reg2_o <= `ZeroWord;
		end
	end
	
	// 输出 imm
	always @ (*) begin
		if(rst == `RstEnable) begin
			imm_o <= `ZeroWord;
		end
		else begin
			imm_o <= imm;
		end
	end

endmodule