`timescale 1ns/1ps
module tb_controller;

	wire enable, up, resetCount, manualTrigger;
	reg start, stop, clr, countDown, timeSet, lap, clk, reset;
	
	//enable, up, resetCount, manualTrigger, start, stop, clr, countDown, timeSet, lap, clk, reset
	controller test_Controller (enable, up, resetCount, manualTrigger, start, stop, clr, countDown, timeSet, lap, clk, reset);
	
	initial begin
		clk = 1'b0; forever #5 clk = ~clk;
	end
	
	initial #300 $finish;
	initial begin 
		$dumpfile("test_controller.vcd");
		$dumpvars(0, tb_controller);
	end	
	
	initial fork
		reset = 1'b0;
		countDown = 1'b0;
		start = 1'b0;
		stop = 1'b0;
		clr = 1'b0;
		timeSet = 1'b0;
		lap = 1'b0;
		#10 reset = 1'b1;
		#40 start = 1'b1;
		#50 start = 1'b0;
		#60 countDown = 1'b1;
		#70 stop = 1'b1;
		#80 stop = 1'b0; 
		#90 start = 1'b1;
		#100 start = 1'b0;
		#110 stop = 1'b0;
		#120 stop = 1'b0;
		#130 clr = 1'b1;
		#140 clr = 1'b0;
		#150 start = 1'b1;
		#160 start = 1'b0;
		#160 reset = 1'b0;
		#180 reset = 1'b1;
		#200 stop = 1'b1;
		#210 clr = 1'b1;
	join
endmodule