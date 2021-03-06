module mux_8in (a0, a1, a2, a3, a4, a5, a6, a7, sel, b);
	parameter k = 16; 
	
	input [k-1:0] a0, a1, a2, a3, a4, a5, a6, a7; 
	input [7:0] sel;
	output [k-1:0] b;
	
	
	assign b = ({k{sel[0]}} & a0) |
			 ({k{sel[1]}} & a1) |
			 ({k{sel[2]}} & a2) |
			 ({k{sel[3]}} & a3) |
			 ({k{sel[4]}} & a4) |
			 ({k{sel[5]}} & a5) |
			 ({k{sel[6]}} & a6) |
			 ({k{sel[7]}} & a7) ;
	
endmodule  