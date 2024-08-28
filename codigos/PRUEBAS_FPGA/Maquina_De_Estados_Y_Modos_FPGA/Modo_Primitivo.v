

module Modo_Primitivo #(parameter Parametro= 15,parameter tiempo5seg=7)(

    // Entradas
    input clk,
    input B_reset,
    input Entrada,
    input activo,
    // Salida
     output [0:1] Nivel, 
     output senal_5seg
);

reg Entrada_prev;
reg Entrada_Sube_Nivel;
reg senal_5segun;
reg [0:1] Contador_Nivel;
reg [$clog2(Parametro)-1:0] Contador_Tiempo;
reg [$clog2(tiempo5seg+1)-1:0] Contador_5segundos;

initial begin
        Entrada_prev=0;
        Entrada_Sube_Nivel=0;
        senal_5segun=0;
        Contador_Nivel = 3;
        Contador_Tiempo = 0;
		  Contador_5segundos=0;
    end


always @(posedge clk)begin
Entrada_Sube_Nivel=~(Entrada_prev==Entrada);
Entrada_prev=Entrada;
if (~B_reset) begin
    Contador_Nivel <= 3;
    Contador_Tiempo <= 0;
	 Contador_5segundos<=1;
end else if (Contador_Tiempo == Parametro & Contador_Nivel > 0 & activo) begin
        Contador_Nivel = Contador_Nivel - 1;
        Contador_Tiempo <= 0;
end else if (Entrada_Sube_Nivel & Contador_Nivel<3 & activo) begin
        Contador_Nivel = Contador_Nivel + 1;
		  Contador_5segundos<=1;
		  senal_5segun=1;
                  Contador_Tiempo <= 0;
end else if (activo) begin
        Contador_Tiempo = Contador_Tiempo + 1;
end

if (~(Contador_5segundos==0)) begin
		if(Contador_5segundos>=tiempo5seg) begin
			senal_5segun=0;
                        Contador_5segundos<=0;
		end else begin
			Contador_5segundos<=Contador_5segundos+1;
		end
end
end // Fin del Always clk

assign Nivel = Contador_Nivel;
assign senal_5seg =senal_5segun;
endmodule

