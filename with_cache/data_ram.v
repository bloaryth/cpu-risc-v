// data_ram.v
`include "defs.v"

module data_ram(
	// from rsicv_min_sopc.v
	input wire ce,
	
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

);

	reg[7:0] data_mem[0:`DataMemNum-1];
	
	integer i;
	initial begin
		for(i = 0; i < `DataMemNum; i = i + 1) begin
			data_mem[i] = 8'h00;
		end
	end
	
	// 写操作
	always @ (*) begin
		if(ce == `ChipDisable) begin
			// data_O <= `ZeroWord;	
		end
		else if(we == `WriteEnable) begin	//存起来是小端序
			case(wvalid_bit)
				`Byte : begin
					data_mem[waddr] <= data_i[7:0];
					// $display("byte!");
				end
				`Half : begin
					data_mem[waddr] <= data_i[7:0];
					data_mem[waddr+1] <= data_i[15:8];
					// $display("half!");
				end
				`Word : begin
					data_mem[waddr] <= data_i[7:0];
					data_mem[waddr+1] <= data_i[15:8];
					data_mem[waddr+2] <= data_i[23:16];
					data_mem[waddr+3] <= data_i[31:24];
					// $display("word!");
				end
				default : begin
					// 什么也不做
				end
			endcase
			// $display("valid bit is == > %b", wvalid_bit);
			// $display("waddr == > %h", waddr);
			// $display("data_i == > %h", data_i);
			// $display("data_mem == > %h", data_mem[waddr]);
			// $display("data_mem[ %h ] == %h", waddr, data_mem[waddr]);
			// data_mem[waddr] <= {data_i[7:0], data_i[15:8], data_i[23:16], data_i[31:24]};		// CPU是大端序, 只有在内存里才是小端序
		end
	end

	// 读操作
	always @ (*) begin
		if(ce == `ChipDisable) begin
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
			endcase
			// data_o <= {data_mem[raddr][7:0],data_mem[raddr][15:8],data_mem[raddr][23:16],data_mem[raddr][31:24]}; // CPU是大端序, 只有在内存里才是小端序
		end
		else begin
			data_o <= `ZeroWord;
		end
	end

endmodule