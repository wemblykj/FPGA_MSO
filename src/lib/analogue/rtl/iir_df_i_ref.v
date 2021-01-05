`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    23:12:48 12/17/2020 
// Design Name:    iir_df_i_ref
// Module Name:    iir_df_i_ref.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	A simple and configurable Nth order direct form I IIR filter implmentation.
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
module iir_df_i_ref
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
		 input [(COEFF_WIDTH*N)-1:0] packed_a_coeffs,	// packed a (feedback) coefficients
		 input [(COEFF_WIDTH*(N+1))-1:0] packed_b_coeffs,	// packed b (feed forward) coefficients
		 output signed [Y_WIDTH-1:0] y						// output
    );

	reg signed[PRECISION-1:0] x_1 [0:N];					// input delay line
	wire signed[PRECISION-1:0] d [0:N];					// feed forward accumulator
	wire signed [COEFF_WIDTH-1:0] b [0:N];				// unpacked b (feed forward) coefficients
	
	reg signed[PRECISION-1:0] y_1 [0:N-1];					// output delay line
	wire signed[PRECISION-1:0] m [0:N-1];					// feedback accumulator
	wire signed [COEFF_WIDTH-1:0] neg_a [0:N-1];			// unpacked -a (feedback) coefficients
	
	//wire signed [PRECISION-1:0] _x;							// preconditioned input
	wire signed [PRECISION-1:0] _y;							// pre-scaled output
	
	// input conditioning
	/*width_convertor #( .INPUT_WIDTH(X_WIDTH), .OUTPUT_WIDTH(PRECISION) )
		input_width_convertor (
			.in(x),
			.out(_x)	);
			*/
	
	// output conditioning
	/*width_convertor #( .INPUT_WIDTH(PRECISION), .OUTPUT_WIDTH(Y_WIDTH) )
		output_width_convertor (
			.in(_y),
			.out(y) );*/

	genvar t;
	generate
	
		for (t = 0; t < (N+1) ; t = t + 1) begin : for_feed_forward_stage
			assign b[t] = packed_b_coeffs[((COEFF_WIDTH*t)+COEFF_WIDTH)-1:COEFF_WIDTH*t];
			if (t == 0) begin : sum_initial
				assign d[t] = x_1[t] * b[t];
			end else begin : sum_cascade
				assign d[t] = d[t-1] + (x_1[t] * b[t]);
			end
		end
	
		for (t = 0; t < N ; t = t + 1) begin : for_feedback_stage
			assign neg_a[t] = -packed_a_coeffs[((COEFF_WIDTH*t)+COEFF_WIDTH)-1:COEFF_WIDTH*t];
			if (t == 0) begin : sum_initial
				assign m[t] = y_1[t] * a[t];
			end else begin : sum_cascade
				assign m[t] = m[t-1] + (y_1[t] * neg_a[t]);
			end
		end
	endgenerate
	
	assign _y = d[N] + m[N-1];
	assign y = { {(PRECISION-Q){_y[PRECISION-1]}}, _y[PRECISION-Q:Q] };
	
	integer i;
	always @(posedge clk or rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < (N+1) ; i = i + 1) begin : ff_delay_line_reset
				x_1[i] <= 0;
			end
			for (i = 0; i < N ; i = i + 1) begin : fb_delay_line_reset
				y_1[i] <= 0;
			end
		end else begin
			y_1[0] <= _y;
			x_1[0] <= x;
			
			for (i = 1; i < (N+1) ; i = i + 1) begin : ff_delay_line_cascade
				x_1[i] <= x_1[i-1];
			end
			
			for (i = 1; i < N ; i = i + 1) begin : fb_delay_line_cascade
				y_1[i] <= y_1[i-1];
			end
		end
	end
	
endmodule
