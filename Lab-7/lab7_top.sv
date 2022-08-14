module lab7_top (KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    logic [1:0] mem_cmd; 
    logic [8:0] mem_addr; 
    logic [15:0] dout, read_data, datapath_out; 
    logic N, V, Z; 

    // Memory control unit.
    Tristate tri_drv (
        .in (dout),
        .out (read_data),
        .enable ((mem_cmd == 2'b01 && mem_addr[8] == 1'b0))
    );

    CPU cpu (
        .clk (~KEY[0]),
        .reset (~KEY[1]),
        .in (read_data),
        .out (datapath_out),
        .N (N), 
        .V (V), 
        .Z (Z),
        .w (LEDR[9]),
        .mem_cmd (mem_cmd),
        .mem_addr (mem_addr)
    );

    RAM ram (
        .clk (~KEY[0]),
        .read_address (mem_addr[7:0]),
        .write_address (mem_addr[7:0]),
        .write (mem_cmd == 2'b00 && mem_addr[8] == 1'b0),
        .din (datapath_out),
        .dout (dout)
    ); 

    assign HEX5[0] = ~Z;
    assign HEX5[6] = ~N;
    assign HEX5[3] = ~V;

    sseg H0(datapath_out[3:0],   HEX0);
    sseg H1(datapath_out[7:4],   HEX1);
    sseg H2(datapath_out[11:8],  HEX2);
    sseg H3(datapath_out[15:12], HEX3);
    assign HEX4 = 7'b1111111;
    assign {HEX5[2:1],HEX5[5:4]} = 4'b1111; // disabled
    assign LEDR[8] = 1'b0;
endmodule

module sseg(in,segs);
  input [3:0] in;
  output reg [6:0] segs;

  // NOTE: The code for sseg below is not complete: You can use your code from
  // Lab4 to fill this in or code from someone else's Lab4.  
  //
  // IMPORTANT:  If you *do* use someone else's Lab4 code for the seven
  // segment display you *need* to state the following three things in
  // a file README.txt that you submit with handin along with this code: 
  //
  //   1.  First and last name of student providing code
  //   2.  Student number of student providing code
  //   3.  Date and time that student provided you their code
  //
  // You must also (obviously!) have the other student's permission to use
  // their code.
  //
  // To do otherwise is considered plagiarism.
  //
  // One bit per segment. On the DE1-SoC a HEX segment is illuminated when
  // the input bit is 0. Bits 6543210 correspond to:
  //
  //    0000
  //   5    1
  //   5    1
  //    6666
  //   4    2
  //   4    2
  //    3333
  //
  // Decimal value | Hexadecimal symbol to render on (one) HEX display
  //             0 | 0
  //             1 | 1
  //             2 | 2
  //             3 | 3
  //             4 | 4
  //             5 | 5
  //             6 | 6
  //             7 | 7
  //             8 | 8
  //             9 | 9
  //            10 | A
  //            11 | b
  //            12 | C
  //            13 | d
  //            14 | E
  //            15 | F

  //assign segs = 7'b0001110;  // this will output "F" 

    always @(*) begin
    case (in)
      4'b0000: segs = 7'b1000000;
      4'b0001: segs = 7'b1111001;
      4'b0010: segs = 7'b0100100;
      4'b0011: segs = 7'b0110000;
      4'b0100: segs = 7'b0011001;
      4'b0101: segs = 7'b0010010;
      4'b0110: segs = 7'b0000010;
      4'b0111: segs = 7'b1111000;
      4'b1000: segs = 7'b0000000;
      4'b1001: segs = 7'b0011000;
      4'b1010: segs = 7'b0001000;
      4'b1011: segs = 7'b0000011;
      4'b1100: segs = 7'b1000110;
      4'b1101: segs = 7'b0100001;
      4'b1110: segs = 7'b0000110;
      4'b1111: segs = 7'b0001110;
      default: segs = 7'b1111111;
    endcase
  end
endmodule