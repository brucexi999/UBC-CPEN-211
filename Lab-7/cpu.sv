module CPU (clk, reset, s, in, out, N, V, Z, w, mem_cmd);
	input clk, reset, s; 
	input [15:0] in;
	output logic [15:0] out;
	output logic N, V, Z, w;
	output logic [1:0] mem_cmd;  
	
	logic [15:0] ins_out;
	logic [1:0] ALUop, shift, op, vsel;
	logic [15:0] sximm5, sximm8;
	logic [2:0] readnum, writenum, opcode, nsel;
	logic loada, loadb, loadc, loads, asel, bsel, write, load_pc, reset_pc, load_ir, addr_sel;
	logic [8:0] pc_out, next_pc, mem_addr; 

	// The instruction register.
	reg_load ins_reg (
		.a (in), 
		.b (ins_out), 
		.load (load_ir), 
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
		.write (write),
		.load_ir (load_ir),
		.load_pc (load_pc),
		.reset_pc (reset_pc),
		.addr_sel (addr_sel),
		.mem_cmd (mem_cmd)
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
		if (load_pc) 
			pc_out <= next_pc; 
	end

	always_comb begin : pc_mux
		case (reset_pc)
			1'b0: next_pc = pc_out + 1'b1;
			1'b1: next_pc = 9'b0;  
			default: next_pc = 9'bz; 
		endcase
	end
	
	assign  

	// Addr mux.
	always_comb begin : addr_mux
		case (addr_sel)
			1'b0: mem_addr = 9'b0;
			1'b1: mem_addr = pc_out; 
			default: mem_addr = 9'bz; 
		endcase
	end

	
endmodule