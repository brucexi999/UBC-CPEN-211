module tb_regfile ();

	logic [15:0] data_in, data_out;
	logic [2:0] writenum, readnum;
	logic write, clk; 
	
	regfile dut (
	.data_in (data_in),
	.writenum (writenum),
	.write (write),
	.readnum (readnum),
	.clk (clk),
	.data_out (data_out)
	);
	
	initial begin
		clk = 0; #5;
		forever begin
			clk = 1; #5;
			clk = 0; #5;
		end
	end
	
	initial begin
		write = 1; writenum = 3'b001; data_in = 'h0006; #10;
		write = 0; readnum = 3'b001; #10;
		write = 1; writenum = 3'b010; data_in = 'h0004; #10;
		write = 0; readnum = 3'b010; #10;
	$stop;
	end


endmodule