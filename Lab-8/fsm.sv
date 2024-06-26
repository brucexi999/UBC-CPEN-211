module FSM (clk, rst, w, opcode, op, loada, loadb, loadc, asel, bsel, loads, write, vsel, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, Z, V, N, branch_condition, sel_pc, ALUop_zero);
    input clk, rst;
    input [2:0] opcode, branch_condition;
    input [1:0] op;
    input Z, V, N; 
    output logic w, loada, loadb, loadc, loads, write, load_pc, load_ir, addr_sel, load_addr, ALUop_zero;
    output logic [2:0] nsel;
    output logic [1:0] vsel, mem_cmd, asel, bsel, sel_pc;
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
        halt,
        // Lab 8 branch instructions, B just goes directly from decode to move_save, there is no flag-checking involved.
        BEQ, // Flag-checking states.
        BNE,
        BLT, 
        BLE,
        compute_branch_pc, 
        update_branch_pc,
        reload_branch_pc, 
        dummy2, 
        BL
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
                    asel <= 2'b0;
                    bsel <= 2'b0;
                    vsel <= 2'b0;
                    nsel <= 3'b0; 
                    addr_sel <= 0;
                    write <= 0; 
                    w <= 0;
                    ALUop_zero <= 0; 
                    sel_pc <= 2'b0;
                    load_pc <= 1;
                    load_ir <= 0;
                    load_addr <= 0;
                    mem_cmd <= 2'b00; // mem_cmd == 2'b10 as the command for nothing. Neither reading nor writing
                    state <= if1; 
                end

                if1:
                begin
                    loada <= 0;
                    loadb <= 0;
                    loadc <= 0;
                    loads <= 0;
                    asel <= 2'b0;
                    bsel <= 2'b0;
                    vsel <= 2'b0;
                    nsel <= 3'b0; 
                    write <= 0; 
                    w <= 0;
                    ALUop_zero <= 0; 
                    sel_pc <= 2'b01;
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
                    mem_cmd <= 2'b00; // mem_cmd == 2'b00 as the command for nothing. Neither reading nor writing. 
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
                    else if (opcode == 3'b111)
                        state <= halt;
                    else if ({opcode, branch_condition} == 6'b001000) // B
                        state <= compute_branch_pc;
                    else if ({opcode, branch_condition} == 6'b001001)
                        state <= BEQ;
                    else if ({opcode, branch_condition} == 6'b001010)
                        state <= BNE;
                    else if ({opcode, branch_condition} == 6'b001011)
                        state <= BLT;
                    else if ({opcode, branch_condition} == 6'b001100)
                        state <= BLE;
                    else if ({opcode, op} == 5'b01011)
                        state <= BL; 
                    else if ({opcode, op} == 5'b01000) // BX
                        state <= read_rd_load_b; 
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
                    bsel <= 2'b0;
                    asel <= 2'b01;
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
                    asel <= 2'b00;
                    bsel <= 2'b0;
                    loadc <= 1;
                    state <= feedback_save_rd;
                end

                sub_ab:
                begin
                    loada <= 0;
                    asel <= 2'b0;
                    bsel <= 2'b0;
                    loadc <= 1;
                    loads <= 1;
                    state <= if1;
                end

                add_a_sximm5:
                begin
                    loada <= 0;
                    asel <= 2'b0;
                    bsel <= 2'b01;
                    loadc <= 1;
                    state <= load_data_addr; 
                end

                load_data_addr:
                begin
                    loadc <= 0;
                    load_addr <= 1;
                    addr_sel <= 0;  
                    mem_cmd <= 2'b00; // At this cycle we don't send any meaningful mem_cmd. 
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
                    if ({opcode, op} == 5'b01000)
                        vsel <= 2'b11; 
                    state <= b_to_output;
                end

                b_to_output: // At this cycle, b is updated with the value in Rd. 
                begin
                    loadb <= 0;
                    asel <= 2'b01; // Select 16'b0 at Mux A, such that B is delivered directly to C. 
                    bsel <= 2'b0;
                    loadc <= 1;
                    if ({opcode, op} == 5'b01000)
                        state <= reload_branch_pc;
                    else 
                        state <= write_mem;
                end

                write_mem: // At this cycle, c is updaetd with the value in Rd. write_data to the memory is ready. At the same time we set addr_sel to 0 to provide the write address. And set mem_cmd to 2'b00 indicating a write. 
                begin
                    loadc <= 0;
                    addr_sel <= 0;
                    mem_cmd <= 2'b10;
                    state <= if1; 
                end 

                halt:
                begin
                    w <= 1; 
                    sel_pc <= 2'b0;
                    state <= halt;
                end
                
                compute_branch_pc: 
                begin
                    write <= 0;
                    asel <= 2'b10;
                    bsel <= 2'b10; 
                    state <= update_branch_pc;
                end

                update_branch_pc:
                begin
                    loadc <= 1;
                    state <= reload_branch_pc;
                end

                reload_branch_pc:
                begin
                    sel_pc <= 2'b10;
                    loadc <= 0;
                    load_pc <= 1;
                    state <= dummy2;
                end

                dummy2:
                begin
                    load_pc <= 0; 
                    state <= if1; 
                end

                BEQ:
                begin
                    if (Z == 1) 
                        state <= compute_branch_pc;
                    else 
                        state <= if1; 
                end

                BNE:
                begin
                    if (Z == 0) 
                        state <= compute_branch_pc;
                    else 
                        state <= if1;
                end

                BLT:
                begin
                    if (N != V)
                        state <= compute_branch_pc;
                    else 
                        state <= if1;
                end

                BLE:
                begin
                    if (N != V || Z == 1)
                        state <= compute_branch_pc;
                    else 
                        state <= if1; 
                end

                BL: // Save PC+1 to r7
                begin
                    vsel <= 2'b11; // Select PC for datapath input. 
                    write <= 1;
                    nsel <= 3'b001; // Select to write Rd. 
                    ALUop_zero <= 1;
                    state <= compute_branch_pc;
                end

            endcase 
        end

    end

endmodule 