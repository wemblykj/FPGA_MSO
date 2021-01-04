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
		// characteristics
		parameter N = 3,
		// precision
		parameter PRECISION = 16,				// internal vertical precision
		parameter COEFF_WIDTH = 8,				// vertical precision
		parameter Q = 1
	)
	(
		input rst_n,								// reset
		input clk,									// clock
		input signed [PRECISION-1:0] x,		// input
		input signed [(COEFF_WIDTH*N)-1:0] packed_b_coeffs,	// packed b (feed forward) coefficients
		output signed [PRECISION-1:0] y				// output
    );

	reg signed[PRECISION-1:0] x_1 [0:N-1];					// input delay line
	wire signed[PRECISION-1:0] d [0:N-1];					// feed forward accumulator
	wire signed [COEFF_WIDTH-1:0] b [0:N-1];				// unpacked b (feed forward) coefficients
	
	//assign y = {{Q{d[N-1][PRECISION-Q]}}, {d[N-1][PRECISION-Q-1:Q]}};
	assign y = {{Q{d[N-1][PRECISION-Q]}}, {d[N-1][PRECISION-Q-1:Q]}};
			
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
	
	integer i;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < N ; i = i + 1) begin
				x_1[i] <= 0;
			end
		end else begin
			for (i = 1; i < N ; i = i + 1) begin
				x_1[i] <= x_1[i-1];
			end
			x_1[0] <= x;
		end
	end
	
endmodule
