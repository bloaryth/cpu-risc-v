//cache.v
`include "defs.v"

// write-through not allocate
module cache(
	// from pc_reg.v
	input wire cache_ce,
	
	// 写操作 from mem.v
	input wire we,
	input wire[`ValidBitBus] wvalid_bit,
	input wire[`DataAddrBus] waddr,
	input wire[`DataBus] data_i,

	// 读操作 from mem.v
	input wire re,
	input wire[`ValidBitBus] rvalid_bit,
	input wire[`DataAddrBus] raddr,
	output reg[`DataBus] data_o,
	
	// miss	
	output reg miss,
	output reg[`DataAddrBus] miss_addr,
	// input wire rewrite_e,						//rewrite enable
	input wire[`CacheBus] rewrite_data
);
	
	reg Pres[`PowIndexBus];
	reg[`TagBus] Tags[`PowIndexBus];
	reg[`CacheBus] data_cache[`PowIndexBus];
	
	reg[`TagBus] rtag;
	reg[`IndexBus] rindex;
	reg[`SelectBus] rselect;
	
	reg[`TagBus] wtag;
	reg[`IndexBus] windex;
	reg[`SelectBus] wselect;
	
	// 初始清空Pres
	integer i;
	initial begin
		for(i = 0; i < 1024; i = i + 1) begin
			Pres[i] = `NotPresent;
		end
	end
	
	// 解析读所用数据
	always @(*) begin
		rtag <= raddr[31:12];
		rindex <= raddr[11:2];
		rselect <= raddr[1:0];
	end
	
	// 读操作
	always @ (*) begin
		if(cache_ce == `ChipDisable) begin
			data_o <= `ZeroWord;
		end
		else if((raddr == waddr) && (we == `WriteEnable) && (re == `ReadEnable)) begin
			data_o <= {data_i[7:0],data_i[15:8],data_i[23:16],data_i[31:24]};
		end
		else if(re == `ReadEnable) begin
			if(Pres[rindex] == `NotPresent) begin
				miss = `Miss;
				miss_addr <= raddr;		
			end
			else begin
				if(Tags[rindex] == rtag) begin
					case(rvalid_bit)
						`Byte : begin
							case(rselect)
								2'b00 : data_o <= {{24{1'b0}}, data_cache[rindex][7:0]};
								2'b01 : data_o <= {{24{1'b0}}, data_cache[rindex][15:8]};
								2'b10 : data_o <= {{24{1'b0}}, data_cache[rindex][23:16]};
								2'b11 : data_o <= {{24{1'b0}}, data_cache[rindex][31:24]};
							endcase
						end
						`Half : begin
							case(rselect)
								2'b00 : data_o <= {{16{1'b0}}, data_cache[rindex][7:0],data_cache[rindex][15:8]};
								// 2'b01 : data_o <= {{16{1'b0}}, data_cache[rindex][15:8],data_cache[rindex][7:0]};
								2'b10 : data_o <= {{16{1'b0}}, data_cache[rindex][23:16],data_cache[rindex][31:24]};
								// 2'b11 : data_o <= {{16{1'b0}}, data_cache[rindex][15:8],data_cache[rindex][7:0]};
							endcase
						end
						`Word : begin
							data_o <= {data_cache[rindex][7:0], data_cache[rindex][15:8], data_cache[rindex][23:16],data_cache[rindex][31:24]};
						end
						default begin
							
						end
					endcase			 // CPU是大端序, 只有在内存里才是小端序
				end
				else begin
					miss = `Miss;
					miss_addr <= raddr;
				end
			end
		end
		else begin
		
		end
	end	
	
	// miss后写回数据
	always @ (*) begin
			data_cache[rindex] <= rewrite_data;
			Tags[rindex] <= rtag;
			Pres[rindex] <= `Present;
	end
	
	// 解析写操作所用数据
	always @(*) begin
		wtag <= waddr[31:12];
		windex <= waddr[11:2];
		wselect <= waddr[1:0];		
	end
	
	// 写操作
	always @ (*) begin
		if(cache_ce == `ChipDisable) begin
			// data_o <= `ZeroWord;
		end
		else if(we == `WriteEnable) begin			
			Pres[windex[11:2]] <= `NotPresent;		// not allocate
		end
		else begin
			
		end
	end

endmodule