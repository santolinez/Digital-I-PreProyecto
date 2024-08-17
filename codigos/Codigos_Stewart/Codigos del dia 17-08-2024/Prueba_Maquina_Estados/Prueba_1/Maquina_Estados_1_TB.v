`timescale 1ns / 1ps
`include "Prueba_Maquina_Estados/Prueba_1/Maquina_Estados_1.v"

module Maquina_Estados_1_TB();
    reg clk;
    reg reset;

    reg Boton_Comida;

    wire [1:0]Visualizacion;

    reg [1:0] Nivel;


  
    Maquina_Estados_1 uut(
        .clk(clk),    
        .reset(reset),

        .Boton_Comida(Boton_Comida),

        .Visualizacion(Visualizacion),

        .Nivel(Nivel)
    );

    initial begin
        clk = 0;
        reset = 0;
        Boton_Comida = 0;
        Nivel = 3;
    end 

    always #1 clk = ~clk;
    always #500 reset = ~reset;
    always #25 Boton_Comida = ~Boton_Comida;
    always #25 Nivel = Nivel + 1;
    always #15 Nivel = Nivel -1;





    initial begin: TEST_CASE
        $dumpfile("Maquina_Estados_1.vcd");
        $dumpvars(-1, uut);
        #50000 $finish;
    end

endmodule