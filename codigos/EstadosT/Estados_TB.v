`timescale 1ns / 1ps
`include "Estados/Estados.v"

module Estados_TB; 
    reg clk;           // Señal de reloj
    wire Led_animo;
    wire Led_sueno;
    wire Led_salud;

    Estados uut (
        .clk(clk),
        .Led_animo(Led_animo),
        .Led_sueno(Led_sueno),
        .Led_salud(Led_salud)
    );

    initial begin
        clk = 0;

    end

    always #1 clk = ~clk;   

    initial begin: TEST_CASE
        $dumpfile("Estados_TB.vcd");
        $dumpvars(-1, uut);
        #(200000) $finish;
    end
endmodule
