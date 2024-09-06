
module ili9341_controller#(parameter DATA_SIZE = 9, parameter STATES = 12, parameter PIXEL_SIZE = 16)(
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
    localparam DELAY_100ms = 2500000;  // 2500000 Clock cycles to achive 100ms wait

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
    localparam SEND_INIT = 1;
    localparam WAIT1 = 2;
    localparam SEND_CONFIG = 3;
    localparam WAIT2 = 4;
    localparam DISPLAY_ON = 5;
    localparam WAIT3 = 6;
    localparam SET_ROTATION = 7;
    localparam SET_ADRRESS = 8;
    localparam FRAME_LOOP = 9;
    localparam WAIT_FRAME = 10;

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

    localparam ILI9341_SWRESET       =  8'h01;  // Software Reset
    // Extend register commands
    // ---------------------------------------------------------------
    localparam ILI9341_LCD_POWERA    =  8'hCB;   // Power control A register
    localparam ILI9341_LCD_POWERB    =  8'hCF;   // Power control B register
    localparam ILI9341_LCD_DTCA      =  8'hE8;   // Driver timing control A
    localparam ILI9341_LCD_DTCB      =  8'hEA;   // Driver timing control B
    localparam ILI9341_LCD_POWER_SEQ =  8'hED;   // Power on sequence register
    localparam ILI9341_LCD_3GAMMA_EN =  8'hF2;   // 3 Gamma enable register
    localparam ILI9341_LCD_PRC       =  8'hF7;   // Pump ratio control register
    // ---------------------------------------------------------------
    localparam ILI9341_PWCTR1        =  8'hC0;   ///< Power Control 1
    localparam ILI9341_PWCTR2        =  8'hC1;   ///< Power Control 2
    localparam ILI9341_PWCTR3        =  8'hC2;   ///< Power Control 3
    localparam ILI9341_PWCTR4        =  8'hC3;   ///< Power Control 4
    localparam ILI9341_PWCTR5        =  8'hC4;   ///< Power Control 5
    localparam ILI9341_VMCTR1        =  8'hC5;   ///< VCOM Control 1
    localparam ILI9341_VMCTR2        =  8'hC7;   ///< VCOM Control 2
    // ---------------------------------------------------------------
    localparam ILI9341_PLTAR         =  8'h30;  // Partial Area
    localparam ILI9341_VSCRDEF       =  8'h33;  // Vertical Scroll Definitio
    localparam ILI9341_TEOFF         =  8'h34;  // Tearing Effect Line OFF
    localparam ILI9341_TEON          =  8'h35;  // Tearing Effect Line ON
    localparam ILI9341_MADCTL        =  8'h36;  // Memory Access Control
    localparam ILI9341_VSCRADD       =  8'h37;  // Vertical Scrolling Start Address
    localparam ILI9341_IDMOFF        =  8'h38;  // Idle Mode OFF
    localparam ILI9341_IDMON         =  8'h39;  // Idle Mode ON
    localparam ILI9341_COLMODPIXFMT  =  8'h3A;  // Pixel Format Set
    localparam ILI9341_WMCON         =  8'h3C;  // Write Memory Continue
    localparam ILI9341_RMCON         =  8'h3E;  // Read Memory Continue
    // ---------------------------------------------------------------
    localparam ILI9341_FRMCRN1       =  8'hB1;  // Frame Control (In Normal Mode)
    localparam ILI9341_FRMCRN2       =  8'hB2;  // Frame Control (In Idle Mode)
    localparam ILI9341_FRMCRN3       =  8'hB3;  // Frame Control (In Partial Mode)
    localparam ILI9341_INVTR         =  8'hB4;  // Display Inversion Control
    localparam ILI9341_PRCTR         =  8'hB5;  // Blanking Porch Control
    localparam ILI9341_DISCTRL       =  8'hB6;  // Display Function Control
    localparam ILI9341_ETMOD         =  8'hB7;  // Entry Mode Set
    localparam ILI9341_BKCR1         =  8'hB8;  // Backlight Control 1
    localparam ILI9341_BKCR2         =  8'hB9;  // Backlight Control 2
    localparam ILI9341_BKCR3         =  8'hBA;  // Backlight Control 3
    localparam ILI9341_BKCR4         =  8'hBB;  // Backlight Control 4
    localparam ILI9341_BKCR5         =  8'hBC;  // Backlight Control 5
    localparam ILI9341_BKCR7         =  8'hBE;  // Backlight Control 7
    localparam ILI9341_BKCR8         =  8'hBF;  // Backlight Control 8
    // ---------------------------------------------------------------
    localparam ILI9341_GMCTRP1       =  8'hE0;  // Positive Gamma Correction
    localparam ILI9341_GMCTRN1       =  8'hE1;  // Neagtove Gamma Correction
    // ---------------------------------------------------------------
    localparam ILI9341_SLPIN         =  8'h10;  // Enter Sleep Mode
    localparam ILI9341_SLPOUT        =  8'h11;  // Sleep Out
    localparam ILI9341_PTLON         =  8'h12;  // Partial Mode On
    localparam ILI9341_NORON         =  8'h13;  // Normal Display On
    // ---------------------------------------------------------------
    localparam ILI9341_DINVOFF       =  8'h20;  // Dislpay Inversion Off
    localparam ILI9341_DINVON        =  8'h21;  // Dislpay Inversion On
    localparam ILI9341_GAMMASET      =  8'h26;  // Gamma Set  
    localparam ILI9341_DISPOFF       =  8'h28;  // Display OFF
    localparam ILI9341_DISPON        =  8'h29;  // Display ON
    localparam ILI9341_CASET         =  8'h2A;  // Column Address Set
    localparam ILI9341_PASET         =  8'h2B;  // Page Address Set
    localparam ILI9341_RAMWR         =  8'h2C;  // Memory Write
    localparam ILI9341_RGBSET        =  8'h2D;  // Color Set
    localparam ILI9341_RAMRD         =  8'h2E;  // Memory Read
    // ---------------------------------------------------------------
    localparam MADCTL_MY             =  8'h80;  ///< Bottom to top
    localparam MADCTL_MX             =  8'h40;  ///< Right to left
    localparam MADCTL_MV             =  8'h20;  ///< Reverse Mode
    localparam MADCTL_ML             =  8'h10;  ///< LCD refresh Bottom to top
    localparam MADCTL_RGB            =  8'h00; ///< Red-Green-Blue pixel order
    localparam MADCTL_BGR            =  8'h08; ///< Blue-Green-Red pixel order
    localparam MADCTL_MH             =  8'h04;  ///< LCD refresh right to left

    initial begin
        fsm_state <= START;
        next_state <= START;
        config_counter <= 'b0;
        spi_data <= 'b0;
        delay_counter <= 'b0;
        available_data <= 'b0;
        next_config <= 'b0;
        data_byte_flag <= 1'b1;
    end
    
    initial begin
        INIT_SEQ [0] = {1'b0, ILI9341_LCD_POWERA};
        INIT_SEQ [1] = {1'b1, 8'h39};
        INIT_SEQ [2] = {1'b1, 8'h2C};                     
        INIT_SEQ [3] = {1'b1, 8'h00}; 
        INIT_SEQ [4] = {1'b1, 8'h34};
        INIT_SEQ [5] = {1'b1, 8'h02};  
        INIT_SEQ [6] = {1'b0, ILI9341_LCD_POWERB}; 
        INIT_SEQ [7] = {1'b1, 8'h00}; 
        INIT_SEQ [8] = {1'b1, 8'hC1};
        INIT_SEQ [9] = {1'b1, 8'h30};
        INIT_SEQ [10] = {1'b0, ILI9341_LCD_DTCA}; 
        INIT_SEQ [11] = {1'b1, 8'h85};
        INIT_SEQ [12] = {1'b1, 8'h00};
        INIT_SEQ [13] = {1'b1, 8'h78};
        INIT_SEQ [14] = {1'b0, ILI9341_LCD_DTCB};
        INIT_SEQ [15] = {1'b1, 8'h00}; 
        INIT_SEQ [16] = {1'b1, 8'h00};
        INIT_SEQ [17] = {1'b0, ILI9341_LCD_POWER_SEQ};
        INIT_SEQ [18] = {1'b1, 8'h64};   
        INIT_SEQ [19] = {1'b1, 8'h03};   
        INIT_SEQ [20] = {1'b1, 8'h12};   
        INIT_SEQ [21] = {1'b1, 8'h81};   
        INIT_SEQ [22] = {1'b0, ILI9341_LCD_PRC};   
        INIT_SEQ [23] = {1'b1, 8'h20};   
        INIT_SEQ [24] = {1'b0, ILI9341_PWCTR1};   
        INIT_SEQ [25] = {1'b1, 8'h23};   
        INIT_SEQ [26] = {1'b0, ILI9341_PWCTR2};   
        INIT_SEQ [27] = {1'b1, 8'h10};   
        INIT_SEQ [28] = {1'b0, ILI9341_VMCTR1};   
        INIT_SEQ [29] = {1'b1, 8'h3E};
        INIT_SEQ [30] = {1'b1, 8'h28};
        INIT_SEQ [31] = {1'b0, ILI9341_VMCTR2};   
        INIT_SEQ [32] = {1'b1, 8'h86};
        INIT_SEQ [33] = {1'b0, ILI9341_MADCTL};   
        INIT_SEQ [34] = {1'b1, 8'h48};
        INIT_SEQ [35] = {1'b0, ILI9341_VSCRADD};   
        INIT_SEQ [36] = {1'b1, 8'h00};
        INIT_SEQ [37] = {1'b0, ILI9341_COLMODPIXFMT};   
        INIT_SEQ [38] = {1'b1, 8'h55};
        INIT_SEQ [39] = {1'b0, ILI9341_FRMCRN1};   
        INIT_SEQ [40] = {1'b1, 8'h00};
        INIT_SEQ [41] = {1'b1, 8'h18};
        INIT_SEQ [42] = {1'b0, ILI9341_DISCTRL};   
        INIT_SEQ [43] = {1'b1, 8'h08};
        INIT_SEQ [44] = {1'b1, 8'h82};
        INIT_SEQ [45] = {1'b1, 8'h27};
        INIT_SEQ [46] = {1'b0, ILI9341_LCD_3GAMMA_EN};   
        INIT_SEQ [47] = {1'b1, 8'h00};
        INIT_SEQ [48] = {1'b0, ILI9341_GAMMASET};
        INIT_SEQ [49] = {1'b1, 8'h01};
        INIT_SEQ [50] = {1'b0, ILI9341_GMCTRP1};   
        INIT_SEQ [51] = {1'b1, 8'h0F};
        INIT_SEQ [52] = {1'b1, 8'h31};
        INIT_SEQ [53] = {1'b1, 8'h2B};
        INIT_SEQ [54] = {1'b1, 8'h0C};
        INIT_SEQ [55] = {1'b1, 8'h0E};
        INIT_SEQ [56] = {1'b1, 8'h08};
        INIT_SEQ [57] = {1'b1, 8'h4E};
        INIT_SEQ [58] = {1'b1, 8'hF1};
        INIT_SEQ [59] = {1'b1, 8'h37};
        INIT_SEQ [60] = {1'b1, 8'h07};
        INIT_SEQ [61] = {1'b1, 8'h10};
        INIT_SEQ [62] = {1'b1, 8'h03};
        INIT_SEQ [63] = {1'b1, 8'h0E};
        INIT_SEQ [64] = {1'b1, 8'h09};
        INIT_SEQ [65] = {1'b1, 8'h00};
        INIT_SEQ [66] = {1'b0, ILI9341_GMCTRN1};
        INIT_SEQ [67] = {1'b1, 8'h00};
        INIT_SEQ [68] = {1'b1, 8'h0E};
        INIT_SEQ [69] = {1'b1, 8'h14};
        INIT_SEQ [70] = {1'b1, 8'h03};
        INIT_SEQ [71] = {1'b1, 8'h11};
        INIT_SEQ [72] = {1'b1, 8'h07};
        INIT_SEQ [73] = {1'b1, 8'h31};
        INIT_SEQ [74] = {1'b1, 8'hC1};
        INIT_SEQ [75] = {1'b1, 8'h48};
        INIT_SEQ [76] = {1'b1, 8'h08};
        INIT_SEQ [77] = {1'b1, 8'h0F};
        INIT_SEQ [78] = {1'b1, 8'h0C};
        INIT_SEQ [79] = {1'b1, 8'h31};
        INIT_SEQ [80] = {1'b1, 8'h36};
        INIT_SEQ [81] = {1'b1, 8'h0F};
        INIT_SEQ [82] = {1'b0, ILI9341_SLPOUT};
    end 

    always @(negedge clk)begin
        if(rst==0) begin
            fsm_state <= START;
        end else begin
            fsm_state <= next_state;
        end
    end

    always @ (negedge clk) begin
        if (rst==0) begin
            delay_counter <= 'b0;
        end else if (en_delay_100ms) begin
            if (delay_counter < DELAY_100ms) begin
                delay_counter <= delay_counter + 'b1;
            end else begin
                delay_counter <= 'b0;
            end
        end
    end

    always @(*)begin
        case(fsm_state)
            START: next_state <= SEND_INIT;
            SEND_INIT: next_state <= (idle)? WAIT1 : SEND_INIT;
            WAIT1: next_state <= (delay_counter == DELAY_100ms)? SEND_CONFIG : WAIT1;
            SEND_CONFIG: next_state <= ((config_counter == INIT_SEQ_LEN-1) & idle)? WAIT2 : SEND_CONFIG;
            WAIT2: next_state <= (delay_counter == DELAY_100ms)? DISPLAY_ON : WAIT2;
            DISPLAY_ON: next_state <= (idle)? WAIT3 : DISPLAY_ON;
            WAIT3: next_state <= (delay_counter == DELAY_100ms)? SET_ROTATION : WAIT3;
            SET_ROTATION: next_state <= (idle & !next_config)? SET_ADRRESS : SET_ROTATION;
            SET_ADRRESS: next_state <= (idle & !next_config)? FRAME_LOOP : SET_ADRRESS;
            FRAME_LOOP: next_state <= (frame_done)? WAIT_FRAME : FRAME_LOOP;
            WAIT_FRAME: next_state <= (!frame_done)? FRAME_LOOP : WAIT_FRAME;
            default : next_state <= WAIT_FRAME;
        endcase
    end

    always @ (negedge clk) begin
        if(rst==0)begin 
            spi_data <= 'b0;
            config_counter <= 'b0;
            available_data <= 'b0;
            next_config <= 'b0;
            data_byte_flag <= 1'b1;
        end else begin
            case (next_state)
                START: begin
                    config_counter <= 'b0;
                    spi_data <= 'b0;
                    available_data <= 1'b0;
                end
                SEND_INIT: begin
                    if(idle) begin
                        available_data <= 1'b1;
                        spi_data <= {1'b0, ILI9341_SWRESET};
                    end else begin
                        available_data <= 1'b0;
                    end
                end
                WAIT1: begin
                    if(idle) begin
                        available_data <= 1'b0;
                    end
                end
                SEND_CONFIG: begin
                    if(idle) begin
                        available_data <= 1'b1;
                        spi_data <= INIT_SEQ[config_counter];
                        config_counter <= config_counter + 1;
                    end else begin
                        available_data <= 1'b0;
                    end
                end
                WAIT2: begin
                    if(idle) begin
                        available_data <= 1'b0;
                    end
                end
                DISPLAY_ON: begin
                    if(idle) begin
                        available_data <= 1'b1;
                        spi_data <= {1'b0, ILI9341_DISPON};
                    end else begin
                        available_data <= 1'b0;
                    end
                end
                WAIT3: begin
                    if(idle) begin
                        available_data <= 1'b0;
                    end
                end 
                SET_ROTATION: begin
					if(idle) begin
                        available_data <= 1'b1;
                        next_config <= 'b0;
                        case(next_config)
                            'b0: begin
                                spi_data <= {1'b0, ILI9341_MADCTL}; 
                                next_config <= 'b1;
                            end
                            'b1: spi_data <= {1'b1, MADCTL_MX | MADCTL_BGR};//MADCTL_MX|MADCTL_MY|MADCTL_MV|
                        endcase
                    end else begin
                        available_data <= 1'b0;
                    end
				end
                SET_ADRRESS: begin
                    if(idle) begin
                        available_data <= 1'b1;
                        next_config <= 'b0;
                        case(next_config)
                            'd0: begin
                                spi_data <= {1'b0, ILI9341_CASET}; 
                                next_config <= 'd1;
                            end
                            'd1: begin
                                spi_data <= {1'b1, 8'h00};
                                next_config <= 'd2;
                            end
                            'd2: begin
                                spi_data <= {1'b1, 8'h00};
                                next_config <= 'd3;
                            end
                            'd3: begin
                                spi_data <= {1'b1, 8'h01};
                                next_config <= 'd4;
                            end
                            'd4: begin
                                spi_data <= {1'b1, 8'hEF};
                                next_config <= 'd5;
                            end
                            'd5: begin
                                spi_data <= {1'b0, ILI9341_PASET}; 
                                next_config <= 'd6;
                            end
                            'd6: begin
                                spi_data <= {1'b1, 8'h00};
                                next_config <= 'd7;
                            end
                            'd7: begin
                                spi_data <= {1'b1, 8'h00};
                                next_config <= 'd8;
                            end
                            'd8: begin
                                spi_data <= {1'b1, 8'h00};
                                next_config <= 'd9;
                            end
                            'd9: begin
                                spi_data <= {1'b1, 8'hEF};
                                next_config <= 'd10; 
                            end
                            'd10: begin
                                spi_data <= {1'b0, ILI9341_RAMWR};
                            end
                        endcase
                    end else begin
                        available_data <= 1'b0;
                    end
                end 
                FRAME_LOOP: begin
                    if(idle) begin
					    spi_data <= !data_byte_flag ? {1'b1, input_data[7:0]} :{1'b1, input_data[15:8]};
					    available_data <= 1'b1;
					    data_byte_flag <= !data_byte_flag;
                    end else begin
                        available_data <= 1'b0;
                    end
				end
                WAIT_FRAME: begin
                    if(idle) begin
                        available_data <= 1'b0;
                        data_byte_flag <= !data_byte_flag;
                    end
                end
            endcase
        end
    end 


    assign en_delay_100ms = (fsm_state == WAIT1) || (fsm_state == WAIT2) || (fsm_state == WAIT3);
	assign data_clk = !data_byte_flag;

endmodule