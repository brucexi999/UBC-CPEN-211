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
         
        /*reset = 1; #15;  
        reset = 0; in = {3'b001, 2'b00, 3'b000, 8'b00000100}; // B (unconditioned)
        #200;   

        reset = 1; #10;  
        reset = 0; in = {3'b110, 2'b10, 3'b0, 8'b01000000}; #200;
        in = {3'b110, 2'b10, 3'b001, 8'b01000001}; #200;
        in = {3'b101, 2'b01, 3'b001, 3'b0, 2'b0, 3'b0}; #200; 
        in = {3'b001, 2'b00, 3'b100, 8'b00000100}; #200;// B (conditioned)*/

        reset = 1; #10;  
        reset = 0; in = {3'b010, 2'b11, 3'b111, 8'b00000010}; #95; //BL
        
        in = {3'b010, 2'b00, 3'b000, 3'b111, 5'b0}; #200; //BX

        $stop;

    end
endmodule 