//`include "BCDtoSSeg.v"
//`timescale 1ns / 1ps

module display(
    input [27:0] num,
    input clk,
    output [0:6] sseg,
    output reg [7:0] an,
	 input rst,
	 output led 
    );
	 

reg [3:0]bcd=0;
//wire [15:0] num=16'h4321;
 
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));

reg [26:0] cfreq=0;
wire enable;

// Divisor de frecuecia

assign enable = cfreq[16];//16
assign led =enable;
always @(posedge clk) begin
  if(rst==0) begin
		cfreq <= 0;
	end else begin
		cfreq <=cfreq+1'b1;
	end
end

reg [2:0] count = 2'b0;
always @(posedge enable) begin
		if(rst==0) begin
			count<= 0;
			an<=6'b111111; 
		end else begin 
			an<=6'b011111; 
			
			case (count) 
				3'h0: begin bcd <= num[3:0];   an<=7'b1111110; end 
				3'h1: begin bcd <= num[7:4];   an<=7'b1111101; end 
				3'h2: begin bcd <= num[11:8];  an<=7'b1111011; end 
				3'h3: begin bcd <= num[15:12]; an<=7'b1110111; end 
				3'h4: begin bcd <= num[19:16]; an<=7'b1101111; end 
				3'h5: begin bcd <= num[23:20]; an<=7'b1011111; end 			
	   		3'h6: begin bcd <= num[27:24]; an<=7'b0111111; end 		
			endcase
			count<= count+1;
			if(count==6) begin
				count<=0;
			end
		end
end

endmodule