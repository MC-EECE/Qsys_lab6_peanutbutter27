module pwm_wrap(csi_clk, rsi_reset_n, avs_s0_read, avs_s0_readdata, avs_s0_write, avs_s0_writedata, avs_s0_byteenable, avs_s0_address, avs_s0_chipselect, coe_pwm_out);
parameter n = 32;
input wire csi_clk, rsi_reset_n;
input wire avs_s0_read;
output wire[n - 1:0] avs_s0_readdata;
input wire avs_s0_write;
input wire[n - 1:0]avs_s0_writedata;
input wire[3:0] avs_s0_byteenable;
input wire[1:0] avs_s0_address;
input wire avs_s0_chipselect;
output wire coe_pwm_out;

reg[n - 1:0] period, pulse_width, enable;
reg[31:0] readdata;
wire load_pulse_width, load_period, load_enable, read_pulse_width, read_period, read_enable;

wire pwm_out;

assign load_pulse_width = avs_s0_write&avs_s0_chipselect&(avs_s0_address == 0);
assign load_period = avs_s0_write&avs_s0_chipselect&(avs_s0_address == 1);
assign load_enable = avs_s0_write&avs_s0_chipselect&(avs_s0_address == 2);

assign read_pulse_width = avs_s0_read&avs_s0_chipselect&(avs_s0_address == 0);
assign read_period = avs_s0_read&avs_s0_chipselect&(avs_s0_address == 1);
assign read_enable = avs_s0_read&avs_s0_chipselect&(avs_s0_address == 2);


assign coe_pwm_out = pwm_out&enable;
assign avs_s0_readdata = readdata;

pwm pwm_0(
  .clk(csi_clk),
  .reset_n(reset_n),
  .period(period),
  .pulse_width(pulse_width),
  .out(pmw_out)
);

// Handle period reads & writes
always @(posedge csi_clk)
begin
  if (~reset_n)
  begin
    period <= 1000;
  end
  else
  begin
    if (load_period)
	 begin
	   if (avs_s0_byteenable[0] == 1)
		begin
		  period[7:0] <= avs_s0_writedata[7:0];
		end
	   if (avs_s0_byteenable[1] == 1)
		begin
		  period[15:8] <= avs_s0_writedata[15:8];
		end
	   if (avs_s0_byteenable[2] == 1)
		begin
		  period[23:16] <= avs_s0_writedata[23:16];
		end
	   if (avs_s0_byteenable[3] == 1)
		begin
		  period[31:24] <= avs_s0_writedata[31:24];
		end
	 
	 end
	 
	 if (read_period)
	 begin
	   readdata[31:0] <= period[31:0];
	 end
  end


end

// Handle pulse width reads & writes
always @(posedge csi_clk)
begin

 if (~reset_n)
  begin
    pulse_width <= 500;
  end
  else
  begin
    if (load_period)
	 begin
	   if (avs_s0_byteenable[0] == 1)
		begin
		  pulse_width[7:0] <= avs_s0_writedata[7:0];
		end
	   if (avs_s0_byteenable[1] == 1)
		begin
		  pulse_width[15:8] <= avs_s0_writedata[15:8];
		end
	   if (avs_s0_byteenable[2] == 1)
		begin
		  pulse_width[23:16] <= avs_s0_writedata[23:16];
		end
	   if (avs_s0_byteenable[3] == 1)
		begin
		  pulse_width[31:24] <= avs_s0_writedata[31:24];
		end
	 
	 end
	 
	 if (read_pulse_width)
	 begin
	   readdata[31:0] <= pulse_width[31:0];
	 end
  end


end

// Handle enable reads & writes
always @(posedge csi_clk)
begin
  if (~reset_n == 1)
  begin
    enable = 0;
  end
  else
  begin
	  if (load_enable == 1)
	  begin
		 if (avs_s0_byteenable[0] == 1)
		 begin
			enable = avs_s0_writedata[0];
		 end
	  end
	  
	  if (read_enable == 1)
	  begin
	    if (avs_s0_byteenable[0] == 1)
		 begin
		   readdata[0] = enable;
	    end
	  end
	  
	end	

end



endmodule
