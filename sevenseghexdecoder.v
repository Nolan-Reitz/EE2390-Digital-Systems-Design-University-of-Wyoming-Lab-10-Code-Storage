// sevenseghexdecorder.v for EE 2390 Lab #4
// Laura Oler
// Sep. 12, 2022
`timescale 1 ns / 1ps
module sevenseghexdecoder(Seg, HexVal, flashState);
	output [0:6] Seg;
	input [3:0] HexVal;
	input flashState;
	reg [0:6] Seg;
	/*  Signal correspondence is as follows:
		Display Segment: a b c d e f g (all active low)
		Seg output bit:  0 1 2 3 4 5 6
		HexVal[3:0] has MSb at bit 3 and LSb at bit 0
	*/
	always @(HexVal)
	begin
	   if (~flashState)
            case (HexVal)
                4'h0:	Seg = 7'b000_0001; // forms the character for 0
                4'h1:	Seg = 7'b100_1111;
                4'h2:	Seg = 7'b001_0010;
                4'h3:	Seg = 7'b000_0110;
                4'h4:	Seg = 7'b100_1100;
                4'h5:	Seg = 7'b010_0100;
                4'h6:	Seg = 7'b010_0000;
                4'h7:	Seg = 7'b000_1111;
                4'h8:	Seg = 7'b000_0000;
                4'h9:	Seg = 7'b000_0100;
                4'hA:	Seg = 7'b000_1000;
                4'hB:	Seg = 7'b110_0000;
                4'hC:	Seg = 7'b011_0001;
                4'hD:	Seg = 7'b100_0010;
                4'hE:	Seg = 7'b011_0000;
                4'hF:	Seg = 7'b011_1000;	
                default: Seg = 7'b111_1111; // default is all off
            endcase
          else Seg = 7'b000_0001;
	end
endmodule

