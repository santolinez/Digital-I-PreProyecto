`timescale 1ns / 1ps
`include "Botones/Boton_AR.v"

module Boton_AR_TB;

    reg clk;
    reg reset;
	reg boton_in;
	wire boton_out;


    Boton_AR uut(
        .clk(clk),
        .reset(reset),
        .boton_in(boton_in),
        .boton_out(boton_out)
    );

    initial begin
        clk = 0;
        reset = 1;
        reset = 0;
        boton_in = 0;
    end

    always #1 clk = ~clk; // Cambia cada nanosegundo (1ns)

    always #15 boton_in = ~boton_in; // Cada 10 flancos de subida la señal cambia [#20 es cada 20ns]

    
    always #80 reset = ~reset; 

    initial begin: TEST_CASE
        $dumpfile("Boton_AR.vcd");
        $dumpvars(-1, uut);
        #(2000) $finish;
    end

endmodule