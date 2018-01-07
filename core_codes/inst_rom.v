//inst_rom.v
`include "defs.v"

module inst_rom(
	// from pc_reg.v
	input wire ce,
	input wire[`InstAddrBus] addr,
	
	// to if_id.v
	output reg[`InstBus] inst

);
	
	reg[`InstBus] inst_mem[0:`InstMemNum-1];
	
	initial $readmemh("..\\inst_test\\instr.data", inst_mem);
	
	always @ (*) begin
		if(ce == `ChipDisable)  begin
			inst <= `NopInst;
		end
		else begin
			inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
		end
	end

endmodule