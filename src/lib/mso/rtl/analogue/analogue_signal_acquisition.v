`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    12:23:08 12/17/2020 
// Design Name:    analogue_signal_acquisition
// Module Name:    analogue_signal_acquisition.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	Analogue domain acquisition.
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
module analogue_signal_acquisition(
		input rst_n,
		input clk,
		output trigger
    );

	analogue_decimation
		decimator (
			.rst_n(rst_n),
			.clk(clk) );
			
endmodule
