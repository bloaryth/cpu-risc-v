//regfile.v
`include "defs.v"

module regfile(
	// from risc-v.v
	input wire clk,
	input wire rst,
	
	// 写端口 --- from mem_wb.v 
	input wire we,
	input wire[`RegAddrBus] waddr,
	input wire[`RegBus]	wdata,
	
	// forwarding 1 --- from ex.v
	input wire ex_we,
	input wire[`RegAddrBus] ex_waddr,
	input wire[`RegBus] ex_wdata,
	
	// forwarding 2 --- from mem.v
	input wire mem_we,
	input wire[`RegAddrBus] mem_waddr,
	input wire[`RegBus] mem_wdata,
	
	// 读端口1 --- from id.v --- to id.v
	input wire re1,
	input wire[`RegAddrBus] raddr1,
	output reg rsuc1,
	output reg[`RegBus] rdata1,
	
	// 读端口2 --- from id.v --- to id.v
	input wire re2,
	input wire[`RegAddrBus] raddr2,
	output reg rsuc2,
	output reg[`RegBus] rdata2
	
);
	
	reg[`RegBus] regs[0:`RegNum-1];
	// 寄存器初始化
	integer i;
	initial begin
		for(i = 0; i < 32; i = i + 1)	begin
			regs[i] = 0;
		end
	end
	
	// 寄存器写回
	always @ (posedge clk) begin
		if(rst == `RstDisable) begin
			if(we == `WriteEnable && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end
		end
	end
	
	// 读出rs1的值
	always @ (*) begin
		if(rst == `RstEnable) begin
			rsuc1 <= `ReadFailed;
			rdata1 <= `ZeroWord;
		end
		else if(raddr1 == `RegNumLog2'h0) begin
			rsuc1 <= `ReadSucceed;
			rdata1 <= `ZeroWord;
		end
		else if((raddr1 == ex_waddr) && (re1 == `ReadEnable)) begin
			if(ex_we == `WriteEnable) begin
				rsuc1 <= `ReadSucceed;
				rdata1 <= ex_wdata;			
			end
			else begin
				rsuc1 <= `ReadFailed;
				rdata1 <= `ZeroWord;			// LOAD 指令 数据还没准备好	
			end
		end
		else if((raddr1 == mem_waddr) && (mem_we == `WriteEnable) && (re1 == `ReadEnable)) begin
			rsuc1 <= `ReadSucceed;
			rdata1 <= mem_wdata;
		end
		else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
			rsuc1 <= `ReadSucceed;
			rdata1 <= wdata;
		end 
		else if(re1 == `ReadEnable) begin
			rsuc1 <= `ReadSucceed;
			rdata1 <= regs[raddr1];
		end
		else begin
			// $display("hello?");
			rsuc1 <= `ReadFailed;
			rdata1 <= `ZeroWord;
		end
	end
	
	// 读出rs2的值
	always @ (*) begin
		if(rst == `RstEnable) begin
			rsuc2 <= `ReadFailed;
			rdata2 <= `ZeroWord;
		end
		else if(raddr2 == `RegNumLog2'h0) begin
			rsuc2 <= `ReadSucceed;
			rdata2 <= `ZeroWord;
		end
		else if((raddr2 == ex_waddr) && (ex_we == `WriteEnable) && (re2 == `ReadEnable)) begin
			if(ex_we == `WriteEnable) begin
				rsuc2 <= `ReadSucceed;
				rdata2 <= ex_wdata;			
			end
			else begin
				rsuc2 <= `ReadFailed;
				rdata2 <= `ZeroWord;			// LOAD 指令 数据还没准备好	
			end
		end
		else if((raddr2 == mem_waddr) && (mem_we == `WriteEnable) && (re2 == `ReadEnable)) begin
			rsuc2 <= `ReadSucceed;
			rdata2 <= mem_wdata;
		end
		else if((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin
			rsuc2 <= `ReadSucceed;
			rdata2 <= wdata;
		end 
		else if(re2 == `ReadEnable) begin
			rsuc2 <= `ReadSucceed;
			rdata2 <= regs[raddr2];
		end
		else begin
			// $display("hello?");
			rsuc2 <= `ReadFailed;
			rdata2 <= `ZeroWord;
		end
	end
	
endmodule