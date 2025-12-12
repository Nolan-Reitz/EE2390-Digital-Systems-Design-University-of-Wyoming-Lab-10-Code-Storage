// display.v for lab 10
// written by Nolan Reitz
// Started 11/12/2025
//"finished" 11/12/2025

module display (sevenSeg, displaySelect, decimal, mins, tens, ones, tenths, clk, reset, flashState, lapState);
	output [6:0] sevenSeg;
	output [3:0] displaySelect;
	output decimal;
	
	input [3:0] mins, tens, ones, tenths;
	input clk, reset, flashState, lapState;
	
	wire [3:0] hexVal;
	wire [3:0] blankDisp; 
	reg [24:0] clk_div_cnt;
	
	reg [3:0] minsHold, tensHold, onesHold, tenthsHold;
	
	always @(lapState)
	   if (lapState) begin
	       minsHold <=  minsHold;
	       tensHold <=  tensHold;
	       onesHold <=  onesHold;
	       tenthsHold <=  tenthsHold;
	   end
	   else begin 
	       minsHold <= mins;
	       tensHold <= tens;
	       onesHold <= ones;
	       tenthsHold <= tenths;
        end
	always @(posedge clk)
	   clk_div_cnt = clk_div_cnt + 1;
	
	assign blankDisp = flashState ? ((clk_div_cnt[24] == 1) ? 4'b1111: 4'b0000) : 4'b0000; 

	Mux4Machine mux (hexVal, displaySelect, minsHold, tensHold, onesHold, tenthsHold, clk, reset, blankDisp);
	
	sevenseghexdecoder decode (sevenSeg, hexVal, flashState);
	
	assign decimal = ~((displaySelect == 4'b0111) | (displaySelect == 4'b1101));
	
endmodule