//`include "Top/boton_antirebote.v"

module Botones_antirebote(
	input reset,
	input clk,
	input test,
	input b_comida,
	input b_medicina,
	output reg led1,
	output reg led2,
	output reg led3
);


wire test_tmp;
wire comida_tmp;
wire medicina_tmp;

Boton_AR #(500000000) B_Test ( .reset(reset), .clk(clk), .boton_in(test), .boton_out(test_tmp));
Boton_AR #(1500000) B_Medicina (.reset(reset), .clk(clk), .boton_in(b_medicina), .boton_out(medicina_tmp));
Boton_AR #(1500000) B_Comida ( .reset(reset), .clk(clk), .boton_in(b_comida), .boton_out(comida_tmp));

always @(posedge test_tmp) begin
	led1=~led1;
end

always @(posedge comida_tmp) begin
	led2=~led2;
end

always @(posedge medicina_tmp) begin
	led3=~led3;
end


endmodule