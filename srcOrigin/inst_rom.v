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
	
	initial begin
		// $readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\jal_alupc.data", inst_mem);	
		// $readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\jal_alupc.data", inst_mem);	
		// $readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\jal_alupc.data", inst_mem);	
		// $readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\shifts.data", inst_mem);	
		$readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\helloworld.s", inst_mem);	
	end
	
	always @ (*) begin
		if(ce == `ChipDisable)  begin
			inst <= `NopInst;
		end
		else begin
			inst <= {inst_mem[addr >> 2][7:0], inst_mem[addr >> 2][15:8], inst_mem[addr >> 2][23:16], inst_mem[addr >> 2][31:24]};
		end
	end

endmodule