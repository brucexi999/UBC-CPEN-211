module FSM (clk, rst, s, w, opcode, op, loada, loadb, loadc, asel, bsel, loads, write, vsel, nsel, load_pc, load_ir, reset_pc, addr_sel, mem_cmd);
    input clk, rst, s;
    input [2:0] opcode;
    input [1:0] op;
    output logic w, loada, loadb, loadc, loads, asel, bsel, write, load_pc, load_ir, reset_pc, addr_sel;
    output logic [2:0] nsel;
    output logic [1:0] vsel mem_cmd;

    // The state machine that supports --6-- instruction.
    enum {
        // Instruction 1
        idle, 
        decode,
        move_save,
        // Instruction 2, 6
        read_rm_load_b,
        shift_b,
        feedback_save_rd,
        // Instruciton 3, 5
        read_rn_load_a,
        add_and_ab,
        // Instruction 4
        sub_ab
    } state;
    
    always_ff @ (posedge clk) begin
        if (rst)
            state <= idle;
        else begin
            case (state)
                idle: 
                begin
                    loada <= 0;
                    loadb <= 0;
                    loadc <= 0;
                    loads <= 0;
                    asel <= 0;
                    bsel <= 0;
                    vsel <= 2'b0;
                    nsel <= 3'b0; 
                    write <= 0; 
                    w <= 1;
                    if (s)
                        state <= decode;
                end

                decode:
                begin
                    w <= 0;
                    if (opcode == 3'b110 && op == 2'b10)
                        state <= move_save;
                    else 
                        state <= read_rm_load_b;
                end

                move_save: // MOV Rn,#<im8>
                begin
                    nsel <= 3'b001;
                    write <= 1;
                    vsel <= 2'b10; 
                    state <= idle;
                end

                read_rm_load_b:
                begin
                    nsel <= 3'b100;
                    loadb <= 1;
                    if ({opcode, op} == 5'b11000 || {opcode, op} == 5'b10111)
                        state <= shift_b;
                    else 
                        state <= read_rn_load_a;
                end

                shift_b:
                begin
                    loadb <= 0;
                    bsel <= 0;
                    asel <= 1;
                    loadc <= 1;
                    state <= feedback_save_rd;
                end

                feedback_save_rd:
                begin
                    vsel <= 2'b0;
                    nsel <= 3'b010;
                    write <= 1;
                    loadc <= 0;
                    state <= idle;
                end

                read_rn_load_a:
                begin
                    nsel <= 3'b001;
                    loada <= 1;
                    loadb <= 0;
                    if ({opcode,op} == 5'b10101)
                        state <= sub_ab;
                    else
                        state <= add_and_ab;
                end

                add_and_ab:
                begin
                    loada <= 0;
                    asel <= 0;
                    bsel <= 0;
                    loadc <= 1;
                    state <= feedback_save_rd;
                end

                sub_ab:
                begin
                    loada <= 0;
                    asel <= 0;
                    bsel <= 0;
                    loadc <= 1;
                    loads <= 1;
                    state <= idle;
                end
            endcase 
        end

    end

endmodule 