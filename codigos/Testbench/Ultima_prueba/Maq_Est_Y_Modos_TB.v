`include "Maq_Est_Y_Modos.v"

module Maq_Est_Y_Modos_TB();
    
    reg clk;
    reg reset;

    reg Boton_Comida;
    reg Boton_Medicina;

    reg Animo_Ultra;
    reg Descanso_Celda;

    reg Boton_Test;    

    wire sseg;
    wire an;


  
    Maq_Est_Y_Modos  uut(
        .clk(clk),
        .reset(reset),
        .Boton_Test(Boton_Test),
        .Boton_Comida(Boton_Comida),
        .Boton_Medicina(Boton_Medicina),
        .Ultra_sonido(Animo_Ultra),
        .Foto_celda(Descanso_Celda)
    );

    initial begin
        clk = 0;
        reset = 1;
        Boton_Comida = 0;
        Boton_Medicina = 0;

        /*Lo que se hizo con senal_test_filtrado hacer lo mimso con MTest*/

    end 

    always #1 clk = ~clk;
    always #500 reset = ~reset;
    always #15 Boton_Comida = ~Boton_Comida;
    always #25 Boton_Medicina = ~Boton_Medicina;
    always #25 Animo_Ultra = ~Animo_Ultra;
    always #10 Descanso_Celda = ~Descanso_Celda;
  
    initial begin: TEST_CASE
        $dumpfile("Maq_Est_Y_Modos.vcd");
        $dumpvars(-1, uut);
        #50000 $finish;
    end


endmodule
