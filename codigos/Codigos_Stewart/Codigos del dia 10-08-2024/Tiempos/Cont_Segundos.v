module Cont_Segundos (
    input wire clk_1Hz,     // Reloj de 1 Hz
    input wire reset,       // Señal de reinicio
    output reg [5:0] segundos,  // Contador de segundos (0-59)
    output reg [3:0] parametro // Parámetro que disminuye cada 15 segundos
);

    always @(posedge clk_1Hz or posedge reset) begin
        if (reset) begin
            segundos <= 0;
            parametro <= 15;  // Inicializamos el parámetro en 15, puedes ajustar esto según tus necesidades
        end else begin
            if (segundos == 59) begin
                segundos <= 0;
            end else begin
                segundos <= segundos + 1;
            end

            if (segundos % 15 == 0 && segundos != 0) begin
                parametro <= parametro - 1;
            end
        end
    end

endmodule
