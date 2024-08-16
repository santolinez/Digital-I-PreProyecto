`timescale 1ns / 1ps
`include "ili9341_top.v"

module ili9341_TB ();
    reg clk;
    reg rst;
  
    ili9341_top uut(
        .clk(clk),    
        .rst(rst)
    );

    initial begin
        clk = 0;
        rst = 0;
        #10 rst = 1;
        #10 rst = 0;
    end 

    always #1 clk = ~clk;

    initial begin: TEST_CASE
        $dumpfile("ili9341.vcd");
        $dumpvars(-1, uut);
        #55000000 $finish;
    end

endmodule