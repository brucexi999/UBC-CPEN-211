module FSM (clk, rst, s, w, opcode, op, loada, loadb, loadc, asel, bsel, loads, write, vsel, nsel);
    input clk, rst, s;
    input [2:0] opcode;
    input [1:0] op;
    output logic w, loada, loadb, loadc, loads, asel, bsel, write;
    output logic [2:0] nsel;
    output logic [1:0] vsel;

    // The state machine that supports --1-- instruction.
    enum {
        idle, 
        decode,
        move_save 
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
                end

                move_save: // MOV Rn,#<im8>
                begin
                    nsel <= 3'b001;
                    write <= 1;
                    vsel <= 2'b10; 
                    state <= idle;
                end


            endcase 
        end

    end

endmodule 