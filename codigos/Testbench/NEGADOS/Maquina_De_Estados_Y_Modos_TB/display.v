`include "BCDtoSSeg.v"
`timescale 1ns / 1ps

module display(
    input [15:0] num,
    input clk,
    output [0:6] sseg,
    output reg [4:0] an,
	 input rst,
	 output led 
    );
	 
reg [3:0] digit_4, digit_3, digit_2, digit_1, digit_0;

reg [3:0]bcd=0;
//wire [15:0] num=16'h4321;
 
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));

reg [26:0] cfreq=0;
wire enable;

// Divisor de frecuecia

assign enable = cfreq[3];//16
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
		digit_4 = (num - (num % 16'd10000)) / 16'd10000;
      digit_3 = ((num - (num % 1000)) / 1000) % 10;
      digit_2 = ((num - (num % 100)) / 100) % 10;
      digit_1 = ((num - (num % 10)) / 10) % 10;
      digit_0 = num % 10;

		if(rst==0) begin
			count<= 0;
			an<=5'b11111; 
		end else begin 
			an<=5'b01111; 
			
			case (count) 
				3'h0: begin bcd <= digit_0;   an<=5'b11110; end 
				3'h1: begin bcd <= digit_1;   an<=5'b11101; end 
				3'h2: begin bcd <= digit_2;  an<=5'b11011; end 
				3'h3: begin bcd <= digit_3; an<=5'b10111; end 
				3'h4: begin bcd <= digit_4; an<=5'b01111; end 
			endcase
			count<= count+1;
			if(count==4) begin
				count<=0;
			end
		end 
end

endmodule