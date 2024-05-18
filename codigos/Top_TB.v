`timescale 1ns / 1ps
`include "Top/Top.v"

module Top_TB; 
    reg clk;           // Señal de reloj
    reg Echo;
    wire Trigger;      // Salida del pulso de trigger
    wire Led_animo,Led_hambre, Led_sueno, Led_salud;        

    Top uut (
        .clk(clk),
        .Echo(Echo),
        .Trigger(Trigger),
        .Led_animo(Led_animo),
        .Led_hambre(Led_hambre),
        .Led_sueno(Led_sueno),
        .Led_salud(Led_salud)
    );

    initial begin
        clk = 0;
        Echo=0; #15000
        Echo=1; #20000
        Echo=0; #10000 
        Echo=0; #15000
        Echo=1;

    end

    always #1 clk = ~clk;   

    initial begin: TEST_CASE
        $dumpfile("Top_TB.vcd");
        $dumpvars(-1, uut);
        #(200000) $finish;
    end
endmodule
