module sign_extend
#(parameter int WIDTH1 = 16, 
  parameter int WIDTH2 = WIDTH1*2)
(
    input logic [WIDTH1-1:0] in, 
    input logic is_signed, 
    output logic [WIDTH2-1:0] out
);

    always_comb begin 
        if(is_signed) begin 
            out = {{(WIDTH2-WIDTH1){in[WIDTH1-1]}}, in};
        end else begin 
            out = {{(WIDTH2-WIDTH1){1'b0}}, in};
        end 
    end
endmodule 