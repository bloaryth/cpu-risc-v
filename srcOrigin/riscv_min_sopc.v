//openmips_min_sopc.v
`include "defs.v"
`include "riscv.v"
`include "rom_ram.v"
// `include "inst_rom.v"
// `include "data_ram.v"

module riscv_min_sopc(
	input wire clk,
	input wire rst
	
);

	// 连接 riscv 与 inst_rom
	wire[`InstAddrBus] inst_addr;
	wire[`InstBus] inst;
	wire rom_ce;
	wire req_if;
	
	// 连接 riscv 与 data_ram
	wire re;
	wire[`ValidBitBus] rvalid_bit;
	wire[`DataAddrBus] raddr;
	wire[`DataBus] rdata;
	wire we;
	wire[`ValidBitBus] wvalid_bit;
	wire[`DataAddrBus] waddr;
	wire[`DataBus] wdata;
	wire ram_ce;
	
	
	riscv riscv0(
		.clk(clk),.rst(rst),
	
		.rom_addr_o(inst_addr), .rom_data_i(inst), .rom_ce_o(rom_ce), .req_if(req_if),
		
		.ram_ce_o(ram_ce),
		.ram_re_m(re), .ram_rvalid_bit(rvalid_bit), .ram_raddr_m(raddr), .ram_rdata_m(rdata),
		.ram_we_m(we), .ram_wvalid_bit(wvalid_bit), .ram_waddr_m(waddr), .ram_wdata_m(wdata)
	);
	
	rom_ram rom_ram0(
		.rom_ce(rom_ce),		
		.addr(inst_addr),
		.inst(inst),
		
		.stall_req(req_if),
	
		.ram_ce(ram_ce),
		
		.we(we), .wvalid_bit(wvalid_bit), .waddr(waddr), .data_i(wdata),
		.re(re), .rvalid_bit(rvalid_bit), .raddr(raddr), .data_o(rdata)	
	
	);
	// inst_rom inst_rom0(
		// .addr(inst_addr),
		// .inst(inst),
		// .ce(rom_ce)	
	// );
	
	// data_ram data_ram0(
		// .ce(ram_ce),
		
		// .we(we), .wvalid_bit(wvalid_bit), .waddr(waddr), .data_i(wdata),
		// .re(re), .rvalid_bit(rvalid_bit), .raddr(raddr), .data_o(rdata)
	// );

endmodule