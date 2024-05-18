// `include "Top/Ultrasonido.v"
// `include "Top/EstadosT.v"
// `include "Top/Botones.v"
// `include "Top/BotonesT.v"
module Top(
   input clk,
   input Echo,
   input Enable,
   //input B_Comida,
   //input B_Medicina,
   input Dormir,
   //input test,
   //input reset,
	//output led_modo_test,
	//output led_reset,
   output Trigger,
   output Led, Led_dormir,
   //Led_Comida,Led_Medicina ,
   output Led_animo,Led_hambre, Led_sueno, Led_salud
);

wire Carino;
//wire Comida;
//wire Medicina;
//wire modo_test;
//wire reseteo;

/* BotonesT botonest(
    .B_Comida(B_Comida),
    .B_Medicina(B_Medicina),
    .Led_Comida(Comida),
    .Led_Medicina(Medicina)
); */

/* Botones botones(
    .clk(clk),
    .test(test),
    .reset(reset),
    .led1(modo_test),
    .led2(reseteo)
); */

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
    //.Medicina(Medicina),
    .Dormir(Dormir)
   // .Comida(Comida)
    //.modo_test(modo_test),
    //.reseteo(reseteo),
    //.test(test)
);
 assign Led=Carino;
 assign Led_dormir=~Dormir;
 //assign Led_Comida = Comida;
 //assign Led_Medicina = Medicina;
 //assign led_modo_test=modo_test;
 //assign led_rest= reseteo;
endmodule