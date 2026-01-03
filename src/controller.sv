import alu_pkg::*; 

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
    output alu_op_sel_t alu_op,
    output logic alu_src_a, 
    output logic [1:0] alu_src_b, 
    output logic reg_write, 
    output logic reg_dst
);

    localparam logic [5:0] LW = 6'b100011;

    typedef enum logic [4:0] { 
        FETCH1,
        FETCH2, 
        DECODE, 
        MEM_ADDR_COMP, 
        MEM_ACCESS, 
        MEM_READ_COMP, 
        MEM_ACCESS_STORE, 
        R_TYPE_EXEC, 
        R_TYPE_COMP,
        IMM_VAL_COMP, 
        IMM_VAL_STORE,
        BRANCH_COMP, 
        JUMP, 
        HALT,
        XXX = 'x
    } state_t;

    state_t state_r, next_state;


    always_ff @(posedge clk or posedge rst) begin 
        if(rst) state_r <= FETCH1; 
        else state_r <= next_state; 
    end

    always_comb begin 
        next_state      = state_r; // to not infer any latches in comb logic
        pc_write_cond   = '0; 
        pc_write        = '0; 
        i_or_d          = '0; 
        mem_write       = '0; 
        mem_to_reg      = '0;
        ir_write        = '0;
        jump_and_link   = '0; 
        is_signed       = '0; 
        pc_source       = '0; 
        alu_op          = ADDIU;
        alu_src_a       = '0; 
        alu_src_b       = '0; 
        reg_write       = '0; 
        reg_dst         = '0;

        case(state_r)
            FETCH1 :    begin 
                         
                            // Fetch instruction from the memory IR = RAM[PC]
                            i_or_d = 1'b0; 

                            // mem_read = 1'b1; reading from memory
                            mem_write = 1'b0; 

                            // PC = PC + 4; 
                            alu_src_a = 1'b0; 
                            alu_src_b = 2'b01;

                            alu_op = ADDIU; 

                            pc_source = 2'b00; 

                            pc_write = 1'b1; 

                            next_state = FETCH2; 
                        end 
            FETCH2 :    begin 
                            // write instruction to the IR
                            ir_write = 1'b1; 

                            // could have add as default ALU operation
                            // alu_op = ADDIU;

                            next_state = DECODE; 
                        end 

            DECODE :    begin 
                            // calculate the branch target address ahead of time to reduce the amount of branch states
                            alu_src_a = 1'b0; // load PC + 4 value into A 
                            alu_src_b = 2'b11; // load sign extended 16 bit value into B (sign extended and lefted shifted twice)
                            
                            is_signed = 1'b1;

                            // alu_op = ADDIU // shouldn't have to worry about this since it's the default value
                            case(ir_31_26)
                                alu_pkg::RTYPE : begin next_state = R_TYPE_EXEC; end
                            endcase 
                        end

            R_TYPE_EXEC : begin 
                            // compute the R_TYPE Instruction
                            alu_src_a = 1'b1; 
                            alu_src_b = 2'b00; 

                            alu_op = RTYPE;

                            next_state = R_TYPE_COMP;
                        end

            R_TYPE_COMP : begin 
                             // store the value into rt
                             reg_dst = 1'b1; 
                             mem_to_reg = 1'b0; 
                             reg_write = 1'b1; 
                             next_state = FETCH1; 
                        end
            IMM_VAL_COMP : begin 
                             // compute the imm_val
                             alu_src_a = 1'b1; 
                             alu_src_b = 2'b10;

                             // get the alu_op from ir_31_26, should match since it's an enum;
                             alu_op = alu_op_sel_t'(ir_31_26); // this is how I can type cast in SV

                             // when to get signed value;
                             if(alu_op == ANDI || alu_op == ORI || alu_op == XORI) is_signed = 1'b0; 
                             else is_signed = 1'b1; 

                             next_state = IMM_VAL_STORE; 
                        end 
            IMM_VAL_STORE : begin 
                             // store value into the Register File
                             reg_dst = 1'b0; 
                             mem_to_reg = 1'b0;
                             reg_write = 1'b1; 
                             next_state = FETCH1;
                        end
            MEM_ADDR_COMP : begin 
                                // compute the offset + base
                                alu_src_a = 1'b1; 
                                alu_src_b = 2'b10; 
                                alu_op = ADDIU; 
                                if(ir_31_26 == LW) next_state = MEM_ACCESS;
                                else next_state = MEM_ACCESS_STORE;
                        end
            MEM_ACCESS    : begin 
                                // put address into the RAM and read from RAM 
                                // mem_read = 1'b1; 
                                i_or_d = 1'b1; 
                                next_state = MEM_READ_COMP;
                        end
            MEM_READ_COMP : begin 
                                // store data into Register File
                                mem_to_reg = 1'b1; 
                                reg_dst = 1'b0; 
                                next_state = FETCH1; 
                            end
            MEM_ACCESS_STORE : begin 
                                // get the data that was written automatically into memory (using reg B) into regFile
                                i_or_d = 1'b1;
                                mem_write = 1'b1; 
                                next_state = FETCH1; 
                            end 
            HALT           : begin next_state = HALT; end
            default : begin next_state = HALT; end
        endcase
    end 
endmodule 

