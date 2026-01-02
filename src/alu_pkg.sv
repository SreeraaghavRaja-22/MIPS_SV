package alu_pkg;
    typedef enum logic [4:0]{
        C_ADD_U = 5'd0, 
        C_SUB_U = 5'd1,
        C_MULT  = 5'd2,
        C_MUL_U = 5'd3,
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
        C_JR    = 5'd14,
        C_BEQ   = 5'd15, 
        C_BNE   = 5'd16, 
        C_BLEZ  = 5'd17, 
        C_BGTZ  = 5'd18, 
        C_BLTZ  = 5'd19, 
        C_BGEZ  = 5'd20
    } alu_sel_t; 

    typedef enum logic [5:0]{
        R_ADDU   = 6'b100001, 
        R_SUBU   = 6'b100011,
        R_MULT   = 6'b011000, 
        R_MUL_U  = 6'b011001, 
        R_AND    = 6'b100100,
        R_OR     = 6'b100101,
        R_XOR    = 6'b100110,
        R_SRL    = 6'b000010, 
        R_SLL    = 6'b000000,
        R_SRA    = 6'b000011, 
        R_SLT    = 6'b101010,
        R_SLTU   = 6'b101011, 
        R_MFHI   = 6'b010000, 
        R_MFLO   = 6'b010010, 
        R_JR     = 6'b001000
    } r_sel_t;

    typedef enum logic [5:0]{
        RTYPE = 6'b000000
    } alu_op_sel_t;
endpackage