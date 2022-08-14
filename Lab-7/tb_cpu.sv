module tb_CPU ();
    logic clk, reset; 
	logic  [15:0] in;
	logic [15:0] out;
	logic N, V, Z, w; 
    logic [1:0] mem_cmd;  
	logic [8:0] mem_addr;
    logic [15:0] dout, read_data, datapath_out; 

    CPU dut (
        .clk (clk),
        .reset (reset),
        .in (read_data),
        .out (datapath_out),
        .N (N), 
        .V (V), 
        .Z (Z),
        .w (),
        .mem_cmd (mem_cmd),
        .mem_addr (mem_addr)
    );

    Tristate tri_drv (
        .in (dout),
        .out (read_data),
        .enable ((mem_cmd == 2'b01 && mem_addr[8] == 1'b0))
    );

    RAM ram (
        .clk (clk),
        .read_address (mem_addr[7:0]),
        .write_address (mem_addr[7:0]),
        .write (mem_cmd == 2'b00 && mem_addr[8] == 1'b0),
        .din (datapath_out),
        .dout (dout)
    ); 

    initial begin
        clk = 0; #5;
        forever begin
            clk = 1; #5;
            clk = 0; #5;
        end
    end

    initial begin

        reset = 1; #30; // Check for fsm's reset and w. 
        reset = 0;         #1000;/*
        in = {3'b110, 2'b10, 3'b000, 8'b00000101}; // Load the decimal number 1 to register #0. 
        #70; // Run the fsm.  

        // LDR and STR instruction here. 
        in = 16'b0110000000100000; // Rd: #1, Rn: #0, sximm5: 1. 
        #200

        
        in = {3'b100, 2'b00, 3'b000, 3'b001, 5'b00001}; // Rd: #1, Rn: #0, sximm5: 1.  
        #200; 
        
        
        
        // Instruction 2 
        load = 1; in = {3'b110, 2'b00, 3'b000, 3'b001, 2'b01, 3'b000 }; #10; // load. Rd = 1, Rm = 0
        load = 0; s = 1; #10; // run 
        s = 0; #70; 

        // Instruction 3
        load = 1; in = {3'b101, 2'b00, 3'b001, 3'b010, 2'b01, 3'b000 }; #10; // load. Rn = 1, Rm = 0, Rd = 2
        load = 0; s = 1; #10; // run 
        s = 0; #70; 

        // Instuction 4
        load = 1; in = {3'b101, 2'b01, 3'b010, 3'b000, 2'b00, 3'b000 }; #10; // load. Rn = 2, Rn = 0
        load = 0; s = 1; #10; // run 
        s = 0; #70; 

        // Instuction 5
        load = 1; in = {3'b101, 2'b10, 3'b010, 3'b011, 2'b00, 3'b000 }; #10; // load. Rn = 2, Rn = 0, Rd = 3
        load = 0; s = 1; #10; // run 
        s = 0; #70;  

        // Instuction 6
        load = 1; in = {3'b101, 2'b11, 3'b000, 3'b100, 2'b01, 3'b000 }; #10; // load. Rn = 4, Rn = 0
        load = 0; s = 1; #10; // run 
        s = 0; #70;  */
        $stop;

    end
endmodule 

