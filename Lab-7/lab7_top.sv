module lab7_top (KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    logic [1:0] mem_cmd; 
    logic [8:0] mem_addr; 
    logic [15:0] dout, read_data; 

    // Memory control unit.
    Tristate tri_drv (
        .in (dout)
        .out (read_data)
        .enable ((mem_cmd == 2'b01 && mem_addr[8] == 1'b0))
    );

    CPU cpu (
        .clk (),
        .reset (),
        .in (read_data),
        .out (),
        .N (), 
        .V (), 
        .Z (),
        .w (),
        .mem_cmd (mem_cmd),
        .mem_addr (mem_addr)
    );

    RAM ram (
        .clk (),
        .read_address (mem_addr[7:0]),
        .write_address (mem_addr[7:0]),
        .write (),
        .din (),
        .dout (dout)
    ); 


endmodule