import alu_pkg::*; 

module alu_control
(   
    input logic clk, 
    input logic rst, 
    input logic en,
    input logic [5:0] alu_op, 
    input logic [5:0] ir_5_to_0, 
    output logic hi_en, 
    output logic lo_en, 
    output logic [1:0] alu_lo_hi,
    output alu_sel_t opsel
);

    always_ff @(posedge clk or posedge rst) begin 
    end 


endmodule 