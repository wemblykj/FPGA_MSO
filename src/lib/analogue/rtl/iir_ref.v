`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    23:12:48 12/17/2020 
// Design Name:    iir_ref
// Module Name:    iir_ref.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	A simple and configurable IIR filter implmentation.
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
module iir_ref
	#(
		// characteristics
		parameter M = 2,							// number of feedback stages (Mth-order)
		
		// precision
		parameter X_WIDTH = 12,					// input vertical precision
		parameter Y_WIDTH = 12,					// ouput vertical precision
		parameter PRECISION = 16,				// internal vertical precision
		parameter COEFF_WIDTH = 8				// vertical precision
	)
	(
		 input rst_n,												// reset
		 input clk,													// clock
		 input signed [X_WIDTH-1:0] x,						// input
		 input [(COEFF_WIDTH*M)-1:0] packed_a_coeffs,	// packed a (feedback) coefficients
		 input [(COEFF_WIDTH*N)-1:0] packed_b_coeffs,	// packed b (feed forward) coefficients
		 output [Y_WIDTH-1:0] y									// output
    );

	localparam N = M+1;											// number of feed forward stages (order M plus 1)
	
	reg signed[PRECISION-1:0] x_1 [0:N-1];					// input delay line
	wire signed[PRECISION-1:0] d [0:N-1];					// feed forward accumulator
	wire signed [COEFF_WIDTH-1:0] b [0:N-1];				// unpacked b (feed forward) coefficients
	
	reg signed[PRECISION-1:0] y_1 [0:M-1];					// output delay line
	wire signed[PRECISION-1:0] m [0:M-1];					// feedback accumulator
	wire signed [COEFF_WIDTH-1:0] a [0:M-1];				// unpacked a (feedback) coefficients
	
	wire signed [PRECISION-1:0] _x;							// preconditioned input
	wire signed [PRECISION-1:0] _y;							// preconditioned output
	
	// input conditioning
	width_convertor #( .INPUT_WIDTH(X_WIDTH), .OUTPUT_WIDTH(PRECISION) )
		input_width_convertor (
			.in(x),
			.out(_x)	);
	
	// output conditioning
	width_convertor #( .INPUT_WIDTH(PRECISION), .OUTPUT_WIDTH(Y_WIDTH) )
		output_width_convertor (
			.in(_y),
			.out(y) );

	genvar t;
	generate
	
		/*if (N > 0) begin : if_use_feed_forward
			assign x_1[0] = _x;						// input goes to feed forward stage
			//assign y_1[0] = y_1[N-1] + m[M-1];	// feed forward accumulator goes to feedback stage
		end else begin : feedback_only
			assign y_1[0] = _x + m[N-1];			// input goes direct to feedback stage
		end*/
		
		for (t = 0; t < N ; t = t + 1) begin : for_feed_forward_stage
			assign b[t] = packed_b_coeffs[((COEFF_WIDTH*t)+COEFF_WIDTH)-1:COEFF_WIDTH*t];
			if (t == 0) begin : sum_initial
				assign d[t] = x_1[t] * b[t];
			end else begin : sum_cascade
				assign d[t] = d[t-1] + (x_1[t] * b[t]);
			end
		end
	
		for (t = 0; t < M ; t = t + 1) begin : for_feedback_stage
			assign a[t] = packed_a_coeffs[((COEFF_WIDTH*t)+COEFF_WIDTH)-1:COEFF_WIDTH*t];
			if (t == 0) begin : sum_initial
				assign m[t] = y_1[t] * a[t];
			end else begin : sum_cascade
				assign m[t] = m[t-1] + (y_1[t] * a[t]);
			end
		end
	endgenerate
	
	assign _y = d[N-1] + m[M-1];
	
	integer i;
	always @(posedge clk or rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < N ; i = i + 1) begin : ff_delay_line_reset
				x_1[i] <= 0;
			end
			for (i = 0; i < M ; i = i + 1) begin : fb_delay_line_reset
				y_1[i] <= 0;
			end
		end else begin
			y_1[0] <= _y;
			x_1[0] <= _x;
			
			for (i = 1; i < N ; i = i + 1) begin : ff_delay_line_cascade
				x_1[i] <= x_1[i-1];
			end
			
			for (i = 1; i < N ; i = i + 1) begin : fb_delay_line_cascade
				y_1[i] <= y_1[i-1];
			end
		end
	end
	
endmodule
