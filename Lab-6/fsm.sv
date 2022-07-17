module FSM (clk, rst, s, w, opcode, op, loada, loadb, loadc, asel, bsel, loads, write, vsel, nsel);
    input clk, rst, s;
    input [2:0] opcode;
    input [1:0] op;
    output logic w, loada, loadb, loadc, loads, asel, bsel, write;
    output logic [2:0] nsel;
    output logic [1:0] vsel;

    // The state machine that supports --2-- instruction.
    enum {
        // Instruction 1
        idle, 
        decode,
        move_save,
        // Instruction 2
        read_rm_load_b,
        shift_b,
        feedback_save_rd
    } state;
    
    always_ff @ (posedge clk) begin
        if (rst)
            state <= idle;
        else begin
            case (state)
                idle: 
                begin
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
                    else if (opcode == 3'b110 && op == 2'b00)
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
                    nsel <= 3'b0;
                    loadb <= 1;
                    state <= shift_b;
                end

                shift_b:
                begin
                    loadb <= 0;
                    bsel <= 0;
                    asel <= 1;
                    loadc <= 1;
                    loads <= 1;
                    state <= feedback_save_rd;
                end

                feedback_save_rd:
                begin
                    vsel <= 2'b0;
                    nsel <= 3'b010;
                    write <= 1;
                    state <= idle;
                end





            endcase 
        end

    end

endmodule 