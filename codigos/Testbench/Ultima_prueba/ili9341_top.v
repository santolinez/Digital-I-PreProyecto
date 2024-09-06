

module ili9341_top #(parameter RESOLUTION = 240*240, parameter PIXEL_SIZE = 16, parameter IMAGENES = 5)(
    input wire clk, // 125MHz
    input wire rst,
    input wire [3:0] visua,
    output wire spi_mosi,
    output wire spi_cs,
    output wire spi_sck,
    output wire spi_dc
);

    wire clk_out;
    wire clk_input_data;
    reg [3:0] prev_visua;
    reg [3:0] fsm_state, next_state, escalamiento;
    reg [PIXEL_SIZE-1:0] imagen;
    reg [PIXEL_SIZE-1:0] current_pixel;
    reg [PIXEL_SIZE-1:0] pixel_data_mem[0:(7000)-1];//SI NECESITAN MAS MEMORIA BAJENLE A EL 8000


    reg [$clog2(RESOLUTION)-1:0] pixel_counter;
    reg [$clog2(RESOLUTION)-1:0] pixelactual, pixel_memoria, offset;
    reg transmission_done,Nueva_imagen;
    reg [7:0]counter_horizontal,counter_vertical;

    localparam IDLE = 0;
    localparam HAMBRE=1;
    localparam DESNUTRIDO=2;
    localparam COMIENDO=3;
    localparam TOS=4;
    localparam FIEBRE=5;
    localparam PILDORA=6;
    localparam CANSADO=7;
    localparam DESVELO=8;
    localparam DORMIDO=9;
    localparam TRISTE= 10;
    localparam DEPRESION= 11;
    localparam CARISIA= 12;
    localparam MUERTO= 13;

    initial begin 
        fsm_state <= IDLE;
        pixel_counter <= 'b0;
        transmission_done <= 'b0;
        current_pixel <= 'b0;
        pixel_memoria <= 'b0;
        $readmemh("/home/juandiego43/Escritorio/Material_digital/Proyecto_digital/Prueba3_Maq_estados_sensores/output_files/Imagenes.txt", pixel_data_mem);
        imagen <= pixel_data_mem[0];
        escalamiento <='d0;
        counter_horizontal<= 'b0;
        counter_vertical<= 'b0;
        offset<= 'b0;
        pixelactual<= 'b0;
    end

    freq_divider #(2) freq_divider20MHz (
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
            1: next_state = HAMBRE;
            2: next_state = DESNUTRIDO;
            3: next_state = COMIENDO;
            4: next_state = TOS;
            5: next_state = FIEBRE;
            6: next_state = PILDORA;
            7: next_state = CANSADO;
            8: next_state = DESVELO;
            9: next_state = DORMIDO;
            10: next_state = TRISTE;
            11: next_state = DEPRESION;
            12: next_state = CARISIA;
            13: next_state = MUERTO;
            default: next_state = IDLE;
        endcase
    end


    always @(posedge clk_input_data) begin
        if (!rst) begin
            counter_horizontal<= 'b0;
            counter_vertical<= 'b0;
            offset<= 'b0;
            pixelactual<= 'b0;
        end else begin
            if (visua != prev_visua) begin
                Nueva_imagen <= 1'b1; // Hold high until acted upon
            end else if(pixel_counter==0) begin
                Nueva_imagen <= 1'b0;
            end 
            prev_visua <= visua;

            if (transmission_done) begin
            counter_horizontal <= 'b0;
            counter_vertical <= 'b0;
            offset <= 'b0;
        end else begin
            
            counter_horizontal<=counter_horizontal+1; 
            if(counter_horizontal =='d239 )begin
            counter_vertical<=counter_vertical+'b1;
            counter_horizontal<=0;
            end
            if(counter_vertical =='d239) begin
            counter_vertical<=0;
            end
        end
           pixelactual <= (counter_vertical * 240) + counter_horizontal;

            case(fsm_state)
                IDLE: offset<=0;
                HAMBRE:  begin
                if (pixelactual >= 28800 && pixelactual < 33600) begin
                    offset <= 2305 - 1152;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                DESNUTRIDO:  begin
                if (pixelactual >= 28800 && pixelactual < 33600) begin
                    offset <= 2305 - 1152;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                COMIENDO:   begin
                if (pixelactual >= 27600 && pixelactual < 40800) begin
                    offset <= 2498 - 1104;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                TOS:   begin
                if (pixelactual >= 25200 && pixelactual < 33600) begin
                    offset <= 3027 - 1008;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                FIEBRE:   begin
                if (pixelactual >= 25200 && pixelactual < 33600) begin
                    offset <= 3027 - 1008;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                PILDORA:   begin
                if (pixelactual >= 28800 && pixelactual < 34800) begin
                    offset <= 3364 - 1152;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                CANSADO:   begin
                if (pixelactual >= 1200 && pixelactual < 24000) begin
                    offset <= 3605 - 48;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                 DESVELO:   begin
                if (pixelactual >= 1200 && pixelactual < 24000) begin
                    offset <= 3605 - 48;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                 DORMIDO:   begin
                if (pixelactual >= 1200 && pixelactual < 27600) begin
                    offset <= 4518 - 1200;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                 TRISTE:   begin
                if (pixelactual >= 26400 && pixelactual < 31200) begin
                    offset <= 5575 - 1056;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                 DEPRESION:   begin
                if (pixelactual >= 26400 && pixelactual < 31200) begin
                    offset <= 5575 - 1056;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                 CARISIA:   begin
                if (pixelactual >= 1200 && pixelactual < 22800) begin
                    offset <= 5768 - 48;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                MUERTO:   begin
                if (pixelactual >= 2400 && pixelactual < 55200) begin
                    offset <= 6633 - 96;  // Apply the desired offset
                end else begin
                    offset <= 0;
                end
            end
                default: offset<=0; // Azul oscuro
            endcase
        end
    end
    always @(posedge clk_out)begin
    pixel_memoria <= ((counter_horizontal / 5) + (counter_vertical / 5) * 48) + offset;
    imagen <= pixel_data_mem[pixel_memoria];
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