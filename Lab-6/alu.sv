module alu (Ain, Bin, ALUop, out, Z, V, N);
	input [15:0] Ain, Bin;
	input [1:0] ALUop;
	output logic [15:0] out;
	output logic Z, V, N; // If out == 0, Z = 1; overflow, V = 1; out[15] == 1; N = 1
	
	logic [15:0] add_sub_out, and_out, notB_out; // Output of different arithematic modules, the mux will choose one of the three based on ALUop_1hot
	logic [3:0] ALUop_1hot; // One-hot format of ALUop, output of the decoder
	
	AddSubOvf #(16) add_sub_ovf (
	.a (Ain), 
	.b (Bin), 
	.sub (ALUop_1hot[1]), 
	.s (add_sub_out), 
	.ovf (V)
	);
	
	assign and_out = Ain & Bin;
	assign notB_out = ~Bin;
	assign N = out[15]; 
	assign Z = ~(out == 16'b0); 
	
	decoder #(2, 4) dec (.a(ALUop), .b(ALUop_1hot)); 
	
	always_comb begin
		case (ALUop_1hot)
			4'b0001: out = add_sub_out;
			4'b0010: out = add_sub_out;
			4'b0100: out = and_out;
			4'b1000: out = notB_out;
			default: out = 16'bz; 
		endcase
	end
	
endmodule