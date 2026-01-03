import alu_pkg::*;

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
    input alu_op_sel_t alu_op, 
    input logic jump_and_link, 
    input logic is_signed,
    input logic [WIDTH-1:0] inport_data, 
    input logic inport_0_en, 
    input logic inport_1_en, 
    output logic [WIDTH-1:0] outport,
    output logic branch_taken,
    output logic [5:0] ir_5_to_0, 
    output logic [5:0] ir_31_26
);

    typedef logic [WIDTH-1:0] bus_type;
    bus_type conc_mux_out, pc_out, alu_out, pc_mux_out, rd_data;
    bus_type ir_out, mar_mux_out, sign_extend_out, shift_left_2;
    bus_type reg_a_in, reg_b_in, alu_mux_out; 
    bus_type a_mux_out, b_mux_out, result, result_hi, hi_out, lo_out;
    logic [4:0] ir_mux_out;
    alu_sel_t opsel; 
    logic hi_en, lo_en; 
    logic [1:0] alu_lo_hi;
    bus_type concat_out;
    logic carry, borrow; 


    // implement program counter
    register
    #(.WIDTH(WIDTH))
    PC
    (
        .clk(clk), 
        .rst(rst), 
        .en(pc_write_en),
        .in(conc_mux_out),
        .out(pc_out)
    );

    // implement mux 1
    mux_2x1
    #(.WIDTH(WIDTH))
    PC_MUX
    (
        .in1(pc_out),
        .in2(alu_out),
        .sel(i_or_d), 
        .out(pc_mux_out)
    );

    // implement memory module 
    memory MEM1(
        .clk(clk),
        .rst(rst),
        .address(pc_mux_out),
        .in_data(inport_data),
        .wr_data(reg_b_in), 
        .inport_0_en(inport_0_en),
        .inport_1_en(inport_1_en),
        .mem_write(mem_write), 
        .rd_data(rd_data), 
        .outport(outport)
    );

    // implement instruction register 
    register 
    #(.WIDTH(WIDTH))
    IR(
        .clk(clk),
        .rst(rst),
        .en(ir_write),
        .in(rd_data),
        .out(ir_out)
    );

    // implement mux 1
    mux_2x1
    #(.WIDTH(5))
    IR_MUX
    (
        .in1(ir_out[20:16]),
        .in2(ir_out[15:11]), 
        .sel(reg_dst), 
        .out(ir_mux_out)
    );

    // implement mux 2
    mux_2x1
    #(.WIDTH(WIDTH))
    MAR_MUX
    (
        .in1(alu_mux_out),
        .in2(rd_data),
        .sel(mem_to_reg),
        .out(mar_mux_out)
    );

    // implement register file 
    register_file 
    #(.WIDTH(WIDTH))
    RF
    (
        .clk(clk), 
        .rst(rst), 
        .rd_addr0(ir_out[25:21]),
        .rd_addr1(ir_out[20:16]), 
        .wr_addr(ir_mux_out),
        .wr_en(reg_write),
        .wr_data(mar_mux_out), 
        .rd_data0(reg_a_in), 
        .rd_data1(reg_b_in), 
        .jump_and_link(jump_and_link)
    );

    // implement sign extension
    sign_extend
    #(.WIDTH1(16))
    SE1
    (
        .in(ir_out[15:0]),
        .is_signed(is_signed),
        .out(sign_extend_out)
    );
    

    // implement shift left 
    assign shift_left_2 = sign_extend_out << 2;

    // implement accumulation reg A (DO NOT IMPLEMENT, will cause unnecessary cycle delay)
    // register 
    // #(.WIDTH(WIDTH))
    // REG_A
    // (
    //     .clk(clk), 
    //     .rst(rst), 
    //     .en(1'b1), 
    //     .in(reg_a_in),
    //     .out(reg_a_out)
    // );

    // // implement accumulation reg B
    // register 
    // #(.WIDTH(WIDTH))
    // REG_B
    // (
    //     .clk(clk), 
    //     .rst(rst), 
    //     .en(1'b1), 
    //     .in(reg_b_in),
    //     .out(reg_b_out)
    // );

    // implement accum mux A
    mux_2x1
    #(.WIDTH(WIDTH))
    A_MUX
    (
        .in1(pc_out),
        .in2(reg_a_in),
        .sel(alu_src_a),
        .out(a_mux_out)
    );

    // implement accum mux B
    mux_4x1
    #(.WIDTH(WIDTH))
    B_MUX 
    (
        .in1(reg_b_in), 
        .in2(32'd4), 
        .in3(sign_extend_out), 
        .in4(shift_left_2), 
        .sel(alu_src_b), 
        .out(b_mux_out)
    );

    // add ALU 
    alu 
    #(.WIDTH(WIDTH))
    ALU1 
    (
        .reg_a(a_mux_out),
        .reg_b(b_mux_out),
        .ir_shift(ir_out[10:6]), 
        .opsel(opsel), 
        .branch_taken(branch_taken), 
        .result(result), 
        .result_hi(result_hi),
        .carry(carry),
        .borrow(borrow)
    );

    // ALU control entity
    alu_control ALUC 
    (
        .alu_op(alu_op), 
        .ir_5_to_0(r_sel_t'(ir_out[5:0])), 
        .ir_20_to_16(ir_out[20:16]),
        .hi_en(hi_en),
        .lo_en(lo_en), 
        .alu_lo_hi(alu_lo_hi),
        .opsel(opsel)
    );


    // add ALU out register 
    register
    #(.WIDTH(WIDTH))
    ALU_OUT 
    (
        .clk(clk), 
        .rst(rst), 
        .en(1'b1), 
        .in(result), 
        .out(alu_out)
    );

    // add reg lo
    register
    #(.WIDTH(WIDTH))
    LO 
    (
        .clk(clk), 
        .rst(rst), 
        .en(lo_en), 
        .in(result), 
        .out(lo_out)
    );

    // add reg hi
    register
    #(.WIDTH(WIDTH))
    HI 
    (
        .clk(clk), 
        .rst(rst), 
        .en(hi_en), 
        .in(result_hi), 
        .out(hi_out)
    );

    // add ALU out MUX
    mux_4x1
    #(.WIDTH(WIDTH))
    ALU_MUX
    (
        .in1(alu_out), 
        .in2(lo_out), 
        .in3(hi_out), 
        .in4('0), 
        .sel(alu_lo_hi), 
        .out(alu_mux_out)
    );

    assign concat_out = {pc_out[31:28], ir_out[25:0], 2'b00};

    // add concat mux 
    mux_4x1
    #(.WIDTH(WIDTH))
    CONCAT_MUX
    (
        .in1(result),
        .in2(alu_out), 
        .in3(concat_out),
        .in4('0), 
        .sel(pc_source),
        .out(conc_mux_out)
    );

    assign ir_5_to_0 = ir_out[5:0];
    assign ir_31_26 = ir_out[31:26];
endmodule
