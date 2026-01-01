`timescale 1us/1ns
module memory_tb(); 

    localparam int WIDTH = 32; 

    logic clk; 
    logic rst; 
    logic [WIDTH-1:0] address; 
    logic [WIDTH-1:0] in_data; 
    logic [WIDTH-1:0] wr_data; 
    logic inport_0_en; 
    logic inport_1_en; 
    logic mem_write; 
    logic [WIDTH-1:0] rd_data; 
    logic [WIDTH-1:0] outport; 

    localparam int CLK_HALF_PERIOD = 0.5;


    memory
    #(.WIDTH(WIDTH))
    MEM1
    (
        .clk(clk), 
        .rst(rst), 
        .address(address), 
        .in_data(in_data), 
        .wr_data(wr_data), 
        .inport_0_en(inport_0_en), 
        .inport_1_en(inport_1_en),
        .mem_write(mem_write), 
        .rd_data(rd_data), 
        .outport(outport)
    );

    initial begin 
        clk = 0; 
        forever begin 
            clk = 1; #CLK_HALF_PERIOD; 
            clk = 0; #CLK_HALF_PERIOD; 
        end 
    end

    initial begin 
        #1; rst = 1; inport_0_en = 1'b0; inport_1_en = 1'b0; 
        #1; rst = 0; address = '0; wr_data = 32'h0A0A0A0A; mem_write = 1'b1; 
        repeat(2) @(posedge clk); address = 32'd4; wr_data = 32'hF0F0F0F0;
        repeat(2) @(posedge clk); address = 32'd0; mem_write = 1'b0; 
        repeat(2) @(posedge clk); address = 32'd1; mem_write = 1'b0;
        repeat(2) @(posedge clk); address = 32'd4; mem_write = 1'b0; 
        repeat(2) @(posedge clk); address = 32'd5; mem_write = 1'b0; 
        repeat(2) @(posedge clk); address = 32'h0000FFFC; wr_data = 32'h00001111; mem_write = 1'b1;
        repeat(2) @(posedge clk); address = 32'h0000FFF8; in_data = 32'h00010000; mem_write = 1'b0; inport_0_en = 1'b1; inport_1_en = 1'b0;
        repeat(2) @(posedge clk); address = 32'h0000FFFC; in_data = 32'd1; inport_1_en = 1'b1; inport_0_en = 1'b0;  
        repeat(2) @(posedge clk); address = 32'h0000FFF8; mem_write = 1'b0; 
        repeat(2) @(posedge clk); address = 32'h0000FFFC; mem_write = 1'b0; 

        repeat(10) @(posedge clk); $finish;
    end
endmodule
