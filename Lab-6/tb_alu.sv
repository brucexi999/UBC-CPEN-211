module tb_alu ();
	logic [15:0] Ain, Bin, out;
	logic [1:0] ALUop;
	logic Z, V, N;
	
	alu dut (
	.Ain (Ain),
	.Bin (Bin),
	.ALUop (ALUop),
	.out (out),
	.Z (Z),
	.V (V), 
	.N (N)
	);
	
	initial begin
		#5; 
		Ain = 16'b0111111111111111; Bin = 'h0001; ALUop = 2'b00; #5;
		Ain = 16'b0011111111111111; Bin = 'h0001; ALUop = 2'b00; #5;
		Ain = 16'b1000000000000000; Bin = 'h0001; ALUop = 2'b01; #5;
		Ain = 'h000f; Bin = 'h000f; ALUop = 2'b01; #5;
		Ain = 'h0002; Bin = 'h0001; ALUop = 2'b01; #5;
		Ain = 'h1000; ALUop = 2'b10; #5;
		ALUop = 2'b11; #5;
	end
	
endmodule