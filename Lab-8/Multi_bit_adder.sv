module Mubi_adder (a, b, cin, cout, s);
	parameter n = 8;
	input [n-1:0] a, b;
	input cin;
	output logic [n-1:0] s;
	output logic cout;
	
	assign {cout, s} = a + b + cin; 
	
endmodule 