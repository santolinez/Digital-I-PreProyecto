 `include "Tamagotchi_Modos/Modo_Primitivo.v"
 `include "Botones/Botones_antirebote.v"


 module Modos(
    //Entradas 
    input clk,
    input Bot_Test,
    input Bot_Reset,

    input Bot_Energia,
    input Bot_Medicina,
    input Entrada_Descanso,
    input Entrada_Animo,

    //Salidas
    output [0:1]LED_Animo,
    output [0:1]LED_Energia,
    output [0:1]LED_Descanso,
    output [0:1]LED_Medicina
);

wire [0:1] Nivel_Animo;
wire [0:1] Nivel_Energia;
wire [0:1] Nivel_Descanso;
wire [0:1] Nivel_Medicina;

reg B_MedicinaPrev;
reg B_EnergiaPrev;      

reg B_Reset;
reg B_Test;
reg B_Energia;
reg B_Medicina;

reg B_Medi;
reg B_Ener;
reg B_Medi;
reg flanco_ener;
reg flanco_medi;
reg activo_med;

initial begin
    B_Reset=0;
    B_Test=0;
    B_Energia=0;
    B_Medicina=0;
    B_MedicinaPrev =0 ;
    B_EnergiaPrev=0;
    B_Medi=0;
    B_Ener=0;
    flanco_ener=1;
    flanco_medi=1;
end





Modo_Primitivo #(5) Modo_Animo (.clk(clk), .Entrada_Sube_Nivel(Entrada_Animo), .Nivel(Nivel_Animo),.activo(1));
Modo_Primitivo #(5) Modo_Descanso (.clk(clk), .Entrada_Sube_Nivel(Entrada_Descanso), .Nivel(Nivel_Descanso),.activo(1));
Modo_Primitivo #(5) Modo_Energia (.clk(clk), .Entrada_Sube_Nivel(flanco_ener), .Nivel(Nivel_Energia),.activo(1));
Modo_Primitivo #(5) Modo_Medicina (.clk(clk), .Entrada_Sube_Nivel(flanco_medi), .Nivel(Nivel_Medicina),.activo(0));


always @(clk) begin
    B_MedicinaPrev=B_Medi;
    B_EnergiaPrev=B_Ener;
    B_Ener=B_Energia;
    B_Medi=B_Medicina;
    flanco_ener=(B_Ener==B_EnergiaPrev);
    flanco_medi=(B_Medi==B_MedicinaPrev);//detector de los flancos de subida
end

assign LED_Animo = Nivel_Animo;
assign LED_Descanso = Nivel_Descanso;
assign LED_Energia = Nivel_Energia;
assign LED_Medicina = Nivel_Medicina;

endmodule
