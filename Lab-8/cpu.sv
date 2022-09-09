module CPU (clk, reset, in, out, N, V, Z, w, mem_cmd, mem_addr);
	input clk, reset; 
	input [15:0] in;
	output logic [15:0] out;
	output logic N, V, Z, w;
	output logic [1:0] mem_cmd;  
	output logic [8:0] mem_addr; 
	
	logic [15:0] ins_out;
	logic [1:0] ALUop, shift, op, vsel, sel_pc, bsel;
	logic [15:0] sximm5, sximm8;
	logic [2:0] readnum, writenum, opcode, nsel, branch_condition;
	logic loada, loadb, loadc, loads, asel, write, load_pc, load_ir, addr_sel, load_addr;
	logic [8:0] pc_out, next_pc, data_addr_out, data_addr_in; 

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
		.op (op), 
		.branch_condition (branch_condition)
	);


	// The finite state machine. 
	FSM fsm (
		.clk (clk),
		.rst (reset),
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
		.addr_sel (addr_sel),
		.mem_cmd (mem_cmd),
		.load_addr (load_addr), 
		.Z (Z), 
		.V (V), 
		.N (N), 
		.branch_condition (branch_condition),
		.sel_pc (sel_pc)
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
		.mdata (in),
		.sximm8 (sximm8),
		.sximm5 (sximm5),
		.PC (pc_out[7:0]),
		.status_out ({Z, V, N}),
		.datapath_out (out)
	);

	// The program counter.
	always_ff @(posedge clk) begin
		if (load_pc) 
			pc_out <= next_pc; 
	end

	always_comb begin : pc_mux
		case (sel_pc)
			2'b00: next_pc = 9'b0;
			2'b01: next_pc = pc_out + 9'b000000001;
			2'b10: next_pc = out[8:0];  
			default: next_pc = 9'bz; 
		endcase
	end

	// Addr mux.
	always_comb begin : addr_mux
		case (addr_sel)
			1'b0: mem_addr = data_addr_out;
			1'b1: mem_addr = pc_out; 
			default: mem_addr = 9'bz; 
		endcase
	end

	// Data address register. 
	assign data_addr_in = out[8:0]; 

	always_ff @ (posedge clk) begin
		if (load_addr)
			data_addr_out <= data_addr_in; 
	end

	
endmodule