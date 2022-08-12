module tb_FSM  ();
    logic clk, rst;
    logic [2:0] opcode;
    logic [1:0] op;
    logic w, loada, loadb, loadc, loads, asel, bsel, write, load_pc, load_ir, reset_pc, addr_sel, load_addr;
    logic [2:0] nsel;
    logic [1:0] vsel, mem_cmd;

    FSM dut (clk, rst, w, opcode, op, loada, loadb, loadc, asel, bsel, loads, write, vsel, nsel, load_pc, load_ir, reset_pc, addr_sel, mem_cmd, load_addr);

    initial begin
        clk = 0; #5;
        forever begin
            clk = 1; #5; 
            clk = 0; #5;
        end
    end


    initial begin
        #5;

        rst = 1; #20; 
        rst = 0; /*opcode = 3'b110; op = 2'b10; #200;*/ 

        //STR
        {opcode, op} = 5'b10000; #200; 

        //LDR
        {opcode, op} = 5'b01100; #200; 

        $stop; 
    end
endmodule