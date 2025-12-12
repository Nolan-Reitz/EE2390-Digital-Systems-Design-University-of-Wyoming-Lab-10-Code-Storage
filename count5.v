// count5.v
module count5(cnt,clk,clr,en,up,upen,bken);
	output [3:0] cnt;
	output       upen, bken;
	input        clk, clr, en, up;

	reg    [3:0] cnt, ncnt;

	always @(posedge clk)
	begin
		if(en)
			if(clr)
				cnt <= 0;
			else
				cnt <= ncnt;
		else
			cnt <= cnt;
	end

	always @(cnt or up)
	begin
		if(up)
			ncnt=(cnt==5) ? 0 : cnt+1;
		else
			ncnt=(cnt==0) ? 5 : cnt-1;
	end

	assign upen = (cnt==5) && up && en;
	assign bken = (cnt==0) && !up && en;
endmodule















