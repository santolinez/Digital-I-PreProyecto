`include "Maquina_Estados_1.v"
`include "Modos.v"

module Maq_Est_Y_Modos (

    input clk,
    input reset,

    input Boton_Comida,
    input Boton_Medicina

);


// Salidas Modos -- Entradas Estados

wire Senal_Reset;

wire Senal_5Seg_Comida;
wire Senal_5Seg_Medicina;


wire [1:0] Cable_Niveles_Medicina;
wire [1:0] Cable_Niveles_Comida;


// Salidas Estados -- Entradas Modos

wire Senal_Activo_Comida;
wire Senal_Activo_Medicina;


Maquina_Estados_1 maq_est(
    .clk(clk), 
    .reset(Senal_Reset),
    .Boton_Comida(Senal_5Seg_Comida),
    .Boton_Medicina(Senal_5Seg_Medicina),
    .Nivel_Comida(Cable_Niveles_Comida),
    .Activo_Comida(Senal_Activo_Comida),
    .Activo_Medicina(Senal_Activo_Medicina)

);

Modos mods(
    .clk(clk),
    .Bot_Reset(reset),
    .Bot_Energia(Boton_Comida),
    .Bot_Medicina(Boton_Medicina),
    .Reset_General(Senal_Reset),
    .senal_5segEnergia(Senal_5Seg_Comida),
    .senal_5segMedicina(Senal_5Seg_Medicina),
    .Activo_Comida(Senal_Activo_Comida),
    .Activo_Medicina(Senal_Activo_Medicina),
    .LED_Energia(Cable_Niveles_Comida),
    .LED_Medicina(Cable_Niveles_Medicina)
);



endmodule