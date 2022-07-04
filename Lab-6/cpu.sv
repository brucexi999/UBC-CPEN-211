module cpu (clk, reset, s, load, in, out, N, V, Z, w);
	input clk, reset, s, load; 
	input [15:0] in;
	output [15:0] out;
	output N, V, Z, w; 
	
	logic [15:0] ins_out;
	
	reg_load (in, ins_out, load, clk); // Instantiate the instruction register. 
	
endmodule