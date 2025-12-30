`timescale 1us/1ns
module mux_4x1_tb();

    localparam int WIDTH = 32; 
    logic [WIDTH-1:0] in1; 
    logic [WIDTH-1:0] in2; 
    logic [WIDTH-1:0] in3;
    logic [WIDTH-1:0] in4; 
    logic [1:0] sel; 
    logic [WIDTH-1:0] out; 

    localparam int MAX = 2**8; 
    integer i; 

    mux_4x1 
    #(.WIDTH(WIDTH))
    mux_4x1
    (
        .in1(in1), 
        .in2(in2), 
        .in3(in3), 
        .in4(in4), 
        .sel(sel), 
        .out(out)
    );

    initial begin 
        $timeformat(-9, 0, " ns");
        #1; in1 = 0; in2 = 0; in3 = 0; in4 = 0; sel = 0; 

        for(i = 0; i < MAX; i++) begin 
            #1; in1 = $urandom; in2 = $urandom; in3 = $urandom; in4 = $urandom; sel = $urandom; 
            #1;
            $display($realtime, " Test%d, in1 = %d, in2 = %d, in3 = %d, in4 = %d, sel = %d, out = %d", i, in1, in2, in3, in4, sel, out);
        end
    end 
endmodule 