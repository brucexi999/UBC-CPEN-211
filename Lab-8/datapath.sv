module Datapath (clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
				writenum, write, mdata, sximm8, PC, sximm5, status_out, datapath_out, reg_out);
	input clk;
	input [2:0] readnum, writenum;
	input loada, loadb,  loadc, loads, write;
	input [1:0] ALUop, shift, vsel, asel, bsel; 
 	input [15:0] mdata, sximm8, sximm5;
	input [7:0] PC;
	output logic [2:0] status_out;
	output logic [15:0] datapath_out;
	output logic [127:0] reg_out; 

	logic [15:0] data_in, data_out, a_out, b_out, ALU_out, sout, Ain, Bin;
	logic Z, V, N; 
	
	// Mux #9
	always_comb begin
		case (vsel)
			2'b00: data_in = datapath_out;
			2'b01: data_in = mdata;
			2'b10: data_in = sximm8;
			2'b11: data_in = {8'b0, PC};
			default: data_in = 16'bz; 
		endcase
	end
	
	// Registers
	regfile RF (data_in, writenum, write, readnum, clk, data_out, reg_out);
	
	// Register #3, #4, #5, #10
	reg_load #(16) REG_A (data_out, a_out, loada, clk);  
	reg_load #(16) REG_B (data_out, b_out, loadb, clk);
	reg_load #(16) REG_C (ALU_out, datapath_out, loadc, clk);
	reg_load #(3) REG_S ({Z, V, N}, status_out, loads, clk); // The status register. 
	
	// Shifter
	shifter SF (b_out, shift, sout); 
	
	// Mux #6
	always_comb begin
		case (asel)
			2'b00: Ain = a_out;
			2'b01: Ain = 16'b0;
			2'b10: Ain = {8'b0, PC};
			default: Ain = 16'bz; 
		endcase
	end

	// Mux #7
	always_comb begin
		case (bsel)
			2'b00: Bin = sout;
			2'b01: Bin = sximm5;
			2'b10: Bin = sximm8; 
			default: Bin = 16'bz; 
		endcase
	end
	
	// ALU
	alu ALU (Ain, Bin, ALUop, ALU_out, Z, V, N);
	
	
endmodule