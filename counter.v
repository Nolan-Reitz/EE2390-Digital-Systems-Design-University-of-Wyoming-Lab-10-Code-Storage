// counter.v for lab 10
// written by Nolan Reitz
// Started 11/12/2025
// "finsihed" 11/12/2025


module counter(mins, tens, ones, tenths, flashTrue, enable, up, resetCount, manualTrigger, slow_clk, fastish_clk);
	output [3:0] mins, tens, ones, tenths;
	output flashTrue;
	input  enable, up, resetCount, manualTrigger, fastish_clk, slow_clk;

	wire tenthsUpEn, tenthsDwnEn;
	wire onesUpEn, onesDwnEn, onesEnable;
	wire tensUpEn, tensDwnEn, tensEnable;
	wire minsEnable;
	wire tenthsRollover, minsRollover;
	
	wire internalClock;
	assign internalClock = manualTrigger ? fastish_clk : slow_clk;
	
	count tenthsCount (tenths, internalClock, resetCount, enable, up, tenthsUpEn, tenthsDwnEn, tenthsRollover);
	count onesCount (ones, internalClock, resetCount, onesEnable, up, onesUpEn, onesDwnEn,);
	count5 tensCount (tens, internalClock, resetCount, tensEnable, up, tensUpEn, tensDwnEn);
	count minsCount (mins, internalClock, resetCount, minsEnable, up, , ,minsRollover); //possible bug location

	assign onesEnable = (resetCount && enable) || tenthsUpEn || tenthsDwnEn;
	assign tensEnable = (resetCount && enable) || onesUpEn || onesDwnEn;
	assign minsEnable = (resetCount && enable) || tensUpEn || tensDwnEn;
	assign flashTrue = ((tenthsRollover  & mins == 0  & tens == 0 & ones == 0 & tenths == 0 & ~up) | (minsRollover & mins == 9 & tens == 5 & ones == 9 & tenths==9 & up)) & enable;
endmodule

/*
// tb_counter.v
`timescale 1ns / 1ps
module tb_counter();
	wire [3:0] mins, tens, ones, tenths;
	reg        enable, up, resetCount, manualTrigger, slow_clk;
        counter uut (mins, tens, ones, tenths, enable, up, resetCount, manualTrigger, slow_clk);

	initial
	begin
		$dumpfile("tb_counter.vcd");
		$dumpvars(0,tb_counter);
		slow_clk=0; resetCount=1; enable=1; up=1;
		#20000 $finish;
	end

	always
		#5 slow_clk = !slow_clk;

	initial
	fork
		#40 resetCount=0;
		#10000 up=0;
	join
endmodule
*/