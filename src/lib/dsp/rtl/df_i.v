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
// Description: 	An Nth order direct form I filter pipeline..
//						This implmentation is in no way optimised.
//						
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// License:        https://www.apache.org/licenses/LICENSE-2.0
//
//////////////////////////////////////////////////////////////////////////////////
module df_i
	#(
		// characteristics
		parameter N = 3,							// Nth-order filter
		// precision
		parameter X_WIDTH = 12,					// input vertical precision
		parameter Y_WIDTH = 12,					// ouput vertical precision
		parameter PRECISION = 16,				// internal vertical precision
		parameter COEFF_WIDTH = 16,			// precision
		parameter Q = 14,							// coefficient scale factor index (2^Q)
	)
	(
		input rst_n,															// reset
		input clk,																// clock
		input signed [X_WIDTH-1:0] x,										// input
		input signed [(COEFF_WIDTH*(N+1))-1:0] packed_coeffs,		// packed coefficients
		output signed [Y_WIDTH-1:0] y										// output
    );

	reg signed[PRECISION-1:0] z [0:N];						// delay line
	wire signed[PRECISION-1:0] d [0:N];						// accumulator
	wire signed [COEFF_WIDTH-1:0] h [0:N];					// unpacked coefficients
	wire signed [PRECISION-1:0] _y;							// pre-scaled output	
	
	assign _y = d[N];
	assign y = { {(Q){_y[PRECISION-1]}}, _y[PRECISION-1:Q] };
			
	genvar t;
	generate
		for (t = 0; t < (N+1) ; t = t + 1) begin : for_stage
			assign h[t] = packed_coeffs[((COEFF_WIDTH*t)+COEFF_WIDTH)-1:COEFF_WIDTH*t];
			if (t == 0) begin : sum_initial
				assign d[t] = z[t] * h[t];
			end else begin : sum_cascade
				assign d[t] = d[t-1] + (z[t] * h[t]);
			end
		end
	endgenerate
	
	integer i;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < (N+1) ; i = i + 1) begin
				z[i] <= 0;
			end
		end else begin
			for (i = 1; i < (N+1) ; i = i + 1) begin
				z[i] <= z[i-1];
			end
			z[0] <= x;
		end
	end
	
endmodule
