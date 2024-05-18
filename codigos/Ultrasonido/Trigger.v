module Trigger#(parameter COUNT_MAX = 25)(
    input clk,     // Señal de reloj
    input Enable,  // Habilitación del módulo
    input Echo,
    output Led,
    output Trigger, // Salida del pulso de trigger
    output reg Done // Indicador de finalización
   
);

reg [14:0] counter; // Contador de 15 bits
reg [14:0] Tiempo;
wire wait_echo_reg;
reg trigger_done;
reg [1:0] state;
reg [3:0] counter_10;
reg led_reg;

reg micro;

parameter IDLE=0;
parameter TRIGGER=1;
parameter WAIT=2;
parameter WAITECHO=3;


initial begin
    Done <= 0;
    counter <= 0;    
    Tiempo <= 0;  
    state <= IDLE;  
    trigger_done <= 0;
    micro <= 0;
    counter_10 <=0;
	 led_reg <= 0;
    end

// Divisor de frecuecia
always@(posedge clk) begin
        if (counter == COUNT_MAX -1) begin
            micro = ~micro;
            counter<=0;
        end else begin 
            counter = counter +1;
        end
    end
 
always@(posedge clk)begin

case(state)
IDLE: begin 
    state=(Enable)?TRIGGER:state;
end
TRIGGER: begin
    state=(trigger_done)?WAIT:state;
end
WAIT: begin
    state=(Echo)?WAITECHO:state;
end
WAITECHO: begin
    state=(Echo)?state:IDLE;
end
endcase
end


assign Trigger = (state==TRIGGER);
assign wait_echo_reg = (state==WAITECHO);

always @(posedge micro) begin
    if (Trigger) begin
        counter_10 <= counter_10 + 1;
        if (counter_10 < 10) begin // Si el contador es menor que 10, se activa el trigger
			trigger_done <= 0;
        end else begin
            trigger_done <= 1; // Reinicia el contador 
            counter_10 <= 0;
        end
    end else begin
        trigger_done <= 0;
    end
end 


always @(posedge micro) begin
    if (wait_echo_reg)begin 
    Done=0;
    Tiempo <= Tiempo + 1;
    end else begin
    Done=1;
    Tiempo <= 0;
    end 
end

always @(posedge micro) begin
    if (Tiempo < 1000) begin
        led_reg = 1;  // Enciende el LED si el tiempo es menor que 583
    end else begin
        led_reg = 0;  // Apaga el LED si el tiempo es mayor o igual a 583
    end 
end

assign Led = ~led_reg;

endmodule
