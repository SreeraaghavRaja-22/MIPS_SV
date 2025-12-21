import alu_pkg

module alu
#(parameter int WIDTH = 32)
(
    input logic [WIDTH-1:0] reg_a,
    input logic [WIDTH-1:0] reg_b, 
    input logic [4:0] ir_shift, 
    input logic [4:0] opsel, 
    output logic [WIDTH-1:0] result, 
    output logic [WIDTH-1:0] result_hi, 
    output logic branch_taken
);

    always_comb begin
        
        branch_taken = 1'b0; 
        result_hi = 32'b0; 
        result = 32'b0; 

        case(opsel)
            C_ADD_U : result = a + b; 
            C_SUB_U : result = a - b; 
            C_MULT  : signed({result_hi, result}) = signed(a * b);
            C_MUL_U : {result_hi, result} = a * b;
            C_AND   : result = a & b; 
            C_OR    : result = a | b; 
            C_XOR   : result = a ^ b; 
            C_SRL   : result = a >> (ir_shift);
            C_SLL   : result = a << (ir_shift);
            C_SRA   : result = signed(a) >> (ir_shift);
        endcase
    end

endmodule