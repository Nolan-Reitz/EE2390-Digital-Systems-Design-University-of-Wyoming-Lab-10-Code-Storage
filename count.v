
// count.v
module count(cnt,clk,clr,en,up,upen,bken, rollover);
	output [3:0] cnt;
	output       upen, bken;
	output reg rollover;
	input        clk, clr, en, up;

	reg    [3:0] cnt, ncnt;

	always @(posedge clk)
	begin
		if(en) //begin
			if(clr)
				cnt <=  0; //should be 0, 1 currently for debugging purposes
			else
				cnt <= ncnt; //ncn
		//end
		else
			cnt <= cnt;//cnt
	end

	always @(cnt or up)
	begin
		if(up)begin
			rollover = cnt == 9 ? 1'b1 : 1'b0;
			ncnt=(cnt==9) ? 0 : cnt+1;
		end else begin
			rollover = cnt == 0 ? 1'b1 : 1'b0;
			ncnt=(cnt==0) ? 9 : cnt-1;
		end
	end

	assign upen = (cnt==9) && up && en;
	assign bken = (cnt==0) && !up && en;
endmodule

/*
module count(cnt, clk, clr, en, up, upen, bken);
    output [3:0] cnt;
    output       upen, bken;
    input        clk, clr, en, up;

    reg [3:0] cnt, ncnt;

    // Sequential update
    always @(posedge clk) begin
        if (clr) 
            cnt <= 4'd0;            // synchronous reset
        else if (en) 
            cnt <= ncnt;            // update count
    end

    // Next-state logic
    always @(*) begin
        if (up)
            ncnt = (cnt == 9) ? 0 : cnt + 1;
        else
            ncnt = (cnt == 0) ? 9 : cnt - 1;
    end

    // Rollover signals (for chaining)
    assign upen = (cnt == 9) && up && en;
    assign bken = (cnt == 0) && !up && en;

endmodule

*/