module tb_datapath ();
	logic clk, vsel, loada, loadb, asel, bsel, loadc, loads, write, Z_out;
	logic [2:0] readnum, writenum;
	logic [15:0] datapath_in, datapath_out; 
	logic [1:0] ALUop, shift;
	
	datapath dut (clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
				writenum, write, datapath_in, Z_out, datapath_out);
				
	initial begin
		clk = 0; #5；
		forever begin
			clk = 1; #5;
			clk = 0; #5; 
		end
	end
	
	initial begin
		#5;
		vsel = 1; datapath_in = 'h0007; write = 1; writenum = 3'b0; #10; // MOV R0, #7 ; this means, take the absolute number 7 and store it in R0.
		datapath_in = 'h0002; writenum = 3'b001; #10; // MOV R1, #2 ; this means, take the absolute number 2 and store it in R1.
		write = 0; readnum = 3'b0; loada = 1; #10; //ADD R2, R1, R0, LSL#1 ; this means R2 = R1 + (R0 shifted left by 1) = 2+14=16
		readnum = 3'b001; loada = 0; loadb = 1; #10; 
		asel = 0; shift = 2'b01; bsel = 0; ALUop = 2'b0; loadc = 1; loads = 1; loadb = 0; #10; 
		vsel = 0; write = 1; writenum = 3'b010; #10; 
		write = 0; readnum = 3'b010; #10; 
		
	
	
	
		$stop;
	end
endmodule

