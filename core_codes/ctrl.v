//ctrl.v
`include "defs.v"

module ctrl(
	// from risc-v.v
	input wire rst,
	
	// from id.v
	input wire req_id,		//来自译码阶段的请求
	
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
		else begin
			stall <= 6'b000000;
		end
	end

endmodule