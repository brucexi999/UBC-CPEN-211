module decoder (a, b);
	parameter n = 3;
	parameter m = 8;
	
	input [n-1:0] a;
	output [m-1:0] b;
	
	assign b = 1 << a; 
endmodule 