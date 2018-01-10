//riscv.v
`include "defs.v"
`include "ctrl.v"
`include "pc_reg.v"
`include "if_id.v"
`include "id.v"
`include "id_ex.v"
`include "ex.v"
`include "ex_mem.v"
`include "mem.v"
`include "mem_wb.v"
`include "regfile.v"

module riscv(
	// from top
	input wire clk,
	input wire rst,
	
	// from pc_reg to inst_rom.v
	input wire[`InstBus] rom_data_i,
	output wire[`InstAddrBus] rom_addr_o,
	output wire rom_ce_o,
	
	// ex_mem.v -> data_ram.v
	output wire ram_ce_o,
	
	// mem.v  <-> data_ram.v
	output wire ram_re_m,
	output wire[`ValidBitBus] ram_rvalid_bit,
	output wire[`MemAddrBus] ram_raddr_m,
	input wire[`DataBus] ram_rdata_m,		//读数据
	output wire ram_we_m,
	output wire[`ValidBitBus] ram_wvalid_bit,
	output wire[`MemAddrBus] ram_waddr_m,
	output wire[`DataBus] ram_wdata_m		//写数据
);
	// ctrl.v -> pc_reg.v, if_id.v,
	wire[`CtrlWidth] stall;
	
	// pc.v -> if_id.v
	wire[`InstAddrBus] pc;	
	
	// if_id.v -> id.v
	wire[`InstAddrBus] id_pc_i;		 
	wire[`InstBus] id_inst_i;	
	
	// regfile.v -> id.v
	wire reg1_suc;
	wire[`RegBus] reg1_data;
	wire reg2_suc;
	wire[`RegBus] reg2_data;
	
	// id.v -> regfile.v
	wire reg1_read;
	wire reg2_read;
	wire[`RegAddrBus] reg1_addr;
	wire[`RegAddrBus] reg2_addr;
	
	// id.v -> ctrl.v
	wire req_id;

	// id.v - > id_ex.v
	wire[`InstAddrBus] id_pc_o;
	wire[`AluOpBus] id_aluop_o;
	wire[`AluFunct3Bus] id_alufunct3_o;
	wire[`AluFunct7Bus] id_alufunct7_o;
	wire[`RegBus] id_reg1_o;
	wire[`RegBus] id_reg2_o;
	wire[`RegBus] id_imm_o;
	wire id_wreg_o;
	wire[`RegAddrBus] id_wd_o;
	
	// id.v -> pc_reg
	wire jump_o;
	wire[`InstAddrBus] jpc_o;
	
	// id_ex.v -> ex.v
	wire[`InstAddrBus] ex_pc_i;
	wire[`AluOpBus] ex_aluop_i;
	wire[`AluFunct3Bus] ex_alufunct3_i;
	wire[`AluFunct7Bus] ex_alufunct7_i;
	wire[`RegBus] ex_reg1_i;
	wire[`RegBus] ex_reg2_i;
	wire[`RegBus] ex_imm_i;		// 实际上只有S类; B类 要用到; 其他都可以用 reg1_i 和 reg2_i
	wire ex_wreg_i;
	wire[`RegAddrBus] ex_wd_i;

	// ex.v -> ex_mem.v
	wire[`AluOpBus] ex_aluop_o;
	wire[`AluFunct3Bus] ex_alufunct3_o; // 为 LOAD 和 STORE 准备
	wire ex_me_o;
	wire[`MemAddrBus] ex_maddr_o;
	wire ex_wreg_o;
	wire[`RegAddrBus] ex_wd_o;
	wire[`RegBus] ex_wdata_o;	
	
	// ex.v -> regfile.v   -- forwarding
	wire ex_wreg_f;
	wire[`RegAddrBus] ex_wd_f;
	wire[`RegBus] ex_wdata_f;
	
	// ex_mem.v -> mem.v
	wire[`AluOpBus] mem_aluop_i;
	wire[`AluFunct3Bus] mem_alufunct3_i;
	wire mem_me_i;				
	wire[`MemAddrBus] mem_maddr_i;
	wire mem_wreg_i;
	wire[`RegAddrBus] mem_wd_i;
	wire[`RegBus] mem_wdata_i;	

	// mem.v -> mem_wb.v
	wire mem_wreg_o;
	wire[`RegAddrBus] mem_wd_o;
	wire[`RegBus] mem_wdata_o;
	
	// mem.v -> regfile.v -- forwarding
	wire mem_wreg_f;
	wire[`RegAddrBus] mem_wd_f;
	wire[`RegBus] mem_wdata_f;
	
	// mem_wb.v -> regfile.v
	wire[`RegAddrBus] wb_wd_o;
	wire wb_wreg_o;
	wire[`RegBus] wb_wdata_o;
	
	ctrl ctrl0(
		.rst(rst), 
		.req_id(req_id), .stall(stall)
	);

	pc_reg pc_reg0(
		.clk(clk), .rst(rst),
		.stall(stall),
		.jumpout(jump_o), .pc_i(jpc_o),
		.pc(pc), .ce(rom_ce_o)
	);	

	// pc.v -> inst_rom 分叉
	assign rom_addr_o = pc;
	
	if_id if_id0(
		.clk(clk), .rst(rst),
		.stall(stall),
		.if_pc(pc),	.if_inst(rom_data_i),
		.id_pc(id_pc_i), .id_inst(id_inst_i)		
	);	
	
	id id0(
		.rst(rst),
		
		.pc_i(id_pc_i), .inst_i(id_inst_i),	
		
		.reg1_suc(reg1_suc), .reg2_suc(reg2_suc),
		.reg1_data_i(reg1_data), .reg2_data_i(reg2_data), 
		
		.reg1_read_o(reg1_read), .reg2_read_o(reg2_read),
		.reg1_addr_o(reg1_addr), .reg2_addr_o(reg2_addr),
		
		.pc_o(id_pc_o), .aluop_o(id_aluop_o),
		.alufunct3_o(id_alufunct3_o), .alufunct7_o(id_alufunct7_o),
		.reg1_o(id_reg1_o), .reg2_o(id_reg2_o), .imm_o(id_imm_o),
		.wd_o(id_wd_o), .wreg_o(id_wreg_o),
		
		.stall_req(req_id),
		
		.jump_o(jump_o), .jpc_o(jpc_o)

	);
	
	regfile regfile0(
		.clk(clk), .rst(rst),
		
		.we(wb_wreg_o), .waddr(wb_wd_o), .wdata(wb_wdata_o),
		.ex_we(ex_wreg_f), .ex_waddr(ex_wd_f), .ex_wdata(ex_wdata_f),
		.mem_we(mem_wreg_f), .mem_waddr(mem_wd_f), .mem_wdata(mem_wdata_f),
		
		.re1(reg1_read), .raddr1(reg1_addr), .rsuc1(reg1_suc), .rdata1(reg1_data),
		.re2(reg2_read), .raddr2(reg2_addr), .rsuc2(reg2_suc), .rdata2(reg2_data)
	
	);
	
	id_ex id_ex0(
		.clk(clk), .rst(rst),
		
		.id_pc(id_pc_o), .id_aluop(id_aluop_o), 
		.id_alufunct3(id_alufunct3_o), .id_alufunct7(id_alufunct7_o),
		.id_reg1(id_reg1_o), .id_reg2(id_reg2_o), .id_imm(id_imm_o), 
		.id_wreg(id_wreg_o), .id_wd(id_wd_o),
		
		.ex_pc(ex_pc_i), .ex_aluop(ex_aluop_i),
		.ex_alufunct3(ex_alufunct3_i), .ex_alufunct7(ex_alufunct7_i),
		.ex_reg1(ex_reg1_i), .ex_reg2(ex_reg2_i), .ex_imm(ex_imm_i),
		.ex_wreg(ex_wreg_i), .ex_wd(ex_wd_i),
		
		.stall(stall)
	);
	
	ex ex0(
		.rst(rst),
		
		.pc_i(ex_pc_i), .aluop_i(ex_aluop_i),
		.alufunct3_i(ex_alufunct3_i), .alufunct7_i(ex_alufunct7_i),
		.reg1_i(ex_reg1_i), .reg2_i(ex_reg2_i), .imm_i(ex_imm_i),
		.wreg_i(ex_wreg_i), .wd_i(ex_wd_i),
		
		.aluop_o(ex_aluop_o), .alufunct3_o(ex_alufunct3_o),
		.me_o(ex_me_o), .maddr_o(ex_maddr_o), 
		.wreg_o(ex_wreg_o), .wd_o(ex_wd_o), .wdata_o(ex_wdata_o),
		
		.wreg_f(ex_wreg_f), .wd_f(ex_wd_f), .wdata_f(ex_wdata_f)
		
	);
 
	ex_mem ex_mem0(
		.clk(clk), .rst(rst),
		
		.ce(ram_ce_o),
		
		.ex_aluop(ex_aluop_o), .ex_alufunct3(ex_alufunct3_o),
		.ex_me(ex_me_o), .ex_maddr(ex_maddr_o),
		.ex_wreg(ex_wreg_o), .ex_wd(ex_wd_o), .ex_wdata(ex_wdata_o),
		
		.mem_aluop(mem_aluop_i), .mem_alufunct3(mem_alufunct3_i),
		.mem_me(mem_me_i), .mem_maddr(mem_maddr_i),	
		.mem_wd(mem_wd_i), .mem_wreg(mem_wreg_i), .mem_wdata(mem_wdata_i)
	);
	
	mem mem0(
		.rst(rst),
		
		.aluop_i(mem_aluop_i), .alufunct3_i(mem_alufunct3_i), 
		.me_i(mem_me_i), .maddr_i(mem_maddr_i),
		.wreg_i(mem_wreg_i), .wd_i(mem_wd_i), .wdata_i(mem_wdata_i),
		
		.re_m(ram_re_m), .rvalid_bit(ram_rvalid_bit), .raddr_m(ram_raddr_m), .rdata_m(ram_rdata_m),
		.we_m(ram_we_m), .wvalid_bit(ram_wvalid_bit), .waddr_m(ram_waddr_m), .wdata_m(ram_wdata_m),
		
		.wreg_o(mem_wreg_o), .wd_o(mem_wd_o), .wdata_o(mem_wdata_o),
		.wreg_f(mem_wreg_f), .wd_f(mem_wd_f), .wdata_f(mem_wdata_f)
	);
	
	mem_wb mem_wb0(
		.clk(clk), .rst(rst),
		
		.mem_wd(mem_wd_o), .mem_wreg(mem_wreg_o), .mem_wdata(mem_wdata_o),
		.wb_wd(wb_wd_o), .wb_wreg(wb_wreg_o), .wb_wdata(wb_wdata_o)
	);
	
endmodule