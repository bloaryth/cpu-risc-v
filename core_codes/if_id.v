//if_id.v
`include "defs.v"

module if_id(
	// from risc-v.v
	input wire clk,
	input wire rst,
	
	// from ctrl.v
	input wire[`CtrlWidth] 		stall,
	
	// from id.v
	input wire jumpout,
	
	// from pc_reg.v, inst_rom.v
	input wire[`InstAddrBus]	if_pc,
	input wire[`InstBus]		if_inst,
	
	// to id.v
	output reg[`InstAddrBus]	id_pc,
	output reg[`InstBus]		id_inst
	
);
	
	//每个clk开始时把数据送给id
	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			id_pc <= `ZeroWord;			//复位时pc为0
			id_inst <= `ZeroWord;		//复位时指令为ZERO(不是空指令)
		end
		else if(jumpout == `Jump) begin
			id_pc <= `ZeroWord;			
			id_inst <= `ZeroWord;		// 不同于stall, 要传一个指令进去刷新jumpout
		end
		else if(stall[`ID_BIT] == `Stop) begin
			if(stall[`EX_BIT] == `Continue) begin
				id_pc <= `ZeroWord;			
				id_inst <= `ZeroWord;		// 传空指令以防ex指令再跑一边			
			end
			else begin
				//什么都不做 
			end
		end
		else begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
	
endmodule