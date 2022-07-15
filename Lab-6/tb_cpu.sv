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
        reset = 1; #20; // Check for fsm's reset and w. 
        reset = 0; load = 1; in = {3'b110, 2'b10, 3'b001, 'h02}; #10; // Load the instruction to the instruction register. 
        load = 0; s = 1; // Run the fsm. 

        $stop;
    end
endmodule 