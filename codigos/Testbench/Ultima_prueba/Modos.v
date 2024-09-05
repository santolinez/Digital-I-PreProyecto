
 module Modos(
    //Entradas 
    input clk,
    input Bot_Test,
    input Bot_Reset,

    input Bot_Energia,
    input Bot_Medicina,

    input Entrada_Descanso,
    input Entrada_Animo,
   
    input Activo_Comida,
    input Activo_Medicina,
	 input Activo_Descanso,
    input Activo_Carisia,

    //Salidas
    output Reset_General,

    output [0:1]LED_Animo,
    output [0:1]LED_Energia,
    output [0:1]LED_Descanso,
    output [0:1]LED_Medicina,

	 output senal_5segEnergia,
	 output senal_5segMedicina,
    output senal_5segDescanso,
    output senal_5segAnimo,
	 
	 output Senal_Test_fil,
    output Senal_Test,
    output Senal_MTest,

    output B_reset
);

wire [0:1] Nivel_Animo;
wire [0:1] Nivel_Energia;
wire [0:1] Nivel_Descanso;
wire [0:1] Nivel_Medicina;


wire B_Reset;
wire B_Energia;
wire B_Medicina;

wire S_ultra;
wire S_fotocel;




Botones_antirebote utt(.clk(clk),
                        .reset(Bot_Reset),
                        .test(Bot_Test),
                        .b_energia(Bot_Energia),
                        .b_medicina(Bot_Medicina),
                        .sensor_ult_in(Entrada_Animo),
                        .sensor_fot_in(Entrada_Descanso),
                        .reset_tmp(B_Reset), 
                        .Senal_test_activado(Senal_MTest), 
                        .Senal_Btest_BAR(Senal_Test),
                        .Senal_Energia(B_Energia), 
                        .Senal_Medicina(B_Medicina),
                        .Senal_ultrasonido(S_ultra),
                        .Senal_fot(S_fotocel),
								.senal_test_fil(Senal_Test_fil)
                        );






Modo_Primitivo #(1250000000,250000000) Modo_Animo (.clk(clk), .B_reset(B_Reset), .Entrada(S_ultra), .Nivel(Nivel_Animo),.activo(Activo_Carisia),.senal_5seg(senal_5segAnimo));
Modo_Primitivo #(1250000000,250000000) Modo_Descanso (.clk(clk), .B_reset(B_Reset), .Entrada(S_fotocel), .Nivel(Nivel_Descanso),.activo(Activo_Descanso),.senal_5seg(senal_5segDescanso));
Modo_Primitivo #(1250000000,250000000) Modo_Energia (.clk(clk), .B_reset(B_Reset), .Entrada(B_Energia), .Nivel(Nivel_Energia),.activo(Activo_Comida),.senal_5seg(senal_5segEnergia));
Modo_Primitivo #(1250000000,250000000) Modo_Medicina (.clk(clk), .B_reset(B_Reset), .Entrada(B_Medicina), .Nivel(Nivel_Medicina),.activo(Activo_Medicina),.senal_5seg(senal_5segMedicina));



assign LED_Animo = Nivel_Animo;
assign LED_Descanso = Nivel_Descanso;
assign LED_Energia = Nivel_Energia;
assign LED_Medicina = Nivel_Medicina;
assign Reset_General= B_Reset;
endmodule