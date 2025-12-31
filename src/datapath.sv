module datapath
#(parameter int WIDTH = 32)
(
    input logic clk, 
    input logic rst,
    input logic pc_write_en, 
    input logic i_or_d, 
    input logic mem_write, 
    input logic mem_to_reg, 
    input logic ir_write, 
    input logic reg_dst, 
    input logic reg_write,
    input logic alu_src_a, 
    input logic [1:0] alu_src_b, 
    input logic [1:0] pc_source, 
    input logic alu_op, 
    input logic jump_and_link, 
    input logic is_signed,
    input logic [WIDTH-1:0] inport_0_data, 
    input logic inport_0_en, 
    input logic inport_1_en, 
    output logic [WIDTH-1:0] outport
);

    // implement program counter

    // implement mux 1

    // implement memory module 

    // implement instruction register 

    // implement mux 1

    // implement mux 2

    // implement register file 

    // implement sign extension

    // implement shift left 

    // implement accumulation reg A

    // implement accumulation reg B

    // implement accum mux A

    // implement accum mux B

    // add ALU 

    // ALU control entity

    // add ALU out register 

    // add reg lo

    // add reg hi

    // add ALU out MUX

    // add concat mux 

endmodule

   