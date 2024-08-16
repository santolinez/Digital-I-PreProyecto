//`include "ili9341_controller.v"
//`include "freq_divider.v"


module ili9341_top #(parameter RESOLUTION = 320*240, parameter PIXEL_SIZE = 16)(
        input wire clk, //125MHz
        input wire rst,
        output wire spi_mosi,
        output wire spi_cs,
        output wire spi_sck,
        output wire spi_dc
    );

    wire clk_out;
    wire clk_input_data;
	 reg [PIXEL_SIZE-1:0] AMARILLO;
    reg [PIXEL_SIZE-1:0] current_pixel;
    reg [PIXEL_SIZE-1:0] pixel_data_mem[0:RESOLUTION-1];

    reg [$clog2(RESOLUTION)-1:0] pixel_counter;
    reg transmission_done;

   // initial begin
   //     current_pixel <= 'b0;
   //     $readmemh("C:/Users/otro/Documents/Mecatronica/6-Sexto-Semestre/DigitalI/Proyecto/ILI/PolloTroste_320x240.txt", pixel_data_mem);
   //     pixel_counter <= 'b0;
   //     transmission_done <= 'b0; 
   // end

    freq_divider #(2) freq_divider20MHz (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );  

    always @(posedge clk_input_data or posedge rst) begin
        if (rst) begin
				AMARILLO='h07FF;
            pixel_counter <= 'b0;
            current_pixel <= 'b0;
            transmission_done <= 'b0; 
        end else if (!transmission_done) begin
            current_pixel <= AMARILLO; //pixel_data_mem[pixel_counter];
            pixel_counter <= pixel_counter + 'b1;
            if (pixel_counter == RESOLUTION-1) begin
                transmission_done <= 'b1; 
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