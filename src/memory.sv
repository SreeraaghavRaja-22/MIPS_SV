module memory
#(parameter WIDTH = 32)
(
    input logic clk,
    input logic rst, 
    input logic [WIDTH-1:0] address, 
    input logic [WIDTH-1:0] in_data, 
    input logic [WIDTH-1:0] wr_data, 
    input logic inport_0_en, 
    input logic inport_1_en, 
    input logic mem_write, 
    output logic [WIDTH-1:0] rd_data,
    output logic [WIDTH-1:0] outport
);

    logic outport_wr_en; 
    logic ram_wr_en; 
    logic [WIDTH-1:0] ram_rd_data, inport_0_data, inport_1_data;
    logic [1:0] rd_sel; 

    always_comb begin 
        outport_wr_en = '0; 
        ram_wr_en = '0; 
        if (mem_write) begin 
            if (address == 32'h0000FFFC) begin 
                outport_wr_en = 1'b1; 
            end else begin 
                ram_wr_en = 1'b1; 
            end 
        end 
    end 

    always_ff @(posedge clk or posedge rst) begin 
        if(rst) begin 
            rd_sel <= 2'b11; 
        end else begin 
            if(address == 32'h0000FFF8) begin 
                rd_sel <= 2'b00; 
            end else if(address == 32'h0000FFFC) begin 
                rd_sel <= 2'b01; 
            end else begin
                rd_sel <= 2'b10;
            end
        end 
    end 

    RAM1 RAMI(
        .address(address[9:2]), 
        .clock(clk), 
        .data(wr_data), 
        .wren(ram_wr_en), 
        .q(ram_rd_data)
    );

    // don't reset inports to not corrupt the input data
    register 
    #(.WIDTH(WIDTH)) 
    INPORT0(
        .clk(clk), 
        .rst(1'b0), 
        .en(inport_0_en), 
        .in(in_data), 
        .out(inport_0_data)
    );

    register 
    #(.WIDTH(WIDTH)) 
    INPORT1(
        .clk(clk), 
        .rst(1'b0), 
        .en(inport_1_en), 
        .in(in_data), 
        .out(inport_1_data)
    );

    register
    #(.WIDTH(WIDTH))
    OUTPORT(
        .clk(clk), 
        .rst(rst),
        .en(outport_wr_en), 
        .in(wr_data), 
        .out(outport)
    );

    mux_4x1
    #(.WIDTH(WIDTH))
    MUX1(
        .in1(inport_0_data), 
        .in2(inport_1_data), 
        .in3(ram_rd_data),
        .in4('0), 
        .sel(rd_sel), 
        .out(rd_data)
    );

endmodule 


                