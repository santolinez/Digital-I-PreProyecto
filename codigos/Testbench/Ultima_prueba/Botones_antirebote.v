//`include "Boton_AR.v"
//`include "Sensor_AR.v"

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

	output Senal_Btest_BAR,
	output reg Senal_test_activado,
	output reg Senal_Energia,
	output reg Senal_Medicina,
	output reset_tmp,
	output senal_test_fil,
	output reg Senal_fot,
	output reg Senal_ultrasonido
);

initial begin

	Senal_test_activado=0;
	Senal_Energia=0;
	Senal_Medicina=0;
	Senal_ultrasonido=0;
	Senal_fot=0;
end

wire testMT_tmp;
wire test_tmp;
wire energia_tmp;
wire medicina_tmp;
wire sensor_ult_out;
wire sensor_fot_out;

Sensor_AR #(250000000) B_Reset (.reset(1'b1), .clk(clk), .sensor_in(reset), .sensor_out(reset_tmp));  // parametro = 250000000
Boton_AR #(125000000) B_MTest (.reset(reset_tmp), .clk(clk), .boton_in(test), .boton_out(testMT_tmp));
Boton_AR #(10000) B_Test (.reset(reset_tmp), .clk(clk), .boton_in(test), .boton_out(test_tmp));	  // parametro = 250000000
Boton_AR #(10000) B_Medicina (.reset(reset_tmp), .clk(clk), .boton_in(b_medicina), .boton_out(medicina_tmp)); // parametro = 50000
Boton_AR #(10000) B_Energia (.reset(reset_tmp), .clk(clk), .boton_in(b_energia), .boton_out(energia_tmp)); // parametro = 50000
Sensor_AR #(125000000) Sensor_ultrasonido(.reset(reset_tmp),.clk(clk) ,.sensor_in(sensor_ult_in) ,.sensor_out(sensor_ult_out));
Sensor_AR #(125000000) Sensor_fotocel(.reset(reset_tmp),.clk(clk) ,.sensor_in(sensor_fot_in) ,.sensor_out(sensor_fot_out));



always @(negedge sensor_fot_out) begin
	Senal_fot=~Senal_fot;
end

always @(negedge sensor_ult_out) begin
	Senal_ultrasonido=~Senal_ultrasonido;
end


always @(negedge testMT_tmp or negedge reset_tmp) begin
	if(reset_tmp == 0) begin
		Senal_test_activado = 0;
	end else begin
		Senal_test_activado=~Senal_test_activado;
	end
end

always @(negedge energia_tmp) begin
	Senal_Energia=~Senal_Energia;
end

always @(negedge medicina_tmp) begin
	Senal_Medicina=~Senal_Medicina;
end


// NOTAS REVISAR SI ESTE RESET_TMP DEBERIA ESTAR CONECTADO A TODO
//always @(negedge reset_tmp) begin
	//Senal_test_activado=0;
//end 
//
assign senal_test_fil=test_tmp;
assign Senal_Btest_BAR=Senal_Energia;
endmodule