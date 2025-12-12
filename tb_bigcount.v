// tb_bigcount.v
`timescale 1ns / 1ns
module tb_bigcount();
	wire [3:0] tmsd, tlsd;
	reg        tclk, tclr, ten, tup;
        bigcount   dut(tmsd,tlsd,tclk,tclr,ten,tup);

	initial
	begin
		$dumpfile("tb_bigcount.vcd");
		$dumpvars(0,tb_bigcount);
		tclk=0; tclr=1; ten=1; tup=1;
		#800 $finish;
	end

	always
		#10 tclk = !tclk;

	initial
	fork
		#40 tclr=0;
		#300 tup=0;
	join
endmodule