module counter_tb();

    localparam int WIDTH = 8;
    logic clk;
    logic rst; 
    logic en; 
    logic [WIDTH-1:0] in; 
    logic [WIDTH-1:0] out; 

    localparam int HALF_CLK_PERIOD = 2;

    counter 
    #(.WIDTH(WIDTH))
    CNT1
    (
        .clk(clk),
        .rst(rst),
        .en(en), 
        .in(in),
        .out(out)
    );


    initial begin 
        clk = 0; 
        forever begin 
            clk = 0; #HALF_CLK_PERIOD; 
            clk = 1; #HALF_CLK_PERIOD; 
        end 
    end 

    initial begin 
        #1; rst = 1; en = 1; in = 8'd4;
        repeat(3) @(posedge clk); rst = 0; en = 0;
        repeat(3) @(posedge clk); en = 1; 
        repeat(30) @(posedge clk); en = 0; 
        repeat(4) @(posedge clk); $stop; 
    end 
    
endmodule 