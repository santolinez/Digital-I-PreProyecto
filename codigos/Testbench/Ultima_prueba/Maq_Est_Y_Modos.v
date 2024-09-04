`include "Maquina_Estados_1.v"
`include "Modos.v"
`include "display.v"
`include "ili9341_top.v"
module Maq_Est_Y_Modos (

    input clk,
    input reset,
    input Boton_Test,
    input Boton_Comida,
    input Boton_Medicina,
    input Ultra_sonido,
    input Foto_celda,

    output [0:6]sseg,
    output [4:0]an,
    output wire spi_mosi,
    output wire spi_cs,
    output wire spi_sck,
    output wire spi_dc  


);


// Salidas Modos -- Entradas Estados

wire Senal_Reset;

wire Senal_5Seg_Comida;
wire Senal_5Seg_Medicina;
wire Senal_5Seg_Descanso;
wire Senal_5Seg_Animo;
wire Senal_Test;
wire Senal_MTest;

wire [1:0] Cable_Niveles_Medicina;
wire [1:0] Cable_Niveles_Comida;
wire [1:0] Cable_Niveles_Descanso;
wire [1:0] Cable_Niveles_Animo;



// Salidas Estados -- Entradas Modos/ili
wire [3:0] Visualizacion;


wire Senal_Activo_Comida;
wire Senal_Activo_Medicina;
wire Senal_Activo_Descanso;
wire Senal_Activo_Animo;

wire [0:15]Siete_Segmentos;


ili9341_top ili9341(
.clk(clk),
.rst(Senal_Reset),
.visua(Visualizacion),
.spi_mosi(spi_mosi),
.spi_cs(spi_cs),
.spi_sck(spi_sck),
.spi_dc(spi_dc)
);

Maquina_Estados_1 maq_est(
    .clk(clk), 

    .reset(Senal_Reset),

    .Senal_Test(Senal_Test),
    .Senal_MTest(Senal_MTest),

    .Boton_Comida(Senal_5Seg_Comida),
    .Boton_Medicina(Senal_5Seg_Medicina),
    .Sensor_Luz(Senal_5Seg_Descanso),
    .Sensor_UltraSonido(Senal_5Seg_Animo),

    //Niveles
    .Nivel_Comida(Cable_Niveles_Comida),
    .Nivel_Salud(Cable_Niveles_Medicina),
    .Nivel_Descanso(Cable_Niveles_Descanso),
    .Nivel_Animo(Cable_Niveles_Animo),
    //Activos
    .Activo_Comida(Senal_Activo_Comida),
    .Activo_Medicina(Senal_Activo_Medicina),
    .Activo_SensorLuz(Senal_Activo_Descanso),
    .Activo_UltraSonido(Senal_Activo_Animo),
    //Salidas Visualizacion
    .Salida_7seg(Siete_Segmentos),
	 .Visualizacion(Visualizacion)
);

Modos mods(
    .clk(clk),

    //Reset
    .Bot_Reset(reset),
    .Reset_General(Senal_Reset),

    //Test
    .Bot_Test(Boton_Test),
    .Senal_Test(Senal_Test),
    .Senal_MTest(Senal_MTest),

    // Entradas Botones Modos 
    .Bot_Energia(Boton_Comida),
    .Bot_Medicina(Boton_Medicina),
    .senal_5segEnergia(Senal_5Seg_Comida),
    .senal_5segMedicina(Senal_5Seg_Medicina),
    

    // Entradas Sensores Modos
    .Entrada_Descanso(Foto_celda),
    .Entrada_Animo(Ultra_sonido),
    .senal_5segDescanso(Senal_5Seg_Descanso),
    .senal_5segAnimo(Senal_5Seg_Animo),

    //Activos
    .Activo_Comida(Senal_Activo_Comida),
    .Activo_Medicina(Senal_Activo_Medicina),
    .Activo_Descanso(Senal_Activo_Descanso),
    .Activo_Carisia(Senal_Activo_Animo),

    //Senales Niveles
    .LED_Energia(Cable_Niveles_Comida),
    .LED_Medicina(Cable_Niveles_Medicina),
    .LED_Descanso(Cable_Niveles_Descanso),
    .LED_Animo(Cable_Niveles_Animo)  
);

display Display_MyM (
    .clk(clk),
    .rst(Senal_Reset),
    .num(Siete_Segmentos),
    .sseg(sseg),
    .an(an)
);

endmodule