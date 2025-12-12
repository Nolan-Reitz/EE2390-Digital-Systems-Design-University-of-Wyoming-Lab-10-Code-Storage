// bigcount.v
module bigcount(msd,lsd,clk,clr,en,up);
	output [3:0] msd,lsd;
	input  clk,clr,en,up;

	wire  upen,bken,msden;
	count lsdig(lsd,clk,clr,en,up,upen,bken);
	count msdig(msd,clk,clr,msden,up, , );

	assign msden = (clr && en) || upen || bken;
endmodule