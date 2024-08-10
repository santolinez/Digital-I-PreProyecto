// Este codigo es para los BOTONES de COMIDA y SALUD 


module Funcionamiento_Botones_Acciones #(parameter COUNT_BOT = 50000)(

    input clk,
    input reset,
    input Boton,

    output senal

);
    reg [$clog2(COUNT_BOT)-1:0] Counter;
    reg Contando; // Permito que usted cuente
    reg 



initial begin 
 Contando = 0,
 Boton = 0,
end

always @(posedge clk) begin

    if (Boton = 1) begin
    Contando = 1;
    end else if (Counter > COUNT_BOT) begin
    Contando = 0;
    Counter = 0;
    end 

    if (Contando = 1) begin 
        Counter = Counter + 1;
    end else begin
        Counter = 0
    end
end


endmodule