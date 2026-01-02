module controller
#(parameter int WIDTH = 32)
(
    input logic clk, 
    input logic rst, 
    input logic [5:0] ir_5_to_0,
    input logic [5:0] ir_31_26,
    output logic pc_write_cond,
    output logic pc_write, 
    output logic i_or_d, 
    output logic mem_write, 
    output logic mem_to_reg, 
    output logic ir_write, 
    output logic jump_and_link, 
    output logic is_signed, 
    output logic [1:0] pc_source, 
    output logic [5:0] alu_op,
    output logic alu_src_a, 
    output logic [1:0] alu_src_b, 
    output logic reg_write, 
    output logic reg_dst
);

