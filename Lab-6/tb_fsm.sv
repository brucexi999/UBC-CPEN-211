module tb_FSM ();

    logic clk, rst, s;
    logic [2:0] opcode;
    logic [1:0] op;
    logic w, loada, loadb, loadc, loads, asel, bsel, write;
    logic [2:0] nsel;
    logic [1:0] vsel;

    FSM dut (clk, rst, s, w, opcode, op, loada, loadb, loadc, asel, bsel, loads, write, vsel, nsel);

    initial begin
        clk = 0; #5;
        forever begin
            clk = 1; #5;
            clk = 0; #5;
        end
    end

    initial begin
        rst = 1; #15;

        rst = 0; opcode = 3'b110; op = 2'b10; s = 1; #10; // Instruction 1
        s = 0; #90;  
        
        opcode = 3'b110; op = 2'b00; s = 1; #10; // Instrcution 2
        s = 0; #90;

        opcode = 3'b101; s = 1; #10; // Instruction 3
        s = 0; #90;

        opcode = 3'b101; op = 2'b01; s = 1; #10; // Instruction 4
        s = 0; #90;

        opcode = 3'b101; op = 2'b10; s = 1; #10; // Instruction 5
        s = 0; #90;

        opcode = 3'b101; op = 2'b11; s = 1; #10; // Instruction 6
        s = 0; #90;
        $stop();
    end

endmodule