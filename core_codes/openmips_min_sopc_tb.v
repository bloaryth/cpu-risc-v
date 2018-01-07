//openmips_min_sopc_tb.v
`include "defs.v"
`include "openmips_min_sopc.v"
`timescale 1ns/1ps

module openmips_min_sopc_tb();

	reg total_clock;
	reg CLOCK_50;
	reg rst;
	reg hh;	
  
       
	initial begin
		total_clock = 32'h00000000;
		CLOCK_50 = 1'b0;
		forever begin
			#10 CLOCK_50 = ~CLOCK_50;
			total_clock = total_clock + 1;
		end
	end
      
  initial begin
    rst = `RstEnable;
    // #195 rst= `RstDisable;
    #1000 $finish;
  end
       
  openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);

endmodule