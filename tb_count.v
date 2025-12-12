// tb_count.v
`timescale 1ns / 1ns
module tb_count();
	reg	   tclk, tclr, ten, tup;
	wire [3:0] tcnt;
	wire       tupen, tbken;
	count dut(tcnt,tclk,tclr,ten,tup,tupen,tbken);

	always
		#10 tclk = !tclk;

	initial
	begin
		$dumpfile("tb_count.vcd");
		$dumpvars(0,tb_count);
		tclk=0; tclr=1; ten=1; tup=1;
		#500 $finish;
	end

	initial
	begin
		#40 tclr=0;
		#160 ten=0;
		#40 ten=1;
	end
	initial
	begin
		#320 tup=0;
	end
endmodule