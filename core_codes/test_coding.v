module test(
	// input reg i,
	// output reg pc
);
	// reg pc;
	reg[31:0] a;
	reg b;
	
	initial begin
		a = 32'd0;
		// a = 1'b1;
		begin
		// a <= 32'd0;
		a <= 32'd1;
		a <= 32'd2;
		a <= 32'd3;
		a <= 32'd4;
		a <= 32'd5;
		a <= 32'd6;
		a <= 32'd7;
		a <= 32'd8;
		a <= 32'd9;
		end
		// #1;
		$display(a);
		// a <= 1'b0;
		// a <= 1'b1;
		// #1;
		// $display(b);
		// a <= ~a;
		// a <= ~a;
		// pc <= 1'b1;
		// pc <= 1'b0;
		// b = 1'b0;
		// $display(a);
		// $display(b);
	end

endmodule