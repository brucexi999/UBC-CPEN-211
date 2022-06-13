module tb_decoder ();
	logic [2:0] a;
	logic [7:0] b;
	
	decoder # (3,8) dut (a, b);
	
	initial begin
	a = 3'b000; #5;
	a = 3'b001; #5;
	a = 3'b010; #5;
	a = 3'b011; #5;
	a = 3'b100; #5;
	a = 3'b101; #5;
	a = 3'b110; #5;
	a = 3'b111; #5;
	a = 3'b000; #5;
	end
	
endmodule