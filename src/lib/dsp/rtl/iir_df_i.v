`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    23:12:48 12/17/2020 
// Design Name:    iir_df_i
// Module Name:    iir_df_i.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	An Nth order direct form I IIR filter implmentation.
//						This implementation is in no way optimised.
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
module iir_df_i
	#(
		// characteristics
		parameter N = 2,							// Nth-order
		
		// precision
		parameter X_WIDTH = 12,					// input vertical precision
		parameter Y_WIDTH = 12,					// ouput vertical precision
		parameter PRECISION = 16,				// internal vertical precision
		parameter COEFF_WIDTH = 16,			// coefficient precision
		parameter Q = 14							// coefficient scale factor index (2^Q)
	)
	(
		 input rst_n,													// reset
		 input clk,														// clock
		 input signed [X_WIDTH-1:0] x,							// input
		 input [(COEFF_WIDTH*N)-1:0] packed_a_coeffs,		// packed -a (feedback) coefficients
		 input [(COEFF_WIDTH*(N+1))-1:0] packed_b_coeffs,	// packed b (feed forward) coefficients
		 output signed [Y_WIDTH-1:0] y							// output
    );
	
	wire signed [COEFF_WIDTH-1:0] a0 = 1; // {{COEFF_WIDTH}{2**Q}};					// a0 = 1 * 2^Q
	
	wire signed [PRECISION-1:0] d;							// intermediate results
	
	df_i #(
			.N(N),
			.X_WIDTH(X_WIDTH),
			.Y_WIDTH(PRECISION),
			.PRECISION(PRECISION),
			.COEFF_WIDTH(COEFF_WIDTH),
			//.Q(Q)	// required if a0 = 1 * 2**Q
			.Q(0)	// we can retain scaled up output when a0 = 1
		)
		ff
		(
			.rst_n(rst_n),
			.clk(clk),
			.x(x),
			.packed_coeffs(packed_b_coeffs),
			.y(d)
		);
		
		df_i #(
			.N(N),
			.X_WIDTH(PRECISION),
			.Y_WIDTH(Y_WIDTH),
			.PRECISION(PRECISION),
			.COEFF_WIDTH(COEFF_WIDTH),
			.Q(Q)
		)
		fb
		(
			.rst_n(rst_n),
			.clk(clk),
			.x(d),
			.packed_coeffs( { packed_a_coeffs, a0 } ),
			.y(y)
		);

endmodule
