module register
#(parameter int WIDTH = 32)
(
    input logic clk, 
    input logic rst, 
    input logic en, 
    input logic[WIDTH-1:0] in, 
    output logic[WIDTH-1:0] out
);
    // use always_ff block for sequential statements
    always_ff @(posedge clk or posedge rst) begin 
        if(rst) out <= '0; // 0s sized to the LHS container 
        else if(en) out <= in; 
    end 

endmodule // async rst register