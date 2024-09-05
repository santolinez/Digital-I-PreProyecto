module Sensor_AR #(parameter COUNT_BOT=10)( // COUNT_BOT=50000
	input reset,
	input clk,
	input sensor_in,
	output reg sensor_out
);

reg [$clog2(COUNT_BOT)-1:0] counter;
reg [$clog2(50)-1:0] counter_t1;
initial begin
		counter=0;
		sensor_out=1;
end

// antirebote  energia
always @(posedge clk) begin
	if (~reset)begin
		counter <=0;
		sensor_out<=1;
	end else begin
		if (sensor_in==~sensor_out ) begin
			counter <= counter+1;
			if(counter_t1<50) begin
				counter_t1<=counter_t1+1;
			end
		end else begin
			counter<=0;			
		end
		if (sensor_in==0 && counter==COUNT_BOT)begin
 // 			sensor_out<=~sensor_out;
	 			sensor_out<=0;
				counter<=0;
				counter_t1<=0;
		end
		if (sensor_in==1 )begin
 // 			sensor_out<=~sensor_out;
	 			sensor_out<=1;
				counter<=0;
				counter_t1<=0;
		end
	
	end
end	


endmodule