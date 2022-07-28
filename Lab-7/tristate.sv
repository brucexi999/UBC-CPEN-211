module Tristate (in, out, enable);
    parameter n = 16;
    input [n-1:0] in; 
    input enable;
    output logic [n-1:0] out; 

    always_comb begin
        if (enable) 
            out = in;
        else 
            out = {n{1'bz}}; 
    end
endmodule