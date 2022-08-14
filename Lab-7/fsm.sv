module FSM (clk, rst, w, opcode, op, loada, loadb, loadc, asel, bsel, loads, write, vsel, nsel, load_pc, load_ir, reset_pc, addr_sel, mem_cmd, load_addr);
    input clk, rst;
    input [2:0] opcode;
    input [1:0] op;
    output logic w, loada, loadb, loadc, loads, asel, bsel, write, load_pc, load_ir, reset_pc, addr_sel, load_addr;
    output logic [2:0] nsel;
    output logic [1:0] vsel, mem_cmd;

    // The state machine that supports --6-- instruction.
    enum {
        // Instruction 1
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
        sub_ab, 
        // Lab 7
        reset, 
        if1, 
        if2, 
        update_pc, 
        add_a_sximm5, 
        load_data_addr,
        get_mem_data,
        save_mem_rd, 
        read_rd_load_b, 
        b_to_output,
        write_mem, 
        halt
    } state;
    
    always_ff @ (posedge clk) begin
        if (rst)
            state <= reset;
        else begin
            case (state)
                reset: 
                begin
                    loada <= 0;
                    loadb <= 0;
                    loadc <= 0;
                    loads <= 0;
                    asel <= 0;
                    bsel <= 0;
                    vsel <= 2'b0;
                    nsel <= 3'b0; 
                    addr_sel <= 0;
                    write <= 0; 
                    w <= 1;
                    reset_pc <= 1;
                    load_pc <= 1;
                    load_ir <= 0;
                    load_addr <= 0;
                    mem_cmd <= 2'b10; // mem_cmd == 2'b10 as the command for nothing. Neither reading nor writing
                    state <= if1; 
                end

                if1:
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
                    reset_pc <= 0;
                    load_pc <= 0; 
                    addr_sel <= 1;
                    load_addr <= 0;
                    mem_cmd <= 2'b01; // mem_cmd == 2'b01 as the read command to memory.
                    state <= if2;
                end

                if2:
                begin
                    load_ir <= 1;
                    state <= update_pc;
                end

                update_pc:
                begin
                    load_pc <= 1; 
                    load_ir <= 0; 
                    mem_cmd <= 2'b10; // mem_cmd == 2'b10 as the command for nothing. Neither reading nor writing. 
                    state <= decode;
                end


                decode:
                begin
                    load_pc <= 0; 
                    w <= 0;
                    if ({opcode, op} == 5'b11010)
                        state <= move_save;
                    else if ({opcode, op} == 5'b01100 || {opcode, op} == 5'b10000)
                        state <= read_rn_load_a;
                    else 
                        state <= read_rm_load_b;
                end

                move_save: // MOV Rn,#<im8>
                begin
                    nsel <= 3'b001;
                    write <= 1;
                    vsel <= 2'b10; 
                    state <= if1;
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
                    state <= if1;
                end

                read_rn_load_a:
                begin
                    nsel <= 3'b001;
                    loada <= 1;
                    loadb <= 0;
                    if ({opcode,op} == 5'b10101)
                        state <= sub_ab;
                    else if ({opcode, op} == 5'b01100 || {opcode, op} == 5'b10000)
                        state <= add_a_sximm5; 
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
                    state <= if1;
                end

                add_a_sximm5:
                begin
                    loada <= 0;
                    asel <= 0;
                    bsel <= 1;
                    loadc <= 1;
                    state <= load_data_addr; 
                end

                load_data_addr:
                begin
                    loadc <= 0;
                    load_addr <= 1;
                    addr_sel <= 0;  
                    mem_cmd <= 2'b10; // At this cycle we don't send any meaningful mem_cmd. 
                    if ({opcode,op} == 5'b10000)
                        state <= read_rd_load_b;
                    else if ({opcode,op} == 5'b01100)
                        state <= get_mem_data; 
                end

                get_mem_data:
                begin
                    load_addr <= 0;
                    state <= save_mem_rd; 
                end

                save_mem_rd:
                begin
                    mem_cmd <= 2'b01; 
                    vsel <= 2'b01;
                    nsel <= 3'b010;
                    write <= 1;
                    state <= if1;
                end

                read_rd_load_b:
                begin
                    nsel <= 3'b010;
                    loadb <= 1;
                    load_addr <= 0; 
                    state <= b_to_output;
                end

                b_to_output: // At this cycle, b is updated with the value in Rd. 
                begin
                    loadb <= 0;
                    asel <= 1;
                    bsel <= 0;
                    loadc <= 1;
                    state <= write_mem;
                end

                write_mem: // At this cycle, c is updaetd with the value in Rd. write_data to the memory is ready. At the same time we set addr_sel to 0 to provide the write address. And set mem_cmd to 2'b00 indicating a write. 
                begin
                    loadc <= 0;
                    addr_sel <= 0;
                    mem_cmd <= 2'b00;
                    state <= if1; 
                end 

                halt:
                begin
                    reset_pc <= 1;
                    state <= halt;
                end
                
            endcase 
        end

    end

endmodule 