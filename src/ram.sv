module ram(
    input logic clock, 
    input logic [7:0] address, 
    input logic [31:0] data, 
    input logic wren, 
    output logic [31:0] q
);

    logic [31:0] mem [0:255];
    always_ff @(posedge clock) begin 
        if(wren) mem[address] <= data; 
        q <= mem[address];
    end 
endmodule 