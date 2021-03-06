module tb_Ins_Dec ();
	
	logic [15:0] in; 
	logic [2:0] nsel; 
	logic [1:0] ALUop, shift, op; 
	logic [15:0] sximm5, sximm8; 
	logic [2:0] readnum, writenum, opcode;
	
	/*logic [2:0] Rn, Rd, Rm, mux_out; 
	logic [4:0] imm5; 
	logic [7:0] imm8;*/
	
	Ins_Dec dut (in, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, opcode, op); 
	
	initial begin 
		nsel = 3'b001; in[7:0] = 8'b00100001; #5;
		nsel = 3'b010; in[7:0] = 8'b10100001; #5;
		in = 'h1234; #5; 
	end
endmodule