module tb_datapath ();

    logic clk;
	logic [2:0] readnum, writenum;
	logic loada, loadb, asel, loadc, loads, write;
	logic [1:0] ALUop, shift, vsel, bsel; 
 	logic [15:0] mdata, sximm8, sximm5;
	logic [7:0] PC;
	logic [2:0] status_out;
	logic [15:0] datapath_out;

    Datapath dut (clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads,
				writenum, write, mdata, sximm8, PC, sximm5, status_out, datapath_out);
    
    initial begin
        forever begin
            clk = 0; #5;
            clk = 1; #5;
        end
    end

    initial begin
        #5; 
        readnum = 3'b0; writenum = 3'b0; sximm8 = 'h0001; PC = 'h01; loada = 0; loadb = 0; loadc = 0; loads = 0; write = 0; shift = 2'b0; vsel = 2'b00; asel = 0; bsel = 2'b0; ALUop = 2'b0; mdata = 16'b0; sximm5 = 16'b0; #10;
        write = 1; vsel = 2'b11; #20; 
        write = 0; bsel = 2'b10; loada = 1; #10;
        loada = 0; loadc = 1; #10; 
        loadc = 0; #50; 
        $stop;
    end
endmodule