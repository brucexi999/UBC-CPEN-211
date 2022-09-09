module tb_CPU ();
    logic clk, reset; 
	logic  [15:0] in;
	logic [15:0] out;
	logic N, V, Z, w; 
    logic [1:0] mem_cmd;  
	logic [8:0] mem_addr;

    CPU dut (clk, reset, in, out, N, V, Z, w, mem_cmd, mem_addr);

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
        reset = 0; in = {3'b001, 2'b00, 3'b000, 8'b00000100}; // Load the decimal number 1 to register #0. 
        #1000; // Run the fsm.  

        $stop;

    end
endmodule 