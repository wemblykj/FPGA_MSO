`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    00:10:23 12/18/2020 
// Design Name:    iir_fb
// Module Name:    iir_fb.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	Feedback stage of a configurable IIR filter implmentation.
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
module iir_fb
	#(
		// characteristics
		parameter M = 2,
		// precision
		parameter PRECISION = 24,				// internal vertical precision
		parameter COEFF_WIDTH = 16				// coefficient precision
	)
	(
		input rst_n,								// reset
		input clk,									// clock
		input signed [PRECISION-1:0] x,		// input
		input [(COEFF_WIDTH*M)-1:0] packed_a_coeffs,	// packed a (feedback) coefficients
		output signed [PRECISION-1:0] y				// output
    );
	 
	reg signed[PRECISION-1:0] y_1 [0:M-1];					// output delay line
	wire signed[PRECISION-1:0] d [0:M-1];					// feedback accumulator
	wire signed [COEFF_WIDTH-1:0] neg_a [0:M-1];			// unpacked -a (feedback) coefficients
	
	assign y = x + d[M-1];
	
	genvar t;
	generate
		for (t = 0; t < M ; t = t + 1) begin : for_stage
			assign neg_a[t] = -packed_a_coeffs[((COEFF_WIDTH*t)+COEFF_WIDTH)-1:COEFF_WIDTH*t];
			if (t == 0) begin : sum_initial
				assign d[t] = y_1[t] * neg_a[t];
			end else begin : sum_cascade
				assign d[t] = d[t-1] + (y_1[t] * neg_a[t]);
			end
		end
	endgenerate
	
	integer i;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < M ; i = i + 1) begin
				y_1[i] <= 0;
			end
		end else begin
			for (i = 1; i < M ; i = i + 1) begin
				y_1[i] <= y_1[i-1];
			end
			y_1[0] <= y;
		end
	end
	
endmodule
