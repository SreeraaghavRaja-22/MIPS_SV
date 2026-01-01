module register_file(
    input logic clk, 
    input logic rst, 
    input logic [4:0] rd_addr0, 
    input logic [4:0] rd_addr1, 
    input logic [4:0] wr_addr, 
    input logic wr_en, 
    input logic [31:0] wr_data, 
    output logic [31:0] rd_data0, 
    output logic [31:0] rd_data1, 
    input logic jump_and_link
);

    // logic [31:0] reg_array [0:31]; // packed dimensions (width of an element) can be either ascending or descending
    // unpacked dimensions (number of elements in a memory unit) must be ascending (C-array memory allocation)

    typedef logic [31:0] reg_t; 
    typedef reg_t reg_array_t [0:31];
    reg_array_t regs;  

    always_ff @(posedge clk or posedge rst) begin 
        if(rst) begin 
            foreach(regs[i]) regs[i] <= '0;
        end else begin 
            if(wr_en) begin 
                regs[wr_addr] <= wr_data;
                regs[0] <= '0;
            end 
            if(jump_and_link) begin 
                regs[31] <= wr_data; 
            end 
            rd_data0 <= regs[rd_addr0];
            rd_data1 <= regs[rd_addr1];
        end 
    end 
endmodule 


