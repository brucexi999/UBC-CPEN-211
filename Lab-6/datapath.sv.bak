module datapath (clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
				writenum, write, datapath_in, Z_out, datapath_out);
	input clk;
	input [2:0] readnum, writenum;
	input vsel, loada, loadb, asel, bsel, loadc, loads, write;
	input [1:0] ALUop, shift; 
 	input [15:0] datapath_in;
	output Z_out;
	output [15:0] datapath_out;
	
	logic [15:0] data_in, data_out, a_out, b_out, ALU_out, sout, Ain, Bin;
	logic Z; 
	
	// Mux #9
	always_comb begin
		case (vsel)
			1'b1: data_in = datapath_in;
			1'b0: data_in = datapath_out;
			default: data_in = 16'bz; 
		endcase
	end
	
	// Registers
	regfile RF (data_in, writenum, write, readnum, clk, data_out);
	
	// Register #3, #4, #5, #10
	reg_load #(16) REG_A (data_out, a_out, loada, clk);  
	reg_load #(16) REG_B (data_out, b_out, loadb, clk);
	reg_load #(16) REG_C (ALU_out, datapath_out, loadc, clk);
	reg_load #(1) REG_S (Z, Z_out, loads, clk);
	
	// Shifter
	shifter SF (b_out, shift, sout); 
	
	// Mux #6
	always_comb begin
		case (asel)
			1'b0: Ain = a_out;
			1'b1: Ain = 16'b0;
			default: Ain = 16'bz; 
		endcase
	end

	// Mux #7
	always_comb begin
		case (bsel)
			1'b0: Bin = sout;
			1'b1: Bin = {11'b0, datapath_in[4:0]};
			default: Bin = 16'bz; 
		endcase
	end
	
	// ALU
	alu ALU (Ain, Bin, ALUop, ALU_out, Z);
	
	
endmodule