module tb_lab7_top ();
    logic [3:0] KEY;
    logic [9:0] SW;
    logic [9:0] LEDR;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;    

    lab7_top dut (KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

    initial begin
        KEY[0] = 1; #5;
        forever begin
            KEY[0] = 0; #5;
            KEY[0] = 1; #5;
        end
    end

    initial begin
        KEY[1] = 1; #5; 
        KEY[1] = 0; #5;
        KEY[1] = 1; #500; 

        $stop;
    end
endmodule