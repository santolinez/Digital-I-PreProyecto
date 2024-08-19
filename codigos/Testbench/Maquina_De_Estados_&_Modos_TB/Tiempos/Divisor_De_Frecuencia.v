module Divisor_De_Frecuencia#(parameter Count_max=25000000)(
    input wire clk_50MHz,    // Reloj de entrada de 50 MHz
    input wire reset,        // Señal de reinicio
    output reg clk_1Hz       // Reloj de salida de 1 Hz
);

    reg [$clog2(Count_max):0] counter;      // Contador de 26 bits

    always @(posedge clk_50MHz or posedge reset) begin
        if (~reset) begin
            counter <= 0;
            clk_1Hz <= 0;
        end else if (counter == 50000000 - 1) begin
            counter <= 0;
            clk_1Hz <= ~clk_1Hz;
        end else begin
            counter <= counter + 1;
        end
    end

    Botones_antirebote B_Reset (.reset(reset));

endmodule
