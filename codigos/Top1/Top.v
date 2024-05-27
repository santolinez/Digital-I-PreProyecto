// `include "Top/Ultrasonido.v"
// `include "Top/EstadosT.v"
// `include "Top/Botones_antirebote.v"
// `include "Top/BotonesT.v"

module Top(
   input clk,
   input Echo,
   input Enable,
   input Dormir,
   input test,reset,
   input b_comida,
   input b_medicina,
   output Trigger,
   output Led, Led_dormir,Led_Comida,Led_Medicina ,
   output Led_animo,Led_hambre, Led_sueno, Led_salud
);

wire Carino;
wire Comida;
wire Medicina;

Botones_antirebote botones_antirebote(
    .clk(clk),
    .test(test),
    .reset(reset),
    .b_comida(b_comida),
    .b_medicina(b_medicina),
    .led1(test),
    .led2(Comida),
    .led3(Medicina)
); 

Ultrasonido ultrasonido(
    .clk(clk),
    .Enable(Enable),
    .Echo(Echo),
    .Led(Carino),
    .Trigger(Trigger)
);

EstadosT estadost(
    .clk(clk),
    .Led_animo(Led_animo),
    .Led_hambre(Led_hambre),
    .Led_sueno(Led_sueno),
    .Led_salud(Led_salud),
    .Carino(~Carino),
    .Dormir(Dormir),
	.Medicina(Medicina),
	.Comida(Comida)
);

 assign Led=Carino;
 assign Led_dormir=~Dormir;
 assign Led_Comida=Comida;
 assign Led_Medicina=Medicina;
endmodule
