`timescale 1us/1ns
module alu_tb(); 

    // All TB inputs
    localparam int WIDTH = 32;

    logic [WIDTH-1:0] reg_a, reg_b; 
    logic [4:0] opsel, ir_shift;
    logic [WIDTH-1:0] result, result_hi; 
    logic branch_taken; 
    logic carry; 
    logic borrow; 


    function [2**WIDTH:0] check_flags (input [WIDTH-1:0] reg_a_in, input [WIDTH-1:0] reg_b_in, input [4:0] opsel, input [4:0] ir_shift)
        begin 
            
        end 
    endfunction

    initial begin 
        $timeformat(-9, 0, " ns");
    end
        
