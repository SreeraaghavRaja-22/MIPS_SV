import alu_pkg::*;

module alu
#(parameter int WIDTH = 32)
(
    input logic [WIDTH-1:0] reg_a,
    input logic [WIDTH-1:0] reg_b, 
    input logic [4:0] ir_shift, 
    input alu_sel_t opsel, 
    output logic signed [WIDTH-1:0] result, 
    output logic signed [WIDTH-1:0] result_hi, 
    output logic branch_taken,
    output logic carry, 
    output logic borrow
);

    logic signed [WIDTH-1:0] reg_a_s, reg_b_s; 

    always_comb begin
        
        branch_taken = 1'b0; 
        result_hi = 32'b0; 
        result = 32'b0; 
        carry = 1'b0;
        borrow = 1'b0;
        reg_a_s = $signed(reg_a); 
        reg_b_s = $signed(reg_b);

        case(opsel)
            alu_pkg::C_ADD_U : begin {carry, result} = reg_a + reg_b; end
            alu_pkg::C_SUB_U : begin {borrow, result} = reg_a - reg_b; end
            alu_pkg::C_MULT  : begin {result_hi, result} = reg_a_s * reg_b_s; end
            alu_pkg::C_MUL_U : begin {result_hi, result} = reg_a * reg_b; end
            alu_pkg::C_AND   : begin result = reg_a & reg_b; end
            alu_pkg::C_OR    : begin result = reg_a | reg_b; end
            alu_pkg::C_XOR   : begin result = reg_a ^ reg_b; end
            alu_pkg::C_SRL   : begin result = reg_b >> (ir_shift); end
            alu_pkg::C_SLL   : begin result = reg_b << (ir_shift); end
            alu_pkg::C_SRA   : begin result = reg_b_s >>> (ir_shift); end
            alu_pkg::C_SLT   : begin if(reg_a_s < reg_b_s) result = 1;  end
            alu_pkg::C_SLTU  : begin if(reg_a < reg_b) result = 1; end
            alu_pkg::C_BLEZ  : begin if(reg_a <= 0) branch_taken = 1; end 
            alu_pkg::C_BGTZ  : begin if(reg_a > 0) branch_taken = 1; end 
            default          : begin result = 0; result_hi = 0; branch_taken = 1'b0; carry = 1'b0; borrow = 1'b0; end
        endcase
    end
endmodule