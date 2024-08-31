`include "ili9341_controller.v"
`include "freq_divider.v"

module ili9341_top #(parameter RESOLUTION = 10*10, parameter PIXEL_SIZE = 16, parameter IMAGENES = 5)(
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
    reg [2:0] prev_visua;
    reg [2:0] fsm_state, next_state, escalamiento;
    reg [PIXEL_SIZE-1:0] imagen;
    reg [PIXEL_SIZE-1:0] current_pixel;
    reg [PIXEL_SIZE-1:0] pixel_data_mem[0:RESOLUTION-1];

    reg [$clog2(RESOLUTION)-1:0] pixel_counter;
    reg [$clog2(RESOLUTION)-1:0] pixel_memoria;
    reg transmission_done,Nueva_imagen;
    reg [1:0]counter_horizontal,counter_vertical;

    localparam IDLE = 0;
    localparam TRISTE = 1;
    localparam CARINO = 2;
    localparam DEPRIMIDO = 3;
    localparam MUERTO = 4;

    initial begin 
        imagen <= 'h07FF;
        fsm_state <= IDLE;
        pixel_counter <= 'b0;
        transmission_done <= 'b0;
        current_pixel <= 'b0;
        pixel_memoria <= 'b0;
        $readmemh("C:/Users/otro/Documents/Mecatronica/6-Sexto-Semestre/DigitalI/Proyecto/ILI/PolloBorroso_80x80.txt", pixel_data_mem);
        escalamiento <='d0;
        counter_horizontal<= 'b0;
        counter_vertical<= 'b0;

    end

    freq_divider #(1) freq_divider20MHz (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );  


    always @(posedge clk_out) begin
        if (!rst) begin
            fsm_state <= IDLE;
        end else  if (transmission_done) begin
            fsm_state <= next_state;
        end
    end

    always @(*) begin
        case(visua)
            0: next_state = IDLE;
            1: next_state = TRISTE;
            2: next_state = CARINO;
            3: next_state = DEPRIMIDO;
            4: next_state = MUERTO;
            default: next_state = IDLE;
        endcase
    end


    always @(posedge clk_input_data) begin
        if (!rst) begin
            escalamiento <='d0;
            counter_horizontal<= 'b0;
            counter_vertical<= 'b0;
        end else begin
            if (visua != prev_visua) begin
                Nueva_imagen <= 1'b1; // Hold high until acted upon
            end else if(pixel_counter==0) begin
                Nueva_imagen <= 1'b0;
            end 
            prev_visua <= visua;
            case(fsm_state)
                IDLE: begin
                        case(escalamiento)
                        'd0: begin
                            imagen <= pixel_data_mem[pixel_memoria];
                            counter_horizontal <= counter_horizontal+1;
                            if(counter_horizontal==1)
                            begin 
                                escalamiento<= 'd1;
                            end
                        end
                        'd1: begin
                            pixel_memoria<=pixel_memoria+'b1;
                            if(pixel_memoria % 'd80==0 && pixel_memoria!='b0)begin
                                counter_vertical<=counter_vertical+'b1;
                                if(counter_vertical==1)begin 
                                    escalamiento<= 'd3; 
                                end else begin 
                                    escalamiento<= 'd2; 
                                end
                            end else begin
                                counter_horizontal <= 'b0;
                                escalamiento<= 'd0;
                            end
                        end
                        'd2: begin
                            pixel_memoria<=pixel_memoria-'d80;
                            counter_horizontal <= 'b0;
                            escalamiento<= 'd0;
                        end
                        'd3: begin
                            pixel_memoria<=pixel_memoria+'b1;
                            counter_vertical<=0;
                            counter_horizontal <= 'b0;
                            escalamiento<= 'd0;
                        end
                    endcase   
                end
                TRISTE: imagen <= 'h07FF; // Azul clarito
                CARINO: imagen <= 'hF800; // Rojo
                DEPRIMIDO: imagen <= 'h780F; // Morado
                MUERTO: imagen <= 'h0000; // Negro
                default: imagen <= 'h001F; // Azul oscuro
            endcase
        end
    end


    always @(posedge clk_input_data) begin
        if (!rst) begin
            pixel_counter <= 'b0;
            transmission_done <= 'b0;
            current_pixel <= 'b0;
        end else begin
            if (!transmission_done) begin
                current_pixel <= imagen; 
                pixel_counter <= pixel_counter + 1;
                if (pixel_counter == RESOLUTION - 1) begin
                    transmission_done <= 1;
                end
            end else if (Nueva_imagen) begin
                transmission_done <= 'b0;
                pixel_counter <= 'b0;
                current_pixel <= imagen; 	
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
