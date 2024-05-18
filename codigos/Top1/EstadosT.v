module EstadosT#(parameter COUNT_MAX = 6250000)(
    input clk,
    input Carino,
   // input Comida,
   // input Medicina,
    input Dormir,
   // input modo_test,
   // input test,
   // input reseteo,
    output Led_animo,Led_hambre, Led_sueno, Led_salud
);

reg [5:0] count_tiem; // Contador de 6 bits
reg [3:0] count_carino, count_dormir, count_comida, count_medicina;
reg [$clog2(COUNT_MAX)-1:0] counter; 
reg [1:0] Nivel_animo, Nivel_hambre, Nivel_sueno, Nivel_salud;
reg seg;
reg animo_done, hambre_done, sueno_done, salud_done;
reg animo_reg, hambre_reg, sueno_reg, salud_reg;
reg [1:0] state;
reg ledA_reg, ledH_reg, ledZ_reg, ledS_reg;


parameter ANIMO=0;
parameter HAMBRE=1;
parameter SUENO=2;
parameter SALUD=3;


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
    state <= ANIMO;
    counter <= 0;
    count_tiem <= 0;
    seg <= 0;
    animo_done <= 0;
    hambre_done <= 0;
    sueno_done <= 0;
    salud_done <= 0;
    Nivel_salud <=3;
    Nivel_hambre <=3;
    Nivel_sueno <=3;
    Nivel_animo <= 3;
end

always@(posedge clk)begin

case(state)
ANIMO: begin 
    state=(animo_done)?HAMBRE:state;
end
HAMBRE: begin 
    state=(hambre_done)?SUENO:state;
end
SUENO: begin
    state=(sueno_done)?SALUD:state;
end
SALUD: begin
    state=(salud_done)?ANIMO:state;
end
endcase
end


always @(posedge seg) begin
count_tiem <= count_tiem + 1;
case(state)
ANIMO:begin 
    if (count_tiem > 60) begin 
            animo_done <= 1;
            count_tiem <= 0;
				state=HAMBRE;
    end	 
end
HAMBRE:begin
	animo_done <= 0; 
	if (count_tiem > 60) begin 
            hambre_done <= 1;
            count_tiem <= 0;
    end
	end

endcase
end


always @(posedge clk) begin
    animo_reg <= (state == ANIMO);
    hambre_reg <= (state == HAMBRE);
    sueno_reg <= (state == SUENO);
    salud_reg <= (state == SALUD);
end


always @(posedge seg) begin
    if (animo_reg)begin 
    count_tiem <= count_tiem + 1;
    if (count_tiem < 60) begin 
			animo_done <= 0;
            hambre_done <= 0;
            salud_done <= 0;
            sueno_done <= 0;
        end else begin
            animo_done <= 1;
            hambre_done <= 0;
            salud_done <= 0;
            sueno_done <= 0;
            count_tiem <= 0;
        end
    end else if (hambre_reg)begin 
    count_tiem <= count_tiem + 1;
    if (count_tiem < 60) begin 
            animo_done <= 0;
            hambre_done <= 0;
			sueno_done <= 0;
            salud_done <= 0;
        end else begin
            animo_done <= 0;
            hambre_done <= 1;
            sueno_done <= 0; 
            salud_done <= 0;
            count_tiem <= 0;    
        end
    end else if (sueno_reg)begin 
    count_tiem <= count_tiem + 1;
    if (count_tiem < 60) begin 
			animo_done <= 0;
            hambre_done <= 0;
			sueno_done <= 0;
            salud_done <= 0;
        end else begin
           animo_done <= 0;
            hambre_done <= 0;
            sueno_done <= 1; 
            salud_done <= 0;
            count_tiem <= 0; 
        end
    end else if (salud_reg)begin 
    count_tiem <= count_tiem + 1;
    if (count_tiem < 60 ) begin 
			animo_done <= 0;
            hambre_done <= 0;
			sueno_done <= 0;
            salud_done <= 0;
        end else begin
            animo_done <= 0;
            hambre_done <= 0;
            sueno_done <= 0; 
            salud_done <= 1;
            count_tiem <= 0; 
        end
    end else begin
    animo_done <= 0;
    hambre_done <= 0;
    sueno_done <= 0;
    salud_done <= 0;
    end     
end

always @(negedge seg)begin
    if(animo_done)begin
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

    /*if(Comida)begin 
        count_comida <= count_comida + 1;
         if (count_comida == 5) begin 
			if(Nivel_hambre<3) begin 
			Nivel_hambre <= Nivel_hambre + 1;
			end
        end
    end else begin 
         count_comida <= 0;
    end

    if(Medicina)begin 
        count_medicina <= count_medicina + 1;
         if (count_medicina == 5) begin 
			if(Nivel_salud <3) begin 
			Nivel_salud <= Nivel_salud + 1;
			end
        end
    end else begin 
         count_comida <= 0;
    end*/

end

always @(posedge clk) begin 
    if (Nivel_animo<3)begin
        ledA_reg=1;
    end else begin 
        ledA_reg=0;
    end
    if (Nivel_hambre<3)begin
        ledH_reg=1;
    end else begin 
        ledH_reg=0;
        end
    if(Nivel_sueno<3)begin
        ledZ_reg=1;
    end else begin 
        ledZ_reg=0;
    end
     if (Nivel_salud<3)begin
        ledS_reg=1;
    end else begin
        ledS_reg=0;
    end
end

assign Led_animo = ~ledA_reg;
assign Led_hambre = ~ledH_reg;
assign Led_sueno = ~ledZ_reg;
assign Led_salud = ~ledS_reg;



endmodule