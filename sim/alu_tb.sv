`timescale 1us/1ns
import alu_pkg::*;
module alu_tb(); 

    // All TB inputs
    localparam int WIDTH = 8;

    logic [WIDTH-1:0] reg_a, reg_b; 
    alu_sel_t opsel;
    logic [4:0] ir_shift;
    logic signed [WIDTH-1:0] result, result_hi; 
    logic branch_taken; 
    logic carry; 
    logic borrow; 

    localparam int MAX_ITERATIONS = 2**8; 
    integer i; 
    integer total_tests, success_tests, failed_tests;
    logic signed [2*WIDTH+2:0] actual_output, expected_output;
    alu_sel_t valid_ops[] = {C_ADD_U, C_SUB_U, C_MULT, C_AND, C_OR, C_XOR, C_SRL, C_SLL, C_SRA, C_SLT, C_SLTU, C_MFHI, C_MFLO, C_JR, C_BEQ, C_BNE, C_BLEZ, C_BGTZ, C_BLTZ, C_BGEZ, C_NOP};



    function logic signed [2*WIDTH+2:0] check_out (input [WIDTH-1:0] reg_a_in, input [WIDTH-1:0] reg_b_in, input [4:0] opsel_in, input [4:0] ir_shift_in);
        logic signed [WIDTH-1:0] result_o, result_hi_o;
        logic branch_taken_o, carry_o, borrow_o;
        
        
        begin 
            result_hi_o = 32'b0; // using integers for result_hi and result because ints are 32 bits and so are result_hi and result
            result_o = 32'b0; 
            branch_taken_o = 1'b0; 
            carry_o = 1'b0; 
            borrow_o = 1'b0;
            
            case(opsel_in)
                C_ADD_U : begin {carry_o, result_o} = reg_a_in + reg_b_in; end 
                C_SUB_U : begin {borrow_o, result_o} = reg_a_in - reg_b_in; end 
                C_MULT  : begin {result_hi_o, result_o} = $signed(reg_a_in) * $signed(reg_b_in); end 
                C_MUL_U : begin {result_hi_o, result_o} = reg_a_in * reg_b_in; end 
                C_AND   : begin result_o = reg_a_in & reg_b_in; end
                C_OR    : begin result_o = reg_a_in | reg_b_in; end
                C_XOR   : begin result_o = reg_a_in ^ reg_b_in; end 
                C_SRL   : begin result_o = reg_b_in >> (ir_shift_in); end 
                C_SLL   : begin result_o = reg_b_in << (ir_shift_in); end 
                C_SRA   : begin result_o = $signed(reg_b_in) >>> (ir_shift_in); end
                C_SLT   : begin if($signed(reg_a_in) < $signed(reg_b_in)) result_o = 1; end 
                C_SLTU  : begin if(reg_a_in < reg_b_in) result_o = 1; end
                C_BEQ   : begin if(reg_a_in === reg_b_in) branch_taken_o = 1'b1; end 
                C_BNE   : begin if(reg_a_in !== reg_b_in) branch_taken_o = 1'b1; end 
                C_BLEZ  : begin if(reg_a_in <= 0) branch_taken_o = 1'b1; end 
                C_BGTZ  : begin if(reg_a_in > 0) branch_taken_o = 1'b1; end 
                C_BLTZ  : begin if(reg_a_in < 0) branch_taken_o = 1'b1; end 
                C_BGEZ  : begin if(reg_a_in >= 0) branch_taken_o = 1'b1; end
                C_NOP   : begin result_o = reg_a; end 
                default : begin result_o = 0; result_hi_o = 0; branch_taken_o = 1'b0; borrow_o = 1'b0; carry_o = 1'b0; end 
            endcase

            check_out = {branch_taken_o, carry_o, borrow_o, result_hi_o, result_o};   
        end 
    endfunction

    task check_output (input [2*WIDTH+2:0] exp_output, input [2*WIDTH+2:0] act_output);
        
        begin
            if(act_output === exp_output) begin
                $display($realtime, ": SUCCESS!, expected_output = %d, actual_output = %d", exp_output, act_output);
                success_tests++; 
            end else begin
                $display($realtime, ": ERROR!, expected_output = %d, actual_output = %d", exp_output, act_output);
                failed_tests++;
            end
            total_tests++;
        end 
    endtask

    alu 
    #(.WIDTH(WIDTH))
    ALU1(
        .reg_a(reg_a), 
        .reg_b(reg_b), 
        .opsel(opsel), 
        .ir_shift(ir_shift), 
        .result(result), 
        .result_hi(result_hi), 
        .branch_taken(branch_taken),
        .carry(carry), 
        .borrow(borrow)
    );

    initial begin 
        $timeformat(-9, 0, " ns");
        #1; success_tests = 0; failed_tests = 0; total_tests = 0; 

        for(i = 0; i < MAX_ITERATIONS; i = i + 1) begin 
            #1; reg_a = $urandom; reg_b = $urandom; ir_shift = $urandom; opsel = valid_ops[$urandom_range(0, valid_ops.size()-1)]; expected_output = check_out(reg_a, reg_b, opsel, ir_shift);
            #1; actual_output = {branch_taken, carry, borrow, result_hi, result}; check_output(expected_output, actual_output);
        end 

        $display($realtime, ": Tests Passed: %d, Tests Failed, %d, Total Tests: %d", success_tests, failed_tests, total_tests);
    end

endmodule
        
