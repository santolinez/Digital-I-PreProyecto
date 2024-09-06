module Maquina_Estados_1 (
    input clk,
    input reset,
	 
    input [1:0] Nivel_Comida,  // Nivel como entrada
	    input [1:0] Nivel_Salud, 
    input [1:0] Nivel_Descanso, 
    input [1:0] Nivel_Animo,
	 
    input Boton_Comida,
    input Boton_Medicina,
    input Sensor_UltraSonido,
    input Sensor_Luz,
	 
    input Senal_Test,
    input Senal_MTest,
	 input Senal_Test_fil,
	 
    output reg [3:0] Visualizacion,
	 
	 output l_flanco_test,
	 
    output reg Activo_Comida,
    output reg Activo_Medicina,
    output reg Activo_UltraSonido, //enable
    output reg Activo_SensorLuz,
	 
// PARA LA IMPLEMENTACION DE 7 SEGMENTOS
    output reg [0:27] Salida_7seg
);

    

    

    // Declaración de estados
    reg [3:0] Estados;
    reg [3:0] Estado_Siguiente;
    reg flanco_test;
    reg [4:0]cambio_test;
    reg B_test_prev;
	 
	 localparam Estado_IDLE       = 4'b0000; // PERFECTO 1

    localparam Estado_Hambre     = 4'b0001; // COMIDA   2
    localparam Estado_Desnutrido = 4'b0010; // COMIDA   3
    localparam Estado_Comiendo   = 4'b0011; // COMIDA   4

    localparam Estado_Tos        = 4'b0100; // SALUD    5
    localparam Estado_Fiebre     = 4'b0101; // SALUD    6
    localparam Estado_Pildora    = 4'b0110; // SALUD    7

    localparam Estado_Cansado    = 4'b0111; // DESCANSO 8
    localparam Estado_Desvelo    = 4'b1000; // DESCANSO 9
    localparam Estado_Dormido    = 4'b1001; // DESCANSO 10

    localparam Estado_Triste     = 4'b1010; // ANIMO    11
    localparam Estado_Depresion  = 4'b1011; // ANIMO    12
    localparam Estado_Carisia    = 4'b1100; // ANIMO    13

	 localparam Estado_Muerte     = 4'b1101; //GAME OVER

    // Inicialización
    initial begin
        cambio_test=5'b00000;
        flanco_test=1'b0;
        B_test_prev=1'b0;//tener cuidado al usar los rst
        Estados <= Estado_IDLE;
        Estado_Siguiente <= Estado_IDLE;
        Activo_Comida = 1'b1;
        Activo_Medicina = 1'b1;
		  Activo_SensorLuz = 1'b1;
        Activo_UltraSonido = 1'b1;
        Visualizacion = 4'b0000;
        Salida_7seg = 0;
    end

    // Lógica secuencial para actualización de estados
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            Estados <= Estado_IDLE;
        end else begin
            Estados <= Estado_Siguiente;
        end
    end

    // Lógica combinacional para determinar el siguiente estado
    always @(*) begin
		  
        
        case (Estados)
            Estado_IDLE: begin
                if (((Nivel_Comida < 3)&(~Senal_MTest))||((Senal_MTest)&(cambio_test==1)))
                    Estado_Siguiente <= Estado_Hambre;//para tener en cuenta, cuando se agregue más estados toca poner la variable parametro para el test, es la que ayuda al test a saber porque estados ya paso
                else if (((Nivel_Salud < 3)&(~Senal_MTest))||((cambio_test==5)&(Senal_MTest)))
                    Estado_Siguiente <= Estado_Tos;
                else if (((Nivel_Descanso < 3)&(~Senal_MTest))||((cambio_test==9)&(Senal_MTest)))
							Estado_Siguiente <= Estado_Cansado;
					 else if (((Nivel_Animo < 3)&(~Senal_MTest))||((cambio_test==12)&(Senal_MTest)))
                    Estado_Siguiente <= Estado_Triste;
					 else 
                    Estado_Siguiente <= Estado_IDLE;
            end

            Estado_Hambre: begin
                if (((Nivel_Comida < 1)&(~Senal_MTest))||((Senal_MTest)&(cambio_test==2)))
                    Estado_Siguiente <= Estado_Desnutrido;
                else if (Boton_Comida & (~Senal_MTest))
                    Estado_Siguiente <= Estado_Comiendo;
                else 
                    Estado_Siguiente <= Estado_Hambre;
            end

				Estado_Tos: begin
                if (((Nivel_Salud < 1)&(~Senal_MTest))||((Senal_MTest)&(cambio_test==6)))
                    Estado_Siguiente <= Estado_Fiebre;
                else if (Boton_Medicina & (~Senal_MTest))
                    Estado_Siguiente <= Estado_Pildora;
                else 
                    Estado_Siguiente <= Estado_Tos;
            end
				
				 Estado_Cansado: begin
                if (((Nivel_Descanso < 1)&(~Senal_MTest))||((Senal_MTest)&(cambio_test==10)))
                    Estado_Siguiente <= Estado_Desvelo;
                else if (Sensor_Luz & (~Senal_MTest))
                    Estado_Siguiente <= Estado_Dormido;
                else 
                    Estado_Siguiente <= Estado_Cansado;
            end
				
				Estado_Triste: begin
                if (((Nivel_Animo < 1)&(~Senal_MTest))||((Senal_MTest)&(cambio_test==14)))
                    Estado_Siguiente <= Estado_Depresion;
                else if (Sensor_UltraSonido & (~Senal_MTest))
                    Estado_Siguiente <= Estado_Carisia;
                else
                    Estado_Siguiente <= Estado_Triste;
            end
				
            Estado_Desnutrido: begin
                if (((Boton_Comida)&(~Senal_MTest))||((Senal_MTest)&(cambio_test==3)))
                    Estado_Siguiente <= Estado_Comiendo;
                else 
                    Estado_Siguiente <= Estado_Desnutrido;
            end

				Estado_Fiebre: begin
                if (((Boton_Medicina)&(~Senal_MTest))||((Senal_MTest)&(cambio_test==7)))
                    Estado_Siguiente <= Estado_Pildora;
                else
                    Estado_Siguiente <= Estado_Fiebre;
            end
				
				 Estado_Desvelo: begin
                if (((Sensor_Luz)&(~Senal_MTest))||((Senal_MTest)&(cambio_test==11)))
                    Estado_Siguiente <= Estado_Dormido;
                else 
                    Estado_Siguiente <= Estado_Desvelo;
            end
				
				Estado_Depresion: begin
                if (((Sensor_UltraSonido)&(~Senal_MTest))||((Senal_MTest)&(cambio_test==15)))
                    Estado_Siguiente <= Estado_Carisia;
                else
                    Estado_Siguiente <= Estado_Depresion;
            end

				
				
            Estado_Comiendo: begin
				    if (((Nivel_Comida == 3)&(~Senal_MTest)&(~Boton_Comida))||((Senal_MTest)&(cambio_test==4)))
                    Estado_Siguiente <= Estado_IDLE;
                else if (Boton_Comida&(~Senal_MTest))
                    Estado_Siguiente <= Estado_Comiendo;  // Mantenerse en Estado_Comiendo mientras Boton_Comida esté activo
                else if ((Nivel_Comida >= 1)&(~Senal_MTest))
                    Estado_Siguiente <= Estado_Hambre;
                else if(~Senal_MTest)
                    Estado_Siguiente <= Estado_Desnutrido;
					 else 
						  Estado_Siguiente <= Estado_Comiendo;
            end

				Estado_Pildora: begin
					 if (((Nivel_Salud == 3)&(~Senal_MTest)&(~Boton_Medicina))||((Senal_MTest)&(cambio_test==8)))
                    Estado_Siguiente <= Estado_IDLE;
                else if (Boton_Medicina & (~Senal_MTest))
                    Estado_Siguiente <= Estado_Pildora;  // Mantenerse en Estado_Comiendo mientras Boton_Comida esté activo
                
                else if ((Nivel_Salud >= 1)&(~Senal_MTest))
                    Estado_Siguiente <= Estado_Tos;
                else if(~Senal_MTest)
                    Estado_Siguiente <= Estado_Fiebre;
					 else
						Estado_Siguiente <= Estado_Pildora;
            end
				
				Estado_Dormido: begin
					if (((Nivel_Descanso == 3)&(~Senal_MTest)&(~Sensor_Luz))||((Senal_MTest)&(cambio_test==12)))
                    Estado_Siguiente <= Estado_IDLE;
               else if (Sensor_Luz&(~Senal_MTest))
                    Estado_Siguiente <= Estado_Dormido;  // Mantenerse en Estado_Comiendo mientras Boton_Comida esté activo
               else if ((Nivel_Descanso >= 1)&(~Senal_MTest))
                    Estado_Siguiente <= Estado_Cansado;
               else if(~Senal_MTest)
                    Estado_Siguiente <= Estado_Desvelo;
				   else
						  Estado_Siguiente <= Estado_Dormido;
            end
				
				Estado_Carisia: begin
				    if (((Nivel_Animo == 3)&(~Senal_MTest)&(~Sensor_UltraSonido))||((Senal_MTest)&(cambio_test==16)))
                    Estado_Siguiente <= Estado_IDLE;
                else if (Sensor_UltraSonido&(~Senal_MTest))
                    Estado_Siguiente <= Estado_Carisia;  // Mantenerse en Estado_Comiendo mientras Boton_Comida esté activo
               
                else if ((Nivel_Animo >= 1)&(~Senal_MTest))
                    Estado_Siguiente <= Estado_Triste;
                else if(~Senal_MTest)
                    Estado_Siguiente <= Estado_Depresion;
					 else
							Estado_Siguiente <= Estado_Carisia;
            end
				
            default: Estado_Siguiente <= Estado_IDLE;
        endcase

    end

	 // Logica de contador test
    always @(negedge Senal_Test_fil or negedge reset) begin
        if (~reset) begin 
            cambio_test <= 0;
        end else if (Senal_MTest) begin
            if (cambio_test < 16)begin
                cambio_test=cambio_test+1; 
                end else begin
                    cambio_test <= 0;
                end
        end
    end
		 // Lógica secuencial para las salidas

		 always @(posedge clk or negedge reset) begin

			  Salida_7seg =cambio_test*16*16*16*16*16+Visualizacion*16*16*16*16+Nivel_Descanso*16*16*16+Nivel_Salud*16*16+Nivel_Animo*16+Nivel_Comida;
			if (~reset) begin
            Activo_Comida <= 1'b1;
            Activo_Medicina <= 1'b1;
            Activo_SensorLuz <= 1'b1;
            Activo_UltraSonido <= 1'b1;
            Visualizacion <= 4'b0000;
        end else begin
            case (Estado_Siguiente)
                // PERFECTO
                Estado_IDLE: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Activo_SensorLuz <= 1'b1;
                    Activo_UltraSonido <= 1'b1;
                    Visualizacion <= 4'b0000;
						  if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
                end
                //COMIDA
                Estado_Hambre: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Activo_SensorLuz <= 1'b1;
                    Activo_UltraSonido <= 1'b1;
                    Visualizacion <= 4'b0001;
						  if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
                end

                Estado_Desnutrido: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Activo_SensorLuz <= 1'b1;
                    Activo_UltraSonido <= 1'b1;
                    Visualizacion <= 4'b0010;
						  if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
                end

                Estado_Comiendo: begin
                    Activo_Comida <= 1'b0;
                    Activo_Medicina <= 1'b0;
                    Activo_SensorLuz <= 1'b0;
                    Activo_UltraSonido <= 1'b0;
                    Visualizacion <= 4'b0011;
							if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end
                // SALUD
                Estado_Tos: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Activo_SensorLuz <= 1'b1;
                    Activo_UltraSonido <= 1'b1;
                    Visualizacion <= 4'b0100;
								if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end

                Estado_Fiebre: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Activo_SensorLuz <= 1'b1;
                    Activo_UltraSonido <= 1'b1;
                    Visualizacion <= 4'b0101;
							if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end

                Estado_Pildora: begin
                    Activo_Comida <= 1'b0;
                    Activo_Medicina <= 1'b0;
                    Activo_SensorLuz <= 1'b0;
                    Activo_UltraSonido <= 1'b0;
                    Visualizacion <= 4'b0110;
						if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end
                // DESCANSO
                Estado_Cansado: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Activo_SensorLuz <= 1'b1;
                    Activo_UltraSonido <= 1'b1;
                    Visualizacion <= 4'b0111;
							if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end

                Estado_Desvelo: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Activo_SensorLuz <= 1'b1;
                    Activo_UltraSonido <= 1'b1;
                    Visualizacion <= 4'b1000;
						if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end

                Estado_Dormido: begin
                    Activo_Comida <= 1'b0;
                    Activo_Medicina <= 1'b0;
                    Activo_SensorLuz <= 1'b0;
                    Activo_UltraSonido <= 1'b0;
                    Visualizacion <= 4'b1001;
							if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end
                // ANIMO
                Estado_Triste: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Activo_SensorLuz <= 1'b1;
                    Activo_UltraSonido <= 1'b1;
                    Visualizacion <= 4'b1010;
							if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end

                Estado_Depresion: begin 
                    Activo_Comida <= 1'b1;
                    Activo_Medicina <= 1'b1;
                    Activo_SensorLuz <= 1'b1;
                    Activo_UltraSonido <= 1'b1;
                    Visualizacion <= 4'b1011;
						if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end

                Estado_Carisia: begin
                    Activo_Comida <= 1'b0;
                    Activo_Medicina <= 1'b0;
                    Activo_SensorLuz <= 1'b0;
                    Activo_UltraSonido <= 1'b0;
                    Visualizacion <= 4'b1100;
							if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end
                // GAME OVER
                Estado_Muerte: begin 
                    Activo_Comida <= 1'b0;
                    Activo_Medicina <= 1'b0;
                    Activo_SensorLuz <= 1'b0;
                    Activo_UltraSonido <= 1'b0;
                    Visualizacion <= 4'b1101;
							if(Senal_MTest) begin
									Activo_Comida <= 1'b0;
									Activo_Medicina <= 1'b0;	
									Activo_SensorLuz <= 1'b0;
									Activo_UltraSonido <= 1'b0;							
							  end
					 end
            endcase
        end
	 end

assign l_flanco_test=flanco_test;
endmodule