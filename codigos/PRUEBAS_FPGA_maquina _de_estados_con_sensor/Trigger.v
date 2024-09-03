module Trigger#(parameter COUNT_MAX = 25)(
    input clk,
    input Echo,
    input rst,
    output Led,
    output reg Trigger
);

reg [5:0] counter;
reg [14:0] Tiempo;
wire wait_echo_reg;
reg trigger_done;
reg [1:0] fsm_state, next_state;
reg [3:0] counter_10;
reg led_reg;
reg micro;

parameter IDLE = 0;
parameter TRIGGER = 1;
parameter WAIT = 2;
parameter WAITECHO = 3;

initial begin
    counter <= 6'b000000;    
    Tiempo <= 0;
    Trigger <= 0;  
    fsm_state <= IDLE;  
    trigger_done <= 0;
    micro <= 0;
    counter_10 <= 0;
    led_reg <= 0;
end

always @(posedge clk) begin
    if (counter == COUNT_MAX - 1) begin
        micro = ~micro;
        counter <= 0;
    end else begin 
        counter <= counter + 6'b000001;
    end
end

always @(posedge micro) begin
    if (rst == 0) begin 
        fsm_state <= IDLE;
    end else begin 
        fsm_state <= next_state;
    end
end

always @(*) begin
    case(fsm_state)
        IDLE: next_state = TRIGGER;
        TRIGGER: next_state = (trigger_done) ? WAIT : TRIGGER;
        WAIT: next_state = (Echo) ? WAITECHO : WAIT;
        WAITECHO: next_state = (Echo) ? WAITECHO : IDLE;
    endcase
end

always @(posedge micro) begin 
    if (rst == 0) begin
        counter_10 <= 0;
        Trigger <= 0;
        trigger_done <= 0;
        Tiempo <= 0;
        led_reg = 0;
    end else begin
        case(next_state)
            IDLE: begin
                Trigger <= 0; 
                counter_10 <= 0;
                trigger_done <= 0;
                Tiempo <= 0;
                led_reg <= 0;
            end
            TRIGGER: begin 
                Trigger <= 1;
                counter_10 <= counter_10 + 1;
                if (counter_10 < 10) begin
                    trigger_done <= 0;
                end else begin
                    trigger_done <= 1;
                    counter_10 <= 0;
                end
            end
            WAIT: begin 
                Trigger <= 0;
            end
            WAITECHO: begin 
                Tiempo <= Tiempo + 1;
                if (Tiempo < 1000) begin
                    led_reg = 1;
                end else begin
                    led_reg = 0;
                end 
            end
        endcase
    end
end

assign Led = ~led_reg;

endmodule
