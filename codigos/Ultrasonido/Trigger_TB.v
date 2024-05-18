`timescale 1ns / 1ps
`include "HC_SR04/Trigger.v"

module Trigger_TB; 
    reg clk;           // Señal de reloj
    reg Enable;        // Habilitación del módulo
    reg Echo;
    wire Trigger;      // Salida del pulso de trigger
    wire Done;         // Indicador de finalización
    wire Led;

    Trigger uut (
        .clk(clk),
        .Enable(Enable),
        .Trigger(Trigger),
        .Led(Led),
        .Done(Done),
        .Echo(Echo)
    );

    initial begin
        clk = 0;
        Enable = 1;
        Echo=1; #20000
        Enable =0;
        Echo=0;
        #10000 Enable =1;
        Echo=0; #15000
        Echo=1;

    end

    always #1 clk = ~clk;   

    initial begin: TEST_CASE
        $dumpfile("TriggerFSM_TB.vcd");
        $dumpvars(-1, uut);
        #(200000) $finish;
    end
endmodule
