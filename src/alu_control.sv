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
                                        alu_pkg::R_ADDU : begin opsel = C_ADD_U; end 
                                        alu_pkg::R_SUBU : begin opsel = C_SUB_U; end 
                                        alu_pkg::R_AND  : begin opsel = C_AND;   end 
                                        alu_pkg::R_OR   : begin opsel = C_OR;    end 
                                    endcase
                                end
        endcase
    end 
endmodule 