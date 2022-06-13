module reg_load (a, b, load, clk);
	parameter n = 16;
	
	input [n-1:0] a;
	input load, clk;
	output [n-1:0] b;
	
	always @ (posedge clk) begin
		if (load) 
			b <= a;
	end

endmodule