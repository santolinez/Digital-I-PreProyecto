`include "Boton_AR.v"
`include "Sensor_AR.v"

module Botones_antirebote(
	//Señales de control
	input clk,
	
	//Botones
	input reset,
	input test,
	input b_energia,
	input b_medicina,
	input sensor_ult_in,
	input sensor_fot_in,

	// Salidas
	output reg Senal_Test,
	output reg Senal_Energia,
	output reg Senal_Medicina,
	output reset_tmp,
	output reg Senal_fot,
	output reg Senal_ultrasonido
);

initial begin
	Senal_Test=0;
	Senal_Energia=0;
	Senal_Medicina=0;
	Senal_ultrasonido=0;
	Senal_fot=0;
end

wire test_tmp;
wire energia_tmp;
wire medicina_tmp;
wire reset_tmp;
wire sensor_ult_out;
wire sensor_fot_out;

Sensor_AR #(7) B_Reset ( .clk(clk), .sensor_in(reset), .sensor_out(reset_tmp));  // parametro = 250000000
Boton_AR #(5) B_Test (.reset(reset), .clk(clk), .boton_in(test), .boton_out(test_tmp));	  // parametro = 250000000
Boton_AR #(5) B_Medicina (.reset(reset), .clk(clk), .boton_in(b_medicina), .boton_out(medicina_tmp)); // parametro = 50000
Boton_AR #(5) B_Energia (.reset(reset), .clk(clk), .boton_in(b_energia), .boton_out(energia_tmp)); // parametro = 50000
Sensor_AR #(10) Sensor_ultrasonido(.reset(reset),.clk(clk) ,.sensor_in(sensor_ult_in) ,.sensor_out(sensor_ult_out));
Sensor_AR #(10) Sensor_fotocel(.reset(reset),.clk(clk) ,.sensor_in(sensor_fot_in) ,.sensor_out(sensor_fot_out));


always @(negedge sensor_fot_out) begin
	Senal_fot=~Senal_fot;
end

always @(negedge sensor_ult_out) begin
	Senal_ultrasonido=~Senal_ultrasonido;
end

always @(negedge test_tmp) begin
	Senal_Test=~Senal_Test;
end

always @(negedge energia_tmp) begin
	Senal_Energia=~Senal_Energia;
end

always @(negedge medicina_tmp) begin
	Senal_Medicina=~Senal_Medicina;
end

/* 
always @(negedge reset_tmp) begin
	Senal_Reset=~Senal_Reset;
end  
*/


endmodule