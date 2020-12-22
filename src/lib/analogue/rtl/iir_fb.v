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
		// precision
		parameter PRECISION = 16				// internal vertical precision
	)
	(
		input rst_n,								// reset
		input clk,									// clock
		input signed [PRECISION-1:0] x,		// input
		input [(COEFF_WIDTH*N)-1:0] packed_b_coeffs,	// packed b (feed forward) coefficients
		output [PRECISION-1:0] y				// output
    );

	reg signed[PRECISION-1:0] x_1 [0:N-1];					// input delay line
	wire signed[PRECISION-1:0] d [0:N-1];					// feed forward accumulator
	wire signed [COEFF_WIDTH-1:0] b [0:N-1];				// unpacked b (feed forward) coefficients
	
	assign y = d[M-1];
	
	genvar t;
	generate
		for (t = 0; t < N ; t = t + 1) begin : for_stage
			assign b[t] = packed_b_coeffs[((COEFF_WIDTH*t)+COEFF_WIDTH)-1:COEFF_WIDTH*t];
			if (t == 0) begin : sum_initial
				assign d[t] = x_1[t] * b[t];
			end else begin : sum_cascade
				assign d[t] = d[t-1] + (x_1[t] * b[t]);
			end
		end
	endgenerate
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			x_1 <= 0;
		end else begin
			x_1 <= x;
		end
	end
	
endmodule
