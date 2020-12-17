`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    22:13:37 12/16/2020 
// Design Name:    width_convertor
// Module Name:    width_convertor.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	Converts a signal from one vertical precision to another.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// License:        https://www.apache.org/licenses/LICENSE-2.0
//
//////////////////////////////////////////////////////////////////////////////////
module width_convertor
	#(
		parameter INPUT_WIDTH = 12,					// input vertical precision
		parameter OUTPUT_WIDTH = 12					// ouput vertical precision
	)
	(
		input [INPUT_WIDTH-1:0] in,					// input signal
		output [OUTPUT_WIDTH-1:0] out					// output signal
   );

	generate
		if (INPUT_WIDTH < OUTPUT_WIDTH) begin : pad_input
			assign out = { in[INPUT_WIDTH-1:0], {(OUTPUT_WIDTH-INPUT_WIDTH){1'b0}} };
		end else begin : trim_input
			assign out = in[INPUT_WIDTH-1:INPUT_WIDTH-OUTPUT_WIDTH];
		end
	endgenerate
	
endmodule
