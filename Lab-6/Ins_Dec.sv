module Ins_Dec (in, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, opcode, op);
	
	input [15:0] in; 
	input [2:0] nsel; 
	output logic [1:0] ALUop, shift, op; 
	output logic [15:0] sximm5, sximm8; 
	output logic [2:0] readnum, writenum, opcode;
	
	logic [2:0] Rn, Rd, Rm, mux_out; 
	logic [4:0] imm5; 
	logic [7:0] imm8; 
	
	assign Rm = in[2:0]; 
	assign Rd = in[7:5];
	assign Rn = in[10:8];
	assign shift = in[4:3];
	assign imm8 = in[7:0];
	assign imm5 = in[4:0];
	assign ALUop = in[12:11];
	assign op = in[12:11];
	assign opcode = in[15:13]; 
	assign readnum = mux_out;
	assign writenum = mux_out;
	
	// nsel Mux
	always_comb begin
		case (nsel)
			3'b001: 
				mux_out = Rm;

			3'b010: 
				mux_out = Rd;
				
			3'b100: 
				mux_out = Rn; 
		endcase
	end
	
	assign sximm5 = imm5 >>> 11; 
	assign sximm8 = imm8 >>> 8; 
	
endmodule