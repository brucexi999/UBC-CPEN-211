module tb_shifter ();
	logic [15:0] in;
	logic [1:0] shift;
	logic [15:0] sout;
	
	shifter dut (
	in, 
	shift,
	sout
	);
	
	initial begin
		in = 'hf001; shift = 2'b00; #5;
		shift = 2'b01; #5;
		shift = 2'b10; #5;
		shift = 2'b11; #5;
	end
	
endmodule 