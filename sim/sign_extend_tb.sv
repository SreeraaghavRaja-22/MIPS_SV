module sign_extend_tb(); 

    localparam int WIDTH1 = 8; 
    localparam int WIDTH2 = 16; 

    logic [WIDTH1-1:0] in; 
    logic is_signed; 
    logic [WIDTH2-1:0] out;

    localparam int MAX = 2**8; 
    integer i; 

    // don't need to define WIDTH2 explicitly in instantiation of module because default is 2*WIDTH1
    sign_extend
    #(.WIDTH1(WIDTH1))
    ISUS
    (
        .in(in), 
        .is_signed(is_signed),
        .out(out)
    );

    initial begin 
        $timeformat(-9, 0, " ns");
        #1; $monitor($realtime, " in = %b, is_signed = %0b, out = %b", in, is_signed, out);

        for(i = 0; i < MAX; i++) begin 
            #1; in = $urandom; is_signed = $urandom; 
            #1; 
        end 
    end 
endmodule 