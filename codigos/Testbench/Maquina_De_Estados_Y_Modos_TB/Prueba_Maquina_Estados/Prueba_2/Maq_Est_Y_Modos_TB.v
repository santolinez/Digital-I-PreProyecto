`include "codigos/Testbench/Maquina_De_Estados_Y_Modos_TB/Prueba_Maquina_Estados/Prueba_2/Maq_Est_Y_Modos.v"

module Maq_Est_Y_Modos_TB();
    
    reg clk;
    reg reset;

    reg Boton_Comida;
    reg Boton_Medicina;


  
    Maq_Est_Y_Modos  uut(
        .clk(clk),
        .reset(reset),
        .Boton_Comida(Boton_Comida),
        .Boton_Medicina(Bot_Medicina)
    );

    initial begin
        clk = 0;
        reset = 0;
        Boton_Comida = 0;
        Boton_Medicina = 0;
    end 

    always #1 clk = ~clk;
    always #500 reset = ~reset;
    always #35 Boton_Comida = ~Boton_Comida;
    always #35 Boton_Medicina = ~Boton_Medicina;

    initial begin: TEST_CASE
        $dumpfile("Maq_Est_Y_Modos.vcd");
        $dumpvars(-1, uut);
        #50000 $finish;
    end


endmodule