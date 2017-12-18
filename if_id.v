`include "defs.v"

module if_id(
	input wire clk,
	input wire rst,
	
	input wire[`InstAddrBus]	if_pc,
	input wire[`InstBus]		if_inst,
	
	output reg[`InstAddrBus]	id_pc,
	output reg[`InstBus]		id_inst
	
);

	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			id_pc <= `ZeroWord;			//复位时pc为0
			id_inst <= `ZeroWord;		//复位时指令为空指令
		end
		else begin
			id_pc <= if_pc;
			id_inst <= if_inst;
		end
	end
	
endmodule