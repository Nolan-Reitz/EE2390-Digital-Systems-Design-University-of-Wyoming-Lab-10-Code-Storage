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