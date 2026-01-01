module mux_2x1_tb(); 

    localparam int WIDTH = 8; 
    logic [WIDTH-1:0] in1; 
    logic [WIDTH-1:0] in2; 
    logic sel; 
    logic [WIDTH-1:0] out;

    integer i; 
    localparam int MAX = 2**8;

    mux_2x1
    #(.WIDTH(WIDTH))
    MUX1
    (
        .in1(in1),
        .in2(in2),
        .sel(sel),
        .out(out)
    );

    initial begin 
        $timeformat(-9, 0, " ns");
        $monitor($realtime, " in1 = %d, in2 = %d, sel = %0b, out = %d", in1, in2, sel, out);

        for(i = 0; i < MAX; i++) begin 
            #1; in1 = $urandom; in2 = $urandom; sel = $urandom; 
            #1; 
        end 
    end 
endmodule 