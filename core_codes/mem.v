//mem.v
`include "defs.v"

module mem(
	// from risc-v.v
	input wire rst,
	
	// from ex_mem.v
	input wire[`AluOpBus] aluop_i,
	input wire[`AluFunct3Bus] alufunct3_i,
	input wire me_i,				// 这个好像是多余的, 但是不高兴改了
	input wire[`MemAddrBus] maddr_i,
	input wire wreg_i,
	input wire[`RegAddrBus] wd_i,
	input wire[`RegBus] wdata_i,

	// to mem_wb.v
	output reg wreg_o,
	output reg[`RegAddrBus] wd_o,
	output reg[`RegBus] wdata_o,
	
	// to regfile.v --> forwarding
	output reg wreg_f,
	output reg[`RegAddrBus] wd_f,
	output reg[`RegBus] wdata_f

);

	always @ (*) begin
		if(rst == `RstEnable) begin
			wreg_o <= `WriteDisable;
			wd_o <= `NopRegAddr;
			wdata_o <= `ZeroWord;
		end
		else begin
			wreg_o <= wreg_i;
			wd_o <= wd_i;
			wdata_o <= wdata_i;
		end
	end
	
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