module cpu (clk, reset, s, load, in, out, N, V, Z, w);
	input clk, reset, s, load; 
	input [15:0] in;
	output logic [15:0] out;
	output logic N, V, Z, w; 
	
	logic [15:0] ins_out;
	logic [1:0] ALUop, shift, op, vsel;
	logic [15:0] sximm5, sximm8;
	logic [2:0] readnum, writenum, opcode, nsel;
	logic loada, loadb, loadc, loads, asel, bsel, write, load_pc, reset_pc;
	logic [8:0] pc_out, next_pc; 

	// The instruction register.
	reg_load ins_reg (
		.a (in), 
		.b (ins_out), 
		.load (load), 
		.clk (clk)
	);  
	
	// The instruction decoder.
	Ins_Dec ins_dec (
		.in (ins_out),
		.nsel (nsel),
		.ALUop (ALUop),
		.sximm5 (sximm5),
		.sximm8 (sximm8),
		.shift (shift),
		.readnum (readnum),
		.writenum (writenum),
		.opcode (opcode),
		.op (op)
	);


	// The finite state machine. 
	FSM fsm (
		.clk (clk),
		.rst (reset),
		.s (s),
		.w (w),
		.opcode (opcode),
		.op (op),
		.loada (loada),
		.loadb (loadb),
		.loadc (loadc),
		.loads (loads),
		.asel (asel),
		.bsel (bsel),
		.vsel (vsel),
		.nsel (nsel),
		.write (write)
	);

	// The datapath. 
	Datapath datapath (
		.clk (clk),
		.readnum (readnum),
		.vsel (vsel),
		.loada (loada),
		.loadb (loadb),
		.shift (shift),
		.asel (asel),
		.bsel (bsel),
		.ALUop (ALUop),
		.loadc (loadc),
		.loads (loads),
		.writenum (writenum),
		.write (write),
		.mdata (),
		.sximm8 (sximm8),
		.sximm5 (sximm5),
		.PC (),
		.status_out ({Z, V, N}),
		.datapath_out (out)
	);

	// The program counter.
	always_ff @(posedge clk) begin
		if(reset_pc) 
			pc_out <= 9'b0; 
		else if (load_pc) 
			pc_out <= next_pc; 
	end
	
	assign next_pc = pc_out + 1'b1; 

	

endmodule