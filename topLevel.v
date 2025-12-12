// topLevel.v for lab 10
// written by Nolan Reitz
// Started 11/12/2025


module topLevel (input start, stop, clr, countDown, timeSet, lap, clk, reset, output [3:0] an, output [0:6] seg, output dp, output [2:0] stateOut);
	wire enable, up, resetCount, slow_clk, flashing, flashState, manualTrigger, fastish_clk;
	wire [3:0] mins, tens, ones, tenths;
	
	// controller module that gets in the start, stop, countdown, timeset, lap, and reset signals, and generates the enable, up, resetcount, and manualTrigger signals
	controller ctrl( enable, up, resetCount, flashState, lapState, manualTrigger, start, stop, clr, countDown, timeSet, lap, clk, reset, flashing, stateOut);

	//module that is responsible for chaining together four seperate counters, one for each digit of the stopwatch
	counter cnt(mins, tens, ones, tenths, flashing, enable, up, resetCount, manualTrigger, slow_clk , fastish_clk);
	
	//module that gets in the four digits for the stop watch, and holds the code for tying those inputs to the mux, then the mux to the seven segment decoder, then finally outputting the decoded value and the dcimal point to the outputs (seven segment displays)
	display disp(seg, an, dp, mins, tens, ones, tenths, clk, reset, flashState, lapState);
	
	//some code for clock divider
	
	clk_div clockDivider(clk, reset, slow_clk, fastish_clk);

endmodule



//notes for 100%

/*

manualTrigger will be assigned based off the timeJog state and the pressing of a button
when manualTrigger is asserted, the counter module will change the clock being passed to the counters to a faster clock that will be produced by the clock divider module (using a different bit of the counter)
while the start button is held it counts, when it isn't then it doesn't count.

*/