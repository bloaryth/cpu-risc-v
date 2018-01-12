`timescale 1ns/1ps

module test_mod;
	
	reg[31:0] t;
	reg[31:0] m;
	reg clk;
	reg a;
	reg b;
	reg c;
	
	initial begin
		// ttime = 0;
		// t = 0;
		// m = 1;
		b = {reg1_i[31:1] + reg2_i[31:1] + {30{1'b0}, reg1_i[0] & reg2_i[0]}, 1'b0};
		a = 1'b0;
		clk = 1'b0;
		c = {{0{"1"}},1'b0};
		$display(c);
		forever #1 clk = ~clk;
		// clk <= 1'b1;
		// clk <= 1'b0;
	end
	
	always @ (posedge clk) begin
		// $display("t:");
		// $display(t);
		// $display("pre:");
		a <= ~a;
		// clk <= ~clk;
		// $display(a);
	end
	
	always @ (posedge clk) begin
		b <= a;
	end
	
	always @ (b) begin
		// c <= {0{"1"}};
		// t <= t + 1;
		// m = m * m * m * m * m * m; 
		// $display("a changed:");
		// $display(a);
		// $display(t);
		// clk <= ~clk;
	end
	
	// always @ (clk) begin
		// $display(clk);
	// end

endmodule