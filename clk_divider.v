//clock divider module
//start 11/12/25
//Lily Trujillo
//finished 11/12/25

module clk_div(input clk, rst, output clk_divide, faster_clk_divide);
	reg [23:0] clk_cnt;
	
	//code for the clock divider, it counts the number of clock cycles, and when the value hits 10 million, the number of 10ns pulses there are in .1 s, then it outputs a clock pulse.
	always @(posedge clk, posedge rst)
		//possible bug found 11/20 3:34 PM by Nolan, rst is active high, this reset, however, was set for an active low. toggled value, will report on error states
		if (rst) clk_cnt <= 24'd0;
		//if the clock has elapsed enough clock cycles, then the value gets reset to zero and the process starts agains
		else if(clk_cnt == 24'd10000000) clk_cnt <= 24'd0;
		else clk_cnt <= clk_cnt + 24'd1; // else just count
	assign clk_divide = clk_cnt[23]; //generates the clock pulse based on the msb of the counter var, which will be 1 for a little while before the decimal value 10 million is reached, generating a satisfactory clock pulse
	assign faster_clk_divide = clk_cnt[21];
endmodule