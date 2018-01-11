// defs.v

`ifndef DEFS_V
`define DEFS_V

// ***********  全局宏定义  **********
`define RstEnable		1'b1			//复位信号有效
`define RstDisable		1'b0			//复位信号无效

`define True_v			1'b1			//逻辑为真
`define Flase_v			1'b0			//逻辑位假
`define ChipEnable		1'b1			//芯片使能
`define ChipDisable		1'b0			//芯片禁止

// *************  与流水线暂停ctrl有关 *******************

// `define STOP_REQ		1'b1			// 暂停请求
`define CtrlWidth		5:0				
`define Stop			1'b1			// 流水线暂停
`define Continue		1'b0			// 流水线继续
`define PC_BIT			0				// STALL 中的位置
`define IF_BIT			1
`define ID_BIT			2
`define EX_BIT			3
`define MEM_BIT			4
`define WB_BIT			5

// *************  与指令存储器ROM有关的宏定义  ***************

`define InstValid		1'b0			//指令有效
`define InstInvalid		1'b1			//指令无效

`define InstAddrBus		31:0			//ROM地址总线宽度
`define InstBus 		31:0			//ROM数据总线宽度
`define NopInst			32'h00000000	//32位0指令
// `define InstMemNum		131071			//ROM的实际大小位128KB
`define InstMemNum		8191			//ROM的实际大小位???KB
`define InstMemNumLog2	17				//ROM实际使用的地址线宽度

// *************** 与数据存储器RAM有关的宏定义 *********************

`define DataAddrBus		31:0			//数据线的宽度
`define DataBus			31:0			//数据总线的宽度
// `define ByteBus			7:0				//内存中一个字节
`define ValidBitBus		3:0				//有效位宽度
`define ZeroValidBit	4'b0000			//默认
`define Byte			4'b1000			//byte有效位
`define Half			4'b1100			//half有效位
`define Word			4'b1111			//word有效位
`define DataMemNum		8191			//RAM的大小

// *************  与通用寄存器Regfile有关的宏定义  *****************

`define WriteEnable		1'b1			//使能写
`define WriteDisable	1'b0			//禁止写
`define ReadEnable		1'b1			//使能读
`define ReadDisable		1'b0			//禁止写
`define ReadSucceed		1'b1			//读到正确的数据
`define ReadFailed		1'b0			//未能读出正确的数据

`define RegAddrBus		4:0				//Regfile模块的地址线宽度
`define RegBus			31:0			//Regfile模块的数据线宽度
`define ZeroWord		32'h00000000	//32位的数值0
`define OneWord			32'h00000001	//32位的数值1
// `define SignBit			31				//第31位
`define RegWidth		32				//通用寄存器的宽度
`define DoubleRegWidth	64				//两倍的通用寄存器宽度
`define DoubleRegBus	63:0			//两倍的通用寄存器的数据线宽度
`define RegNum			32				//通用寄存器的数量
`define RegNumLog2		5				//寻址通用寄存器的地址位数
`define NopRegAddr		5'b00000		//复位时用到

// ***************** ID阶段 指令解码  ******************

`define AluOpBus		7:0				//译码阶段的输出aluop_o的宽度
`define AluFunct3Bus	2:0				//译码阶段的输出alufunct3_o的宽度
`define AluFunct7Bus	6:0				//译码阶段的输出alufunct7_o的宽度

// ***************** 与具体指令有关 指令类型 **************

`define RType			3'b000
`define IType			3'b100
`define SType			3'b110
`define BType			3'b101
`define UType			3'b010
`define JType			3'b011

// *************  与具体指令有关 opcode  **************

// DEFAULT
`define NOP				7'b0010011

`define LUI				7'b0110111
`define AUIPC			7'b0010111
`define JAL				7'b1101111
`define JALR			7'b1100111
`define BRANCH			7'b1100011		// BEQ BNE BLT BGE BLTU BGEU
`define LOAD			7'b0000011		// LB LH LBU LHU
`define STORE			7'b0100011		// SB SH SW
`define EXE_IMM 		7'b0010011		// ADDI SLTI SLTIU XORI ORI ANDI SLLI SRLI SRAI 
`define EXE				7'b0110011		// ADD SUB SLL SLT SLTU XOR SRL SRA OR AND
`define MEM				7'b0001111		// FENCE FENCI.I
`define SYSTEM			7'b1110011		// ECALL EBREAK CSRRW CSRRS CSRRC CSRRWI CSRRSI CSRRCI

// ************** 与具体指令有关 funct3  **************

// DEFAULT
`define NOP_FUNCT3		3'b000

// BRANCE
`define BEQ 			3'b000
`define BNE				3'b001
`define BLT				3'b100
`define BGE				3'b101
`define BLTU			3'b110
`define BGEU			3'b111

// LOAD
`define LB				3'b000
`define LH				3'b001
`define LW				3'b010
`define LBU				3'b100
`define LHU				3'b101

// STORE
`define SB				3'b000
`define SH				3'b001
`define SW				3'b010

// EXE_IMM
`define ADDI			3'b000
`define SLTI			3'b010
`define SLTIU			3'b011
`define XORI			3'b100
`define ORI				3'b110
`define ANDI			3'b111
`define SLLI			3'b001
`define SRLI_SRAI		3'b101

// EXE
`define ADD_SUB			3'b000
`define SLL				3'b001
`define SLT				3'b010
`define SLTU			3'b011
`define XOR				3'b100
`define SRL_SRA			3'b101
`define OR				3'b110
`define AND				3'b111

// MEM
//****  空白,暂时没做 ****

// SYSTEM
`define ECALL_EBREAK	3'b000
`define CSRRW			3'b001
`define CSRRS			3'b010
`define CSRRC			3'b011
`define CSRRWI			3'b101
`define CSRRSI			3'b110
`define CSRRCI			3'b111

// **************** 与具体指令有关 funct7 **************

// DEFAULT
`define NOP_FUNCT7		7'b0000000

// SRLI_SRAI
`define SRLI			7'b0000000
`define SRAI			7'b0100000

// ADD_SUB
`define ADD				7'b0000000
`define SUB				7'b0100000

// SRL_SRA
`define SRL				7'b0000000
`define SRA				7'b0100000

// **************** 与具体指令有关 funct12 **************

`define ECALL			12'b000000000000
`define EBREAK			12'b000000000001

// **************** 与BRANCH指令有关 *******************

`define Jump			1'b1
`define Stay			1'b0

// **************** 与 LOAD STORE 指令有关 *****************

`define MemEnable		1'b1
`define MemDisable		1'b0
`define MemAddrBus		31:0
`define NopMem			32'h00000000

// **************** 弃用  **********************
// `define EXE_ORI			6'b001101		//ori
// `define	EXE_NOP			6'b000000		//nop

// `define EXE_OR_OP		8'b00100101
// `define EXE_NOP_OP		8'b00000000

// `define EXE_RES_LOGIC	3'b001

// `define EXE_RES_NOP		3'b000

`endif