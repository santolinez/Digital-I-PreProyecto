 `include "Modo_Primitivo.v"
 `include "Botones_antirebote.v"


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
    output [0:1]LED_Medicina,
	 output senal_5segEnergia,
	 output senal_5segMedicina
);

wire [0:1] Nivel_Animo;
wire [0:1] Nivel_Energia;
wire [0:1] Nivel_Descanso;
wire [0:1] Nivel_Medicina;


wire B_Reset;
wire B_Test;
wire B_Energia;
wire B_Medicina;

wire senal_5segunEnergia;
wire senal_5segunMedicina;





Botones_antirebote utt(.clk(clk),
                        .reset(Bot_Reset),
                        .test(Bot_Test),
                        .b_energia(Bot_Energia),
                        .b_medicina(Bot_Medicina),
                        .Senal_Reset(B_Reset), 
                        .Senal_Test(B_Test), 
                        .Senal_Energia(B_Energia), 
                        .Senal_Medicina(B_Medicina)
                        );






Modo_Primitivo #(10) Modo_Animo (.clk(clk), .Entrada(Entrada_Animo), .Nivel(Nivel_Animo),.activo(1'b1));
Modo_Primitivo #(10) Modo_Descanso (.clk(clk), .Entrada(1'b1), .Nivel(Nivel_Descanso),.activo(1'b1));
Modo_Primitivo #(10) Modo_Energia (.clk(clk), .Entrada(B_Energia), .Nivel(Nivel_Energia),.activo(1'b1),.senal_5seg(senal_5segunEnergia));
Modo_Primitivo #(10) Modo_Medicina (.clk(clk), .Entrada(B_Medicina), .Nivel(Nivel_Medicina),.activo(1'b1),.senal_5seg(senal_5segunMedicina));


assign LED_Animo = Nivel_Animo;
assign LED_Descanso = Nivel_Descanso;
assign LED_Energia = Nivel_Energia;
assign LED_Medicina = Nivel_Medicina;
assign senal_5segEnergia=senal_5segunEnergia;
assign senal_5segMedicina=senal_5segunMedicina;
endmodule
