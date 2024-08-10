module Funcionamiento_Tamagotchi#( parameter Tiempo_De_Cambio)(

    input clk, //Este reloj puede ser uno instanciado de un bloque de tiempos para que sea reloj de 1 segundo
    input B_Test,
    input B_Reset,
    input [0:1] Nivel_Animo,
    input [0:1] Nivel_Energia,
    input [0:1] Nivel_Descanso,
    input [0:1] Nivel_Salud,

    output Viendo_Animo,
    output Viendo_Energia,
    output Viendo_Descanso,
    output Viendo_Salud,
);

reg [0:1] Modo_Actual;

if (~B_Reset)begin

end


endmodule