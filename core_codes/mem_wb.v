//mem_wb.v
`include "defs.v"

module mem_wb(
	input wire clk,
	input wire rst,
	
	// from mem.v
	input wire[`RegAddrBus] mem_wd,
	input wire mem_wreg,
	input wire[`RegBus] mem_wdata,
	
	// to regfile.v
	output reg[`RegAddrBus] wb_wd,
	output reg wb_wreg,
	output reg[`RegBus] wb_wdata

);
	//clk开始时写回
	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wb_wd <= `NopRegAddr;
			wb_wreg <= `WriteDisable;
			wb_wdata <= `ZeroWord;
		end
		else begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
			$display("mem_wdata -> %c", mem_wdata);
			// $display(wb_wdata);
		end
	end

endmodule