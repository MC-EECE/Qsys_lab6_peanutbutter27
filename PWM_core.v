module PWM #(parameter n = 32, parameter m = 4)(  
 input reset_n, clk, 
 input [n-1:0] pulse_width, 
 input [n-1:0] period, 
 output wire out 
 ); 
 
 
 
 
 reg [n-1:0] counter_d, counter_q; 
 reg pwm_d, pwm_q;
 
 //It runs on the edge to increase accuracy. 
 always@(posedge clk) 
 begin 
 	 
 	//if reset button is pressed 
    if(~reset_n)  
    begin 
 		counter_q <= 32'b0;  
		pwm_q <= 0;
 	 end 
 	 
 	//when LED should be high 
 	else 
	begin
	  counter_q <= counter_d;
	
	  pwm_q <= pwm_d;
	
	end
 	 
 end  
 
 
 //It runs on the edge to increase accuracy. 
 always@(*) 
 begin 
	counter_d = counter_q + 1;
 
 
	if (counter_d > period)
	begin
	  counter_d = 0;
	end
	
	pwm_d = (counter_d < pulse_width)?1:0;
	
		 
 end 
 
 assign out = pwm_q;
 
 endmodule 
