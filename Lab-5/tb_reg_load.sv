module tb_reg_load ();
	logic [15:0] a, b;
	logic load, clk;
	
	reg_load # (16) dut (.a (a), .b (b), .load (load), .clk (clk));
	
	initial begin
		clk = 0; #5;
		forever begin
			clk = 1; #5;
			clk = 0; #5;
		end
	end
	
	initial begin
		load = 0; a = 'h0001; #5;
		load = 1; #5;
		load = 0; #5;
		a = 'h0002; load = 1; #5;
		load = 0; #5;
		$stop;
	end
endmodule