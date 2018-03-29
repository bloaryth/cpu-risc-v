//rom_ram.v
`include "defs.v"

module rom_ram(
	// from pc_reg.v
	input wire rom_ce,
	input wire[`InstAddrBus] addr,
	
	// to ctrl.v
	output reg stall_req,
	
	// to if_id.v
	output reg[`InstBus] inst,

	// from rsicv_min_sopc.v
	input wire ram_ce,
	
	// 写端口 --- from ( mem.v -> risc-v.v)
	input wire we,
	input wire[`ValidBitBus] wvalid_bit,
	input wire[`DataAddrBus] waddr,
	input wire[`DataBus] data_i,
	
	// 读端口 --- from ( mem.v -> risc-v.v ) --- to ( risc-v.v -> mem.v )
	input wire re,
	input wire[`ValidBitBus] rvalid_bit,
	input wire[`DataAddrBus] raddr,
	output reg[`DataBus] data_o	
	
	// cache miss

);
	reg[7:0] data_mem[0:`DataMemNum-1];

	initial begin
		// $readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\jal_alupc.data", inst_mem);	
		// $readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\jal_alupc.data", inst_mem);	
		// $readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\jal_alupc.data", inst_mem);	
		// $readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\shifts.data", inst_mem);	
		$readmemh("D:\\Coding\\cpu-risc-v\\inst_test\\helloworld.s", data_mem);	
	end
	
	always @ (*) begin
		if(rom_ce == `ChipDisable)  begin
			inst <= `NopInst;
			stall_req <= `Continue;
		end
		else begin
			if(we == `WriteEnable) begin	// 写操作就stall住不读指令
				stall_req <= `Stop;
			end
			else begin
				stall_req <= `Continue;
				inst <= {data_mem[addr + 3], data_mem[addr + 2], data_mem[addr + 1], data_mem[addr]};
			end
		end
	end

	// 写操作
	always @ (*) begin
		if(ram_ce == `ChipDisable) begin
			// data_O <= `ZeroWord;	
		end
		else if(we == `WriteEnable) begin	//存起来是小端序
			case(wvalid_bit)
				`Byte : begin
					data_mem[waddr] <= data_i[7:0];
				end
				`Half : begin
					data_mem[waddr] <= data_i[7:0];
					data_mem[waddr+1] <= data_i[15:8];
				end
				`Word : begin
					data_mem[waddr] <= data_i[7:0];
					data_mem[waddr+1] <= data_i[15:8];
					data_mem[waddr+2] <= data_i[23:16];
					data_mem[waddr+3] <= data_i[31:24];
				end
				default : begin
					// 什么也不做
				end
			endcase
			$display("mem_wdata -> %c", data_i[7:0]);
		end
	end

	// 读操作
	always @ (*) begin
		if(ram_ce == `ChipDisable) begin
			data_o <= `ZeroWord;
		end
		else if((raddr == waddr) && (we == `WriteEnable) && (re == `ReadEnable)) begin
			data_o <= data_i;
		end
		else if(re == `ReadEnable) begin	//读出来是大端序
			case(rvalid_bit)
				`Byte : begin
					data_o <= {{24{1'b0}}, data_mem[raddr]};
				end
				`Half : begin
					data_o <= {{16{1'b0}}, data_mem[raddr+1],data_mem[raddr]};
				end
				`Word : begin
					data_o <= {data_mem[raddr+3],data_mem[raddr+2],data_mem[raddr+1],data_mem[raddr]};
				end
			endcase			 // CPU是大端序, 只有在内存里才是小端序
		end
		else begin
			data_o <= `ZeroWord;
		end
	end	

endmodule