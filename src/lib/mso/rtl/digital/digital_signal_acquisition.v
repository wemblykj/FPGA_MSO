`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    12:23:08 12/17/2020 
// Design Name:    digital_signal_acquisition
// Module Name:    digital_signal_acquisition.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	Digital domain acquisition.
//
//						A from scratch implementation of an MSO oscillosope
//						(and signal generator)
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// License:        https://www.apache.org/licenses/LICENSE-2.0
//////////////////////////////////////////////////////////////////////////////////
module digital_signal_acquisition
	#(
		parameter NUM_SIGNALS = 8
	)
	(
		input rst_n,
		input clk,
		input [NUM_SIGNALS-1:0] in,
		output trigger
    );

	digital_decimation
		decimator (
			.rst_n(rst_n),
			.clk(clk) );
			
endmodule
