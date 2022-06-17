module shifter ();
	input [15:0] in;
	input [1:0] shift;
	output [15:0] sout1;
	
	always_comb begin
		case (shift)
			2'b00: sout1 = in;
			2'b01: sout1 = in << 1;
			2'b10: sout1 = in >> 1;
			2'b11: sout1 = in >>> 1; // Shift to the right by conserving the "sign", i.e., in[15]. 
			default: sout1 = 16'bz; 
		endcase
	end
	
endmodule 