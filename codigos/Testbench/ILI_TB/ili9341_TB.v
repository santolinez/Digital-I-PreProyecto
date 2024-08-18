`timescale 1ns / 1ps
`include "ili9341_top.v"

module ili9341_TB ();
    reg clk;
    reg rst;
    reg [2:0] visua;
  
    ili9341_top uut(
        .clk(clk),    
        .rst(rst),
        .visua(visua)
    );

    initial begin
        clk = 0;
        rst = 0; #10
        rst = 1;
        visua =0; #40000
        visua =1; #100000
        visua =2; #1000
        visua = 3; 
    end 

    always #1 clk = ~clk;

    initial begin: TEST_CASE
        $dumpfile("ili9341.vcd");
        $dumpvars(-1, uut);
        #55000 $finish;
    end

endmodule
