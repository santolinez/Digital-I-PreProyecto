

module Modo_Primitivo #(parameter Parametro= 65)(

    // Entradas
    input clk,
    input B_reset,
    input Entrada_Sube_Nivel,
    input activo,
    // Salida
     output [0:1] Nivel 
     
);

reg [0:1] Contador_Nivel;
reg [$clog2(Parametro)-1:0] Contador_Tiempo;

initial begin
        Contador_Nivel = 3;
        Contador_Tiempo = 0;
    end


always @(posedge clk)begin

if (~B_reset) begin
    Contador_Nivel <= 3;
    Contador_Tiempo <= 0;
end else if (Contador_Tiempo == Parametro & Contador_Nivel > 0 & activo) begin
        Contador_Nivel = Contador_Nivel - 1;
        Contador_Tiempo <= 0;
end else if (~Entrada_Sube_Nivel & Contador_Nivel<3 & activo) begin
        Contador_Nivel = Contador_Nivel + 1; 
end else if (activo) begin
        Contador_Tiempo = Contador_Tiempo + 1;
end
end // Fin del Always clk

assign Nivel = Contador_Nivel;



endmodule