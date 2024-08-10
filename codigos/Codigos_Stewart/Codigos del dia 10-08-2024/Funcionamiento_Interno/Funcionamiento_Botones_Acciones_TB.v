
`include "Funcionamiento_interno/Funcionamiento_interno.v"

module Funcionamiento_Botones_Acciones_TB;


    reg clk,
    reg reset,
    reg Boton,

    Funcionamiento_Botones_Acciones uut(
        .clk(clk),
        .B_reset(B_reset),
        .Entrada_Sube_Nivel(Entrada_Sube_Nivel),
        .Nivel(Nivel)
    );