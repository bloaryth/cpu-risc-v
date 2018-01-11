//ctrl.v

`ifndef CTRL
`define CTRL

`include "defs.v"

module ctrl(
	// from risc-v.v
	input wire rst,
	
	// from id.v
	input wire req_id,		//来自译码阶段的请求
	
	// from ram.v
	input wire req_if,		//来自取指令阶段的请求
	
	// to 5-level (all)
	output reg[`CtrlWidth] stall
);

	always @ (*) begin
		if(rst == `RstEnable) begin
			stall <= 6'b000000;
		end
		else if(req_id == `Stop) begin
			stall <= 6'b000111;
		end
		else if(req_if == `Stop) begin
			stall <= 6'b000011;
		end
		else begin
			stall <= 6'b000000;
		end
	end

endmodule

`endif