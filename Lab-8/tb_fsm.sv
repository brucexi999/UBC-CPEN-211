module tb_fsm (
);  
    logic clk, rst;
    logic [2:0] opcode, branch_condition;
    logic [1:0] op;
    logic Z, V, N; 
    logic w, loada, loadb, loadc, loads, asel, write, load_pc, load_ir, reset_pc, addr_sel, load_addr, sel_pc;
    logic [2:0] nsel;
    logic [1:0] vsel, mem_cmd, bsel; 

    FSM dut (clk, rst, w, opcode, op, loada, loadb, loadc, asel, bsel, loads, write, vsel, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, Z, V, N, branch_condition, sel_pc); 

    initial begin
        forever begin
            clk = 0; #5;
            clk = 1; #5;
    end
    end
    
    initial begin
        /*rst = 1; #20;
        rst = 0; opcode = 3'b001; branch_condition = 3'b0; #100; // B (unconditioned)
        
        rst = 1; #20;
        rst = 0; opcode = 3'b001; branch_condition = 3'b001; Z= 1; #150; // BEQ

        rst = 1; #20;
        rst = 0; opcode = 3'b001; branch_condition = 3'b001; Z= 0; #150; // BEQ*/

        // BNE passed. 

        rst = 1; #20;
        rst = 0; opcode = 3'b010; op = 2'b11; #200; // BL

        rst = 1; #20;
        rst = 0; opcode = 3'b010; op = 2'b0; #200; // BL



        $stop; 
    end

endmodule