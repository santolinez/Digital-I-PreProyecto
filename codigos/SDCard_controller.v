`include "spi_master.v"

module SDCard_controller#(parameter DATA_SIZE = 9, parameter STATES = 12, parameter PIXEL_SIZE = 16)(
        input  wire clk,    
        input  wire rst,
        input  wire [PIXEL_SIZE-1:0] input_data, 
        input  wire frame_done, 
        output wire spi_mosi,
        output wire spi_sck,
        output wire spi_cs,
        output wire spi_dc,
        output wire data_clk
    );

    localparam INIT_SEQ_LEN = 84;
    localparam DELAY_100ms = 1;  // 2500000 Clock cycles to achive 100ms wait

    reg[DATA_SIZE-1:0] spi_data;
    reg available_data;
    reg data_byte_flag;

    reg [$clog2(STATES)-1:0] fsm_state;
    reg [$clog2(STATES)-1:0] next_state;

    reg[DATA_SIZE-1:0] INIT_SEQ [0:INIT_SEQ_LEN-1];
    
    reg [$clog2(INIT_SEQ_LEN)-1:0] config_counter;
    reg [$clog2(DELAY_100ms)-1:0] delay_counter;

    wire en_delay_100ms;

    reg [3:0] next_config;

    localparam START = 0;

    spi_master spi(
		.clk(clk), 
        .rst(rst),
        .spi_mosi(spi_mosi),
		.spi_sck(spi_sck), 
        .spi_cs(spi_cs), 
        .spi_dc(spi_dc), 
		.input_data(spi_data),
        .available_data(available_data),
        .idle(idle)
    );

    localparam CMD0 =  8'h40;  // Software Reset
    // Extend register commands
    localparam CMD8 = 8'h48;  //Chechks SD version
    localparam CMD55 = 8'h77; //Application Command (Prepares the card to receive command)
    localparam ACMD41 = 8'h77; 
    localparam CMD58 = 8'h69; 
    localparam CMD16 = 8'h50; 
    localparam Send_If_Cond = 8'h40; 
    localparam Send_If_Cond = 8'h40; 
    localparam Send_If_Cond = 8'h40; 
    
    
    initial begin
        fsm_state <= START;
        next_state <= START;
      
    end
    
    initial begin
        INIT_SEQ [0] = {1'b0, CMD0};
        INIT_SEQ [1] = {1'b1, 8'h00};
        INIT_SEQ [2] = {1'b1, 8'h00};                     
        INIT_SEQ [3] = {1'b1, 8'h00}; 
        INIT_SEQ [4] = {1'b1, 8'h00};
        INIT_SEQ [5] = {1'b1, 8'h95};
        INIT_SEQ [6] = {1'b0, CMD8};
        INIT_SEQ [7] = {1'b1, 8'h00};
        INIT_SEQ [8] = {1'b1, 8'h00};                     
        INIT_SEQ [9] = {1'b1, 8'h01}; 
        INIT_SEQ [10] = {1'b1, 8'hAA};
        INIT_SEQ [11] = {1'b1, 8'h87};
        INIT_SEQ [12] = {1'b0, CMD55};
        INIT_SEQ [13] = {1'b1, 8'h00};
        INIT_SEQ [14] = {1'b1, 8'h00};                     
        INIT_SEQ [15] = {1'b1, 8'h00}; 
        INIT_SEQ [16] = {1'b1, 8'h00};
        INIT_SEQ [17] = {1'b1, 8'hFF};
        INIT_SEQ [18] = {1'b0, CMD16};
        INIT_SEQ [19] = {1'b1, 8'h00};
        INIT_SEQ [20] = {1'b1, 8'h00};                     
        INIT_SEQ [21] = {1'b1, 8'h02}; 
        INIT_SEQ [22] = {1'b1, 8'h00};
        INIT_SEQ [23] = {1'b1, 8'hFF};      
    end 

    always @(negedge clk)begin
        if(rst==0) begin
            fsm_state <= START;
        end else begin
            fsm_state <= next_state;
        end
    end


endmodule