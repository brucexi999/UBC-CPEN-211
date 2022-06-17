module tb_alu ();
	logic [15:0] Ain, Bin, out;
	logic [1:0] ALUop;
	logic Z;
	
	alu dut (
	.Ain (Ain),
	.Bin (Bin),
	.ALUop (ALUop),
	.out (out),
	.Z (Z)
	);
	
	initial begin
		Ain = 'h0001; Bin = 'h0002; ALUop = 2'b00; #5;
		Bin = 'h0001; ALUop = 2'b01; #5;
		Ain = 'h1000; ALUop = 2'b10; #5;
		ALUop = 2'b11; #5;
	end
	
endmodule