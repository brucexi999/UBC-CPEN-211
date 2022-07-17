module tb_cpu ();
    logic clk, reset, s, load; 
	logic  [15:0] in;
	logic [15:0] out;
	logic N, V, Z, w; 

    cpu dut (clk, reset, s, load, in, out, N, V, Z, w);

    initial begin
        clk = 0; #5;
        forever begin
            clk = 1; #5;
            clk = 0; #5;
        end
    end

    initial begin
        #5; 
        reset = 1; #30; // Check for fsm's reset and w. 
        reset = 0; load = 1; in = {3'b110, 2'b10, 3'b000, 8'b00000010}; #10; // Load instruction 1 to the instruction register. 
        load = 0; s = 1; #30; // Run the fsm. 
        s = 0; #30; 

        // Instruction 2 
        load = 1; in = {3'b110, 2'b00, 3'b000, 3'b001, 2'b01, 3'b000 }; #10; // load
        load = 0; s = 1; #10; // run 
        s = 0; #50; 
        $stop;
    end
endmodule 

