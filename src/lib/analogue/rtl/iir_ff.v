`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    00:08:11 12/18/2020 
// Design Name:    iir_ff
// Module Name:    iir_ff.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	Feed forward stage of a configurable IIR filter implmentation.
//						This implmentation is in no way optimised.
//
//						Based on Z-transform and description from THE Z-TRANSFORM
//						https://flylib.com/books/en/2.729.1/the_z_transform.html
//						
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// License:        https://www.apache.org/licenses/LICENSE-2.0
//
//////////////////////////////////////////////////////////////////////////////////
module iir_ff
	#(
		// precision
		parameter PRECISION = 16				// internal vertical precision
	)
	(
		input rst_n,												// reset
		input clk,													// clock
		input signed [PRECISION-1:0] x,							// input
		input signed b,											// stage coefficient
		output [PRECISION-1:0] y									// output
    );


endmodule
