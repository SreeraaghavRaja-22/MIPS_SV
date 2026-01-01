module mux_2x1
#(parameter int WIDTH = 32)
(
    input logic [WIDTH-1:0] in1, 
    input logic [WIDTH-1:0] in2, 
    input logic sel, 
    output logic [WIDTH-1:0] out
);

    always_comb begin 
        if(!sel) out = in1; 
        else out = in2; 
    end 
endmodule 