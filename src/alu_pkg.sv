package alu_pkg;
    typedef enum logic [4:0]{
        C_ADD_U = 5'd0, 
        C_SUB_U = 5'd1,
        C_MULT  = 5'd2
        C_MUL_U = 5'd3
        C_AND   = 5'd4,
        C_OR    = 5'd5, 
        C_XOR   = 5'd6, 
        C_SRL   = 5'd7,
        C_SLL   = 5'd8, 
        C_SRA   = 5'd9, 
        C_SLT   = 5'd10, 
        C_SLTU  = 5'd11, 
        C_MFHI  = 5'd12, 
        C_MFLO  = 5'd13, 
        C_JR    = 5'd14
    } alu_sel_t; 
endpackage