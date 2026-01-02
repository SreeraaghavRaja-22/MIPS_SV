import alu_pkg::*; 
`timescale  1us/1ns
module alu_tb_2(); 

    localparam int WIDTH = 32; 
    logic [WIDTH-1:0] reg_a; 
    logic [WIDTH-1:0] reg_b; 
    logic [4:0] ir_shift; 
    alu_sel_t opsel; 
    logic signed [WIDTH-1:0] result;
    logic signed [WIDTH-1:0] result_hi; 
    logic branch_taken; 
    logic carry; 
    logic borrow; 


    alu
    #(.WIDTH(WIDTH))
    ALU1 
    (
        .reg_a(reg_a),
        .reg_b(reg_b),
        .ir_shift(ir_shift),
        .opsel(opsel),
        .result(result),
        .result_hi(result_hi),
        .branch_taken(branch_taken),
        .carry(carry),
        .borrow(borrow)
    );

    initial begin 
        $display($realtime, "Actual ALU tests");

        #1; reg_a = 10; reg_b = 15; opsel = C_ADD_U;
        #2; reg_a = 25; reg_b = 10; opsel = C_SUB_U; 
        #2; reg_a = 10; reg_b = -4; opsel = C_MULT; 
        #2; reg_a = 65536; reg_b = 131072; opsel = C_MUL_U; 
        #2; reg_a = 32'h0000FFFF; reg_b = 32'hFFFF1234; opsel = C_AND; 
        #2; reg_b = 32'h0000000F; ir_shift = 5'd4; opsel = C_SRL;
        #2; reg_b = 32'hF0000008; ir_shift = 5'd1; opsel = C_SRA; 
        #2; reg_b = 32'h00000008; ir_shift = 5'd1; opsel = C_SRA;
        #2; reg_a = 10; reg_b = 15; opsel = C_SLT;
        #2; opsel = C_SLTU; 
        #2; reg_a = 15; reg_b = 10; opsel = C_SLT; 
        #2; opsel = C_SLTU; 
        #2; reg_a = 5; opsel = C_BLEZ; 
        #2; opsel = C_BGTZ;
        #10; 
    end 
endmodule 