//mem.v
`include "defs.v"

module mem(
	// from risc-v.v
	input wire rst,
	
	// from ex_mem.v
	input wire[`AluOpBus] aluop_i,
	input wire[`AluFunct3Bus] alufunct3_i,
	input wire me_i,				// 这个好像是多余的, 但是不高兴改了
	input wire[`MemAddrBus] maddr_i,// LOAD STORE 使用地址
	input wire wreg_i,
	input wire[`RegAddrBus] wd_i,
	input wire[`RegBus] wdata_i,	// STORE 时代表写入储存器的值(但是wreg_i==0), 其他时候代表写入寄存器的值
	
	// 与 mem_ram.v 交互 	
	output reg re_m,
	output reg[`ValidBitBus] rvalid_bit,
	output reg[`MemAddrBus] raddr_m,
	input wire[`DataBus] rdata_m,		//读数据
	output reg we_m,
	output reg[`ValidBitBus] wvalid_bit,
	output reg[`MemAddrBus] waddr_m,
	output reg[`DataBus] wdata_m,		//写数据

	// to mem_wb.v
	output reg wreg_o,
	output reg[`RegAddrBus] wd_o,
	output reg[`RegBus] wdata_o,
	
	// to regfile.v --> forwarding
	output reg wreg_f,
	output reg[`RegAddrBus] wd_f,
	output reg[`RegBus] wdata_f

);
	// 存储LOAD操作后的结果
	reg[`RegBus] mout;

	// 通知内存取数据出来 以及写数据
	always @ (*) begin
		if(rst == `RstEnable) begin
			re_m <= `ReadDisable;
			rvalid_bit <= `ZeroValidBit;
			raddr_m <= `NopMem;
			we_m <= `WriteDisable;
			wvalid_bit <= `ZeroValidBit;
			waddr_m <= `NopMem;
			wdata_m <= `ZeroWord;	
		end
		else begin
			re_m <= `ReadDisable;
			rvalid_bit <= `ZeroValidBit;
			raddr_m <= `NopMem;
			we_m <= `WriteDisable;
			wvalid_bit <= `ZeroValidBit;
			waddr_m <= `NopMem;
			wdata_m <= `ZeroWord;
			
			if(me_i == `MemEnable) begin
				case(aluop_i)
					`LOAD : begin
						re_m <= `ReadEnable;
						raddr_m <= maddr_i;
						case(alufunct3_i)
							`LB : begin
								rvalid_bit <= `Byte;
							end
							`LH : begin
								rvalid_bit <= `Half;							
							end
							`LW : begin
								rvalid_bit <= `Word;
							end
							`LBU : begin
								rvalid_bit <= `Byte;
							end
							`LHU : begin
								rvalid_bit <= `Half;
							end
						endcase
					end
					`STORE : begin
						case(alufunct3_i)
							`SB : begin
								we_m <= `WriteEnable;
								wvalid_bit <= `Byte;
								waddr_m <= maddr_i;
								wdata_m <= {{24{1'b0}}, wdata_i[7:0]};
							end
							`SH : begin
								we_m <= `WriteEnable;
								wvalid_bit <= `Half;
								waddr_m <= maddr_i;
								wdata_m <= {{16{1'b0}}, wdata_i[15:0]};	
							end
							`SW : begin
								we_m <= `WriteEnable;
								wvalid_bit <= `Word;
								waddr_m <= maddr_i;
								wdata_m <= wdata_i[31:0];			//CPU里通用大端序, 只有在mem里才是小端序
							end
						endcase					
					end
					default : begin
						// 什么也不做
					end
				endcase
			end		
		end
	end

	// 处理load后的正确数据
	always @ (*) begin
		if(rst == `RstEnable) begin
			mout <= `ZeroWord;
		end
		else begin
			mout <= `ZeroWord;
			if(aluop_i == `LOAD) begin
				case(alufunct3_i)
					`LB : begin
						mout <= {{24{rdata_m[7]}},rdata_m[7:0]};
					end
					`LH : begin
						mout <= {{16{rdata_m[15]}},rdata_m[15:0]};
					end
					`LW : begin
						mout <= rdata_m;
					end
					`LBU : begin
						mout <= {{24{1'b0}},rdata_m[7:0]};					
					end
					`LHU : begin					
						mout <= {{16{1'b0}},rdata_m[15:0]};
					end
					default : begin
						// 什么也不做
					end
				endcase
			end
		end
	end
	
	// 写到下一个阶段
	always @ (*) begin
		if(rst == `RstEnable) begin
			wreg_o <= `WriteDisable;
			wd_o <= `NopRegAddr;
			wdata_o <= `ZeroWord;
		end
		else begin
			wreg_o <= wreg_i;
			wd_o <= wd_i;
			if(aluop_i == `LOAD) begin
				wdata_o <= mout;
			end
			else begin
				wdata_o <= wdata_i;
			end
		end
	end
	
	// 用于forwarding
	always @ (*) begin 
		if(rst == `RstEnable) begin
			wreg_f <= `WriteDisable;
			wd_f <= `NopRegAddr;
			wdata_f <= `ZeroWord;
		end
		else begin
			wreg_f <= wreg_o;
			wd_f <= wd_o;
			wdata_f <= wdata_o;	
		end
	end

endmodule