import alu_pkg::*; 

module top_level
#(parameter int WIDTH = 32)
(
    input logic clk, 
    input logic rst,
    input logic [1:0] buttons, 
    input logic [9:0] switches, 
    output logic [9:0] leds
);

    logic pc_write_en, i_or_d, mem_write, mem_to_reg, ir_write, reg_dst, pc_write_cond;
    logic reg_write, alu_src_a, jump_and_link, is_signed, pc_write; 
    logic [1:0] alu_src_b, pc_source; 
    logic [5:0] ir_5_to_0, ir_31_26;
    logic [WIDTH-1:0] inport_data, outport, branch_taken; 
    alu_op_sel_t alu_op;

    assign pc_write_en = (pc_write_cond & branch_taken) | pc_write;
    assign inport_data = {{(WIDTH-$bits(switches)){1'b0}},switches};
    assign leds = outport[9:0];

    controller
    #(.WIDTH(WIDTH))
    CONT 
    (
        .clk(clk), 
        .rst(rst),
        .ir_5_to_0(ir_5_to_0),
        .ir_31_26(ir_31_26), 
        .pc_write_cond(pc_write_cond),
        .pc_write(pc_write),
        .i_or_d(i_or_d),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .ir_write(ir_write), 
        .jump_and_link(jump_and_link), 
        .is_signed(is_signed),
        .pc_source(pc_source),
        .alu_op(alu_op),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .reg_write(reg_write),
        .reg_dst(reg_dst)
    );

    datapath 
    #(.WIDTH(WIDTH))
    DP 
    (
        .clk(clk),
        .rst(rst),
        .pc_write_en(pc_write_en),
        .i_or_d(i_or_d),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .ir_write(ir_write),
        .reg_dst(reg_dst),
        .reg_write(reg_write),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .pc_source(pc_source),
        .alu_op(alu_op),
        .jump_and_link(jump_and_link),
        .is_signed(is_signed),
        .inport_data(inport_data), 
        .inport_0_en(buttons[0]),
        .inport_1_en(buttons[1]),
        .outport(outport),
        .ir_5_to_0(ir_5_to_0),
        .ir_31_26(ir_31_26)
    );
endmodule



    