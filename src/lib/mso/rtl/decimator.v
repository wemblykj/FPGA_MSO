`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    14:55:50 12/13/2020  
// Design Name:    decimator
// Module Name:    decimator.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	A decimator stage that uses a Cascading Integrator-Comb
//                Filter based decimator followed by an FIR based compensation
//						Inspired by the the article:
//						'A Beginner's Guide To Cascaded Integrator-Comb (CIC) Filters'						
//						https://www.dsprelated.com/showarticle/1337.php
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// License:        https://www.apache.org/licenses/LICENSE-2.0
//
//////////////////////////////////////////////////////////////////////////////////
module decimator
	#(
		// characteristics
		parameter M = 2,						// decimation factor - default 2 (factor of 2)
		// precision
		parameter X_WIDTH = 12,				// sensible default for a 12-bit ADC
		parameter Y_WIDTH = 16,				// sensible default for a 16-bit sample
		parameter PRECISION = Y_WIDTH		// sensible default for accumulating 12-bit input data
													// when using a multistage CIC pipeline
	)
	(
		input rst_n,											// reset
		input clk,												// clock
		input [X_WIDTH-1:0] x,
		output [Y_WIDTH-1:0] y
	);
		
	localparam COEFF_WIDTH = 4;
	
	wire substage_clk;
	wire [PRECISION-1:0] cic_out;
	
    cic_decimator
		#(
			.M(2),								// pre-calculated multistage order
			.D(M),								// pre-calculated delay line length
			.R(M),								// n.b. we are mapping M from the decimation domain to R in the CIC domain
			.X_WIDTH(X_WIDTH),
			.Y_WIDTH(PRECISION),
			.PRECISION(PRECISION)
		)
		cic_decimator
		(
			.rst_n(rst_n), 
			.clk(clk), 
			.enabled(1), 
			.x(x), 
			.substage_clk(substage_clk), 
			.y(cic_out)
		);
	
	fir_ref
	# (
		.X_WIDTH(PRECISION),
		.Y_WIDTH(Y_WIDTH),
		.PRECISION(PRECISION),
		.COEFF_WIDTH(4),
		.N(1))
		compensator 
	(
		.rst_n(rst_n),
		.clk(substage_clk), 
		.x(cic_out), 
		.y(y), 
		.packed_coeffs( { -4'd10 } )	// CIC order M=1: A=-18,  M=2->3: A=-10, M=4->5: A=-6, M=6->7: A=-4
	);
	
endmodule
