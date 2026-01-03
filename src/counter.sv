module counter
#(parameter int WIDTH = 32)
(
    input logic clk, 
    input logic rst, 
    input logic en,
    input logic [WIDTH-1:0] in, 
    output logic [WIDTH-1:0] out
);

    logic [WIDTH-1:0] count; 

    always_ff @(posedge clk or posedge rst) begin 
        if(rst) begin 
            count <= in;  
        end else if(en) begin 
            count <= count + 1; 
            // count++; blocking assignment
        end 
    end 

    assign out = count; 
            
endmodule 