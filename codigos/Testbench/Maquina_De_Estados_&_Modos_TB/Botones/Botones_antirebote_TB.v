`timescale 1ns / 1ps
`include "Botones/Botones_antirebote.v"

module Botones_antirebote_TB;

	// Inputs
	reg clk;
    reg reset;
    reg test;
    reg b_energia;
    reg b_medicina;

	// Outputs
	wire Senal_Test;
	wire Senal_Energia;
	wire Senal_Medicina;
	wire Senal_Reset;

	// Instantiate the Unit Under Test (UUT)
	Botones_antirebote uut (
	//Señales de control
	.clk(clk),
	
	//Botones
	.reset(reset),
	.test(test),
	.b_energia(b_energia),
	.b_medicina(b_medicina),

	// Salidas
	.Senal_Test(Senal_Test),
	.Senal_Energia(Senal_Energia),
	.Senal_Medicina(Senal_Medicina),
	.Senal_Reset(Senal_Reset)
	);

    initial begin
        clk = 0;
		reset = 0;
    	test = 0;
    	b_energia = 0;
    	b_medicina = 0;
    end

    always #1 clk = ~clk;  
	always #1000 reset = ~reset;
	always #350 test = ~test;
	always #20 b_energia = ~b_energia;
	always #20 b_medicina = ~b_medicina;



    initial begin: TEST_CASE
        $dumpfile("Botones_antirebote.vcd");
        $dumpvars(-1, uut);
        #(900000) $finish;
    end

endmodule