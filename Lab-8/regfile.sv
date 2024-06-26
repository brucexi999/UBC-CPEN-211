module regfile (data_in, writenum, write, readnum, clk, data_out, reg_out);
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	input write, clk;
	output logic [15:0] data_out;
	logic [7:0] write_dec_out, read_dec_out, load;
	output logic [127:0] reg_out;
	
	decoder #(3,8) Dec1 (writenum, write_dec_out);
	decoder #(3,8) Dec2 (readnum, read_dec_out);
	
	genvar i; // Instansiate 8 registers. 
	
	generate 
		for (i = 0; i < 8; i = i + 1) begin: Regs
			reg_load #(16) Reg (.clk (clk), .load (load [i]), .a (data_in), .b (reg_out [((1+i)*16)-1 : i*16]));
		end
	endgenerate 
	
	mux_8in # (16) Mux (
	.sel (read_dec_out), 
	.b (data_out),
	.a0 (reg_out [15:0]),
	.a1 (reg_out [31:16]),
	.a2 (reg_out [47:32]),
	.a3 (reg_out [63:48]),
	.a4 (reg_out [79:64]),
	.a5 (reg_out [95:80]),
	.a6 (reg_out [111:96]),
	.a7 (reg_out [127:112])
	);
	
	always_comb begin // Make the AND gates. 
		load = write_dec_out & {8{write}};
	end
	
endmodule