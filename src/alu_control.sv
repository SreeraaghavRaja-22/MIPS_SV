import alu_pkg::*; 

module alu_control
(   
    input logic clk, 
    input logic rst, 
    input logic en,
    input alu_op_sel_t [5:0] alu_op, 
    input r_sel_t [5:0] ir_5_to_0, 
    output logic hi_en, 
    output logic lo_en, 
    output logic [1:0] alu_lo_hi,
    output alu_sel_t opsel
);

    always_comb begin 
        case(alu_op) 
            alu_pkg::RTYPE :    begin 
                                    case(ir_5_to_0)
                                        alu_pkg::R_ADDU     :   begin opsel = C_ADD_U;    end 
                                        alu_pkg::R_SUBU     :   begin opsel = C_SUB_U;    end 
                                        alu_pkg::R_MULT     :   begin 
                                                                    opsel = C_MULT; 
                                                                    hi_en = 1'b1; 
                                                                    lo_en = 1'b1; 
                                                                end
                                        alu_pkg::R_MUL_U    :   begin 
                                                                    opsel = C_MUL_U; 
                                                                    hi_en = 1'b1; 
                                                                    lo_en = 1'b1; 
                                                                end 
                                        alu_pkg::R_AND      :   begin opsel = C_AND;      end 
                                        alu_pkg::R_OR       :   begin opsel = C_OR;       end 
                                        alu_pkg::R_XOR      :   begin opsel = C_XOR;      end 
                                        alu_pkg::R_SRL      :   begin opsel = C_SRL;      end 
                                        alu_pkg::R_SLL      :   begin opsel = C_SLL;      end
                                        alu_pkg::R_SRA      :   begin opsel = C_SRA;      end 
                                        alu_pkg::R_SLT      :   begin opsel = C_SLT;      end 
                                        alu_pkg::R_SLTU     :   begin opsel = C_SLTU;     end 
                                        alu_pkg::R_MFHI     :   begin 
                                                                    opsel = C_NOP;
                                                                    alu_lo_hi = 2'b10;  
                                                                end 
                                        alu_pkg::R_MFLO     :   begin 
                                                                    opsel = C_NOP;
                                                                    alu_lo_hi = 2'b01;  
                                                                end 
                                        alu_pkg::R_JR       :   begin opsel = C_NOP;      end 
                                        default             :   begin opsel = C_NOP;      end 
                                    endcase
                                end
            alu_pkg::ADDIU : begin opsel = C_ADD_U; end 
            alu_pkg::SUBIU : begin opsel = C_SUB_U; end
            alu_pkg::ANDI  : begin opsel = C_AND;   end 
            alu_pkg::ORI   : begin opsel = C_OR;    end 
            alu_pkg::XORI  : begin opsel = C_XOR;   end 
            alu_pkg::SLTI  : begin opsel = C_SLT;   end 
            alu_pkg::SLTIU : begin opsel = C_SLTIU; end 
        endcase
    end 
endmodule 