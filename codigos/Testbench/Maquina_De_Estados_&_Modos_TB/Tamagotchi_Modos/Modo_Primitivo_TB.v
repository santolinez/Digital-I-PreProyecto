`timescale 1ns / 1ps
`include "Tamagotchi_Modos/Modo_Primitivo.v"

module Modo_Primitivo_TB;
    //Entradas
    reg clk;
    reg B_reset;
    reg Entrada_Sube_Nivel;
    reg activo;
    // Salida
    wire  [1:0] Nivel;


    Modo_Primitivo uut(
        .clk(clk),
        .B_reset(B_reset),
        .Entrada_Sube_Nivel(Entrada_Sube_Nivel),
        .Nivel(Nivel),
        .activo(activo)
    );

    initial begin
        clk = 0;
        B_reset = 1;
        Entrada_Sube_Nivel = 0;
        activo = 1;
    end

    always #1 clk = ~clk; // Cambia cada nanosegundo (1ns)

    always #300 Entrada_Sube_Nivel = ~Entrada_Sube_Nivel; // Cada 10 flancos de subida la señal cambia [#20 es cada 20ns]

    
    always #1200 B_reset = ~B_reset; 

    initial begin: TEST_CASE
        $dumpfile("Modo_Primitivo.vcd");
        $dumpvars(-1, uut);
        #(20000) $finish;
    end

endmodule