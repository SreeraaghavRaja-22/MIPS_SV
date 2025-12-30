module mux_4x1 
#(
    parameter WIDTH = 32 
) 
(
    input logic [WIDTH-1:0] in1, 
    input logic [WIDTH-1:0] in2, 
    input logic [WIDTH-1:0] in3, 
    input logic [WIDTH-1:0] in4,
    input logic [1:0] sel, 
    output logic [WIDTH-1:0] out
);

    always_comb begin 
       case(sel) 
            2'b00   : begin out = in1; end 
            2'b01   : begin out = in2; end 
            2'b10   : begin out = in3; end 
            2'b11   : begin out = in4; end
            default : begin out = in1; end 
       endcase
    end
endmodule