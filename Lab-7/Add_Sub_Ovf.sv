module AddSubOvf (a, b, sub, s, ovf);
	parameter n = 8;
	input [n-1:0] a, b;
	input sub; // Do subtraction if sub = 1, otherwise addition
	output logic [n-1:0] s;
	output logic ovf; // ovf = 1 if overflow occurs 
	logic c1, c2; // Carry in and out of the last (n-1) bit
	
	assign ovf = c1 ^ c2;  // If the carry in and out of the last bit differ, then overflow
	
	Mubi_adder # (1) as (a[n-1],b[n-1]^sub, c1, c2, s[n-1]); // Add(subtract) the last (sign) bit. 
	Mubi_adder # (n-1) ai (a[n-2:0], b[n-2:0]^{n-1{sub}}, sub, c1, s[n-2:0]); // Add the rest non-sign bits.
	
endmodule