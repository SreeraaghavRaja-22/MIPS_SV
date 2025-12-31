`timescale 1us/1ns
module register_tb(); 

    localparam int WIDTH = 8; 

    logic clk = 0; 
    logic rst; 
    logic en; 
    logic [WIDTH-1:0] in; 
    logic [WIDTH-1:0] out; 

    integer i; 
    localparam int MAX = 2**WIDTH; 
    localparam int CLK_HALF_PERIOD = 0.5;


    register 
    #(.WIDTH(WIDTH))
    REG1
    (
        .clk(clk),
        .rst(rst), 
        .en(en), 
        .in(in), 
        .out(out)
    );


    always begin #CLK_HALF_PERIOD; clk = !clk; end 

    initial begin 
        #1; rst = 1; en = 1; 
        repeat(3) @(posedge clk); rst = 0; 

        for(i = 0; i < MAX; i++) begin 
            in = i; @(posedge clk); 
        end 


        $stop; 
    end 

endmodule 