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
		parameter PRECISION = 24,				// internal vertical precision
		parameter COEFF_WIDTH = 16,			// coefficient precision
		parameter Q = 14							// coefficient scale factor index (2^Q)
	)
	(
		 input rst_n,												// reset
		 input clk,													// clock
		 input signed [X_WIDTH-1:0] x,						// input
		 input [(COEFF_WIDTH*M)-1:0] packed_a_coeffs,	// packed a (feedback) coefficients
		 input [(COEFF_WIDTH*(M+1))-1:0] packed_b_coeffs,	// packed b (feed forward) coefficients
		 output signed [Y_WIDTH-1:0] y									// output
    );
	
	//wire signed [PRECISION-1:0] _x;							// preconditioned input
	wire signed [PRECISION-1:0] _y;							// pre-scaled output
	
	wire signed [PRECISION-1:0] d;							// intermediate results
	
	// input conditioning
	/*width_convertor #( .INPUT_WIDTH(X_WIDTH), .OUTPUT_WIDTH(PRECISION) )
		input_width_convertor (
			.in(x),
			.out(_x)	);*/
	
	// output conditioning
	/*width_convertor #( .INPUT_WIDTH(PRECISION), .OUTPUT_WIDTH(Y_WIDTH) )
		output_width_convertor (
			.in(_y),
			.out(y) );*/

	assign y = _y >> Q;
	
	iir_ff #(
			.N(N+1),
			.PRECISION(PRECISION),
			.COEFF_WIDTH(COEFF_WIDTH)
		)
		ff
		(
			.rst_n(rst_n),
			.clk(clk),
			.x(_x),
			.packed_b_coeffs(packed_b_coeffs),
			.y(d)
		);
		
		iir_fb #(
			.M(N),
			.PRECISION(PRECISION),
			.COEFF_WIDTH(COEFF_WIDTH)
		)
		fb
		(
			.rst_n(rst_n),
			.clk(clk),
			.x(d),
			.packed_a_coeffs(packed_a_coeffs),
			.y(_y)
		);

endmodule
