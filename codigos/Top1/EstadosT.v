module EstadosT#(parameter COUNT_MAX = 25 )(//6250000
    input clk,
    
    input test,
    input reset,
    input Dormir,
    input Comida,
    input Medicina,
    input Carino,
    output reg Led_animo,Led_hambre, Led_sueno, Led_salud
);

reg [5:0] count_tiem; // Contador de 6 bits
reg [3:0] count_carino, count_dormir;
reg [$clog2(COUNT_MAX)-1:0] counter; 
reg [1:0] Nivel_animo, Nivel_hambre, Nivel_sueno, Nivel_salud;
reg seg;
reg animo_done, hambre_done, sueno_done, salud_done;
reg [2:0] state;
reg [2:0] next;
reg ledA_reg, ledH_reg, ledZ_reg, ledS_reg;
reg idle,comida_prev, medicina_prev;

localparam IDLE=0;
localparam ANIMO=1;
localparam HAMBRE=2;
localparam SUENO=3;
localparam SALUD=4;



// Divisor de frecuecia
always@(posedge clk) begin
        if (counter == COUNT_MAX -1) begin
            seg = ~seg;
            counter<=0;
        end else begin 
            counter = counter +1;
        end
    end

initial begin
    state <= IDLE;
    counter <= 0;
    seg <= 0;
	idle <= 0;
    count_tiem <= 0;
    animo_done <= 0;
    hambre_done <= 0;
    sueno_done <= 0;
    salud_done <= 0;
    comida_prev <= 0;
    medicina_prev <= 0;
    Nivel_salud <=3;
    Nivel_hambre <=3;
    Nivel_sueno <=3;
    Nivel_animo <= 3;
end

always@(*)begin
case(state)
IDLE: begin 
    next=(reset)?IDLE:ANIMO;
end
ANIMO: begin 
    next=(animo_done)?HAMBRE:ANIMO;
end
HAMBRE: begin 
    next=(hambre_done)?SUENO:HAMBRE;
end
SUENO: begin
    next=(sueno_done)?SALUD:SUENO;
end
SALUD: begin
    next=(salud_done)?ANIMO:SALUD;
end
endcase
end

always @(posedge seg)begin
    state <= next;
end


always @(posedge seg) begin
count_tiem <= count_tiem + 1;
idle <=0;
case(next)
IDLE: begin 
	idle <=1;
end
ANIMO:begin
    salud_done <= 0;
    if (count_tiem > 60) begin 
            animo_done <= 1;
            count_tiem <= 0;
    end	 
end

HAMBRE:begin
	animo_done <= 0; 
	if (count_tiem > 60) begin 
            hambre_done <= 1;
            count_tiem <= 0;
    end
	end

SUENO:begin
	hambre_done <= 0; 
	if (count_tiem > 60) begin 
            sueno_done <= 1;
            count_tiem <= 0;
    end
	end

SALUD:begin
	sueno_done <= 0; 
	if (count_tiem > 60) begin 
            salud_done <= 1;
            count_tiem <= 0;
    end
	end
    
endcase
end 


always @(negedge seg)begin
	if (idle)begin 
	Nivel_animo <= 3;
	Nivel_hambre <= 3;
	Nivel_sueno <= 3;
	Nivel_salud <= 3;
	end else if(animo_done)begin
		  if(Nivel_animo>0) begin 
		  Nivel_animo <= Nivel_animo -1;
		  end
    end else if(sueno_done)begin
		  if(Nivel_sueno>0) begin 
        Nivel_sueno<= Nivel_sueno -1;
		  end
    end else if(hambre_done)begin
		  if(Nivel_hambre>0) begin 
        Nivel_hambre<= Nivel_hambre -1;
		  end
    end else if(salud_done)begin 
		  if(Nivel_salud>0) begin 
        Nivel_salud<= Nivel_salud -1;
		  end
    end 
	 
	/* if(Medicina==(~medicina_prev))begin
        if(Nivel_salud<3) begin 
			Nivel_salud <= Nivel_salud + 1;
			end 
	end
	

	if(Comida==(~comida_prev))begin 
        if(Nivel_hambre<3) begin 
			Nivel_hambre <= Nivel_hambre + 1;
			end
	end   */
    
   if(Carino)begin 
        count_carino <= count_carino + 1;
         if (count_carino == 15) begin 
			if(Nivel_animo<3) begin 
			Nivel_animo <= Nivel_animo + 1;
			end
        end
    end else begin 
         count_carino <= 0;
    end

    if(Dormir)begin 
        count_dormir <= count_dormir + 1;
         if (count_dormir == 15) begin 
			if(Nivel_sueno<3) begin 
			Nivel_sueno <= Nivel_sueno + 1;
			end
        end
    end else begin 
         count_dormir <= 0;
    end
    medicina_prev<=Medicina;

end

always @(posedge clk) begin
    if (Nivel_animo<3)begin
        Led_animo=1;
    end else begin 
        Led_animo=0;
    end
    if (Nivel_hambre<3)begin
        Led_hambre=1;
    end else begin 
        Led_hambre=0;
        end
    if(Nivel_sueno<3)begin
        Led_sueno=1;
    end else begin 
        Led_sueno=0;
    end
     if (Nivel_salud<3)begin
        Led_salud=1;
    end else begin
        Led_salud=0;
    end
end

endmodule