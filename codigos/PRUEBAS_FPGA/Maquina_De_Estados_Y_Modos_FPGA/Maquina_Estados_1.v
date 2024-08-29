
module Maquina_Estados_1 (
    input clk,
    input reset,
    input [1:0] Nivel_Comida,  // Nivel como entrada
    input Boton_Comida,
    input Boton_Medicina,
    input Sensor_UltraSonido,
    input Sensor_Luz,
    output reg [2:0] Visualizacion,

    output reg Activo_Comida,
    output reg Activo_Medicina,


// PARA LA IMPLEMENTACION DE 7 SEGMENTOS
    output reg [0:15] Salida_7seg
);

    

    

    // Declaración de estados
    reg [2:0] Estados;
    reg [2:0] Estado_Siguiente;

    localparam Estado_IDLE = 3'b000;
    localparam Estado_Hambre = 3'b001;
    localparam Estado_Desnutrido = 3'b010;
    localparam Estado_Comiendo = 3'b011;


    // Inicialización
    initial begin
        Estados <= Estado_IDLE;
        Estado_Siguiente <= Estado_IDLE;
        Activo_Comida = 1'b1;
        Activo_Medicina = 1'b1;
        Visualizacion = 3'b000;
        Salida_7seg = 0;
    end

    // Lógica secuencial para actualización de estados
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            Estados <= Estado_IDLE;
        end else begin
            Estados <= Estado_Siguiente;
        end
    end

    // Lógica combinacional para determinar el siguiente estado
    always @(*) begin
        case (Estados)
            Estado_IDLE: begin
                if (Nivel_Comida < 3)
                    Estado_Siguiente <= Estado_Hambre;
                else
                    Estado_Siguiente <= Estado_IDLE;
            end

            Estado_Hambre: begin
                if (Nivel_Comida < 1)
                    Estado_Siguiente <= Estado_Desnutrido;
                else if (Boton_Comida)
                    Estado_Siguiente <= Estado_Comiendo;
                else
                    Estado_Siguiente <= Estado_Hambre;
            end

            Estado_Desnutrido: begin
                if (Boton_Comida)
                    Estado_Siguiente <= Estado_Comiendo;
                else
                    Estado_Siguiente <= Estado_Desnutrido;
            end

            Estado_Comiendo: begin
                if (Boton_Comida)
                    Estado_Siguiente <= Estado_Comiendo;  // Mantenerse en Estado_Comiendo mientras Boton_Comida esté activo
                else if (Nivel_Comida == 3)
                    Estado_Siguiente <= Estado_IDLE;
                else if (Nivel_Comida > 0)
                    Estado_Siguiente <= Estado_Hambre;
                else
                    Estado_Siguiente <= Estado_Desnutrido;
            end

            default: Estado_Siguiente <= Estado_IDLE;
        endcase
    end

    // Lógica secuencial para las salidas
    always @(posedge clk or negedge reset) begin
        Salida_7seg = Visualizacion*10+Nivel_Comida;
        if (~reset) begin
            Activo_Comida <= 1'b1;
            Activo_Medicina <= 1'b1;
            Visualizacion <= 3'b000;
        end else begin
            case (Estado_Siguiente)
                Estado_IDLE: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Visualizacion <= 3'b000;
                end

                Estado_Hambre: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Visualizacion <= 3'b001;
                end

                Estado_Desnutrido: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Visualizacion <= 3'b010;
                end

                Estado_Comiendo: begin
                    Activo_Comida <= 1'b0;
                    Activo_Medicina <= 1'b0;
                    Visualizacion <= 3'b011;
                end
            endcase
        end
    end

endmodule