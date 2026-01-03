`timescale 1us/1ns 
import alu_pkg::*;
module top_level_tb(); 

    localparam int WIDTH = 32; 
    logic clk;
    logic rst;
    logic [1:0] buttons; 
    logic [9:0] switches;
    logic [9:0] leds;
    integer i; 
    localparam int MAX = 2**15;

    top_level
    #(.WIDTH(WIDTH))
    TL 
    (
        .clk(clk),
        .rst(rst),
        .buttons(buttons),
        .switches(switches),
        .leds(leds)
    );

    initial begin : generate_clk
        clk = 0;
        forever begin #0.5; clk = !clk; end
    end 

    initial begin 
        repeat(5) @(posedge clk); rst = 1; buttons = 2'b01; switches = 9'b111111111;
        @(posedge clk); rst = 0; 
        for(i = 0; i < MAX; i++) begin 
            @(posedge clk);
        end

        disable generate_clk;
    end
endmodule 