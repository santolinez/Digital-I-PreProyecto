module Maq_Est_Y_Modos_TB();
    
    reg clk;
    reg reset;

    reg Boton_Comida;
    reg Boton_Medicina;
    reg Boton_Test;    
    
    wire sseg;
    wire an;


  
    Maq_Est_Y_Modos  uut(
        .clk(clk),
        .reset(reset),
        .Boton_Comida(Boton_Comida),
        .Boton_Medicina(Bot_Medicina),
        .Boton_Test(Boton_Test)
    );

    initial begin
        clk = 0;
        reset = 1;
        Boton_Comida = 0;
        Boton_Medicina = 0;
        Boton_Test=1;
        #10
        Boton_Test=0;
        #30
        Boton_Test=1;
        #15
        Boton_Test=0;
        #15
        Boton_Test=1;
        #15
        Boton_Test=0;
        #15 
        Boton_Test=1;
        #15
        Boton_Test=0;
        #15 
        Boton_Test=1;
        
       
        

    end 

    always #1 clk = ~clk;
    always #500 reset = ~reset;
    always #25 Boton_Comida = ~Boton_Comida;
    always #35 Boton_Medicina = ~Boton_Medicina;
  
    initial begin: TEST_CASE
        $dumpfile("Maq_Est_Y_Modos.vcd");
        $dumpvars(-1, uut);
        #50000 $finish;
    end


endmodule
