// controller.v for lab 10
// written by Nolan Reitz
// Started 11/12/2025
// "finished" 11/12/2025


module controller ( enable, up, resetCount, flashState, lapState, manualTrigger, start, stop, clr, countDown, timeSet, lap, clk, reset, flashing, stateOut);
	output enable, up, resetCount, flashState, lapState , manualTrigger;
	input start, stop, clr, countDown, timeSet, lap, clk, reset, flashing;
	output [2:0] stateOut;
	
	reg [2:0] presentState, nextState;
	// 3-bit, simply reserving space for later states such as the jog state, or lap while hold display (will require an extra output to keep display held/blinking but keep clock running in the background)
	parameter Zero = 3'b000, CntUp = 3'b001, CntDwn = 3'b010, HoldDisp = 3'b011, Flash = 3'b100, Lap = 3'b110, TimeJog = 3'b111;
	
	//simple logic block to see that if reset is not being called, and if it isn't to move the next state into the presentState
	always @(posedge clk or posedge reset)
		//possible bug found 11/20 4:11 PM by Nolan, rst is active high, this reset, however, was set for an active low. toggled value, will report on error states
		if(reset) presentState <= Zero;
		else presentState <= nextState;
		
	//state machine logic, used to decide the next state value
	always @(start, stop, clr, countDown, timeSet, lap, presentState, flashing) begin
		case (presentState)
			Zero: nextState = timeSet ? TimeJog : (start ? (countDown ? CntDwn : CntUp) : Zero); //if set to the zero state, then exit by pressing start, whether you go to CntDwn or CntUp is decided by the input countDown.
			CntUp: nextState = flashing ? Flash: (lap ? Lap: ( stop ? HoldDisp : CntUp)); //if stop is pressed, stop, else continue
			CntDwn: nextState = flashing ? Flash: ( stop ? HoldDisp : CntDwn); //if stop is pressed, stop, else continue
			HoldDisp: nextState = clr ? Zero : (timeSet ? TimeJog : ((start ? (countDown ? CntDwn : CntUp) : HoldDisp))); 
			Flash: begin	if( start | stop) nextState = start ? (countDown ? CntDwn : CntUp) : Zero; 
					else nextState = Flash; end
			Lap: nextState = start ? (countDown ? CntDwn : CntUp): Lap;
			TimeJog: nextState = timeSet ? TimeJog : HoldDisp;
			
			default: nextState = Zero;
		endcase
	end
	
	assign enable = presentState == Zero | presentState == CntDwn | presentState == CntUp | presentState == Lap | (presentState == TimeJog & start);
	assign up = (presentState == CntUp) | (presentState == HoldDisp & ~countDown) | (presentState == Lap & ~countDown) | (presentState == TimeJog & ~countDown);
	assign resetCount = (presentState == Zero) | presentState == Flash;
	assign flashState = (presentState == Flash);
	assign lapState = presentState == Lap;
	assign stateOut = presentState; 
	assign manualTrigger = (presentState == TimeJog) & start;
endmodule

/*
`timescale 1ns/1ps
module tb_controller;

	wire enable, up, resetCount, manualTrigger;
	reg start, stop, clr, countDown, timeSet, lap, clk, reset;
	
	controller test_Controller (enable, up, resetCount, manualTrigger, start, stop, clr, countDown, timeSet, lap, clk, reset);
	
	initial begin
		clk = 1'b0; forever #5 clk = ~clk;
	end
	
	initial #300 $finish;
	initial begin 
		$dumpfile("tb_controller.vcd");
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
*/