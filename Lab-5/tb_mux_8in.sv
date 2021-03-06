module tb_mux_8in ();
	
	logic [15:0] a0, a1, a2, a3, a4, a5, a6, a7, b;
	logic [7:0] sel; 
	
	mux_8in # (16) dut (
	a0, a1, a2, a3, a4, a5, a6, a7, sel, b
	);
	
	initial begin
		a0 = 'h0000; a1 = 'h0001; a2 = 'h0002; a3 = 'h0003;
		a4 = 'h0004; a5 = 'h0005; a6 = 'h0006; a7 = 'h0007;
		sel = 8'b00000001; #5;
		sel = 8'b00000010; #5;
		sel = 8'b00000100; #5;
		sel = 8'b00001000; #5;
		sel = 8'b00010000; #5;
		sel = 8'b00100000; #5;
		sel = 8'b01000000; #5;
		sel = 8'b10000000; #5;
	end
	
endmodule 