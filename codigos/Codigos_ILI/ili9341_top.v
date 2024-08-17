//`include "ili9341_controller.v"
//`include "freq_divider.v"

module ili9341_top #(parameter RESOLUTION = 320*240, parameter PIXEL_SIZE = 16, parameter IMAGENES = 5)(
    input wire clk, // 125MHz
    input wire rst,
    input wire [2:0] visua,
    output wire spi_mosi,
    output wire spi_cs,
    output wire spi_sck,
    output wire spi_dc
);

    wire clk_out;
    wire clk_input_data;
    reg [2:0] fsm_state, next_state;
    reg [PIXEL_SIZE-1:0] imagen;
    reg [PIXEL_SIZE-1:0] current_pixel;
    reg [PIXEL_SIZE-1:0] pixel_data_mem[0:RESOLUTION-1];

    reg [$clog2(RESOLUTION)-1:0] pixel_counter;
    reg transmission_done;

    localparam IDLE = 0;
    localparam TRISTE = 1;
    localparam CARINO = 2;
    localparam DEPRIMIDO = 3;
    localparam MUERTO = 4;

    initial begin 
        imagen <= 'h07FF;
        fsm_state <= IDLE;
    end
    
    freq_divider #(2) freq_divider20MHz (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );  

    // FSM State Transition
    always @(posedge clk_input_data) begin
        if (!rst) begin
            fsm_state <= IDLE;
        end else  //if (transmission_done) begin
            fsm_state <= next_state;
        //end
    end

    // Next State Logic
    always @(*) begin
        case(fsm_state)
            IDLE: next_state = (visua == 0) ? IDLE : TRISTE;
            TRISTE: next_state = (visua == 1) ? TRISTE : CARINO;
            CARINO: next_state = (visua == 2) ? CARINO : DEPRIMIDO;
            DEPRIMIDO: next_state = (visua == 3) ? DEPRIMIDO : MUERTO;
            MUERTO: next_state = (visua == 4) ? MUERTO : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Image Assignment Based on FSM State
    always @(posedge clk_input_data) begin
        if (!rst) begin
            imagen <= 'h001F; // Azul oscuro
        end else begin
            case(fsm_state)
                IDLE: imagen <= 'hFFE0; // Amarillo
                TRISTE: imagen <= 'h07FF; // Azul clarito
                CARINO: imagen <= 'hF800; // Rojo
                DEPRIMIDO: imagen <= 'h780F; // Morado
                MUERTO: imagen <= 'h0000; // Negro
                default: imagen <= 'h001F; // Azul oscuro
            endcase
        end
    end

    // Pixel Data and Transmission Control
    always @(posedge clk_input_data) begin
        if (!rst) begin
            pixel_counter <= 'b0;
            transmission_done <= 'b0;
            current_pixel <= 'b0;
        end else begin
            if (!transmission_done) begin
                current_pixel <= imagen; // Use the selected image color
                pixel_counter <= pixel_counter + 1;
                if (pixel_counter == RESOLUTION - 1) begin
                    transmission_done <= 1;
                end
            end else begin
                transmission_done <= 0; // Reset transmission_done for next frame
            end
        end
    end

    ili9341_controller ili9341(
        .clk(clk_out), 
        .rst(rst),
        .frame_done(transmission_done), 
        .input_data(current_pixel),
        .spi_mosi(spi_mosi),
        .spi_sck(spi_sck), 
        .spi_cs(spi_cs), 
        .spi_dc(spi_dc),
        .data_clk(clk_input_data)
    );

endmodule
