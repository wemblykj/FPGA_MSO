`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    14:55:50 12/13/2020
// Design Name:    fir_ref
// Module Name:    fir_ref.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	A simple and configurable FIR filter implmentation.
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
module fir_ref
#(
	// characteristics
	parameter N = 4,							// number of taps (order + 1)
	
	// precision
	parameter X_WIDTH = 12,					// input vertical precision
	parameter Y_WIDTH = 12,					// ouput vertical precision
	parameter PRECISION = 16,				// internal vertical precision
	parameter COEFF_WIDTH = 8				// vertical precision
)
(
	 input rst_n,											// reset
    input clk,												// clock
    input signed [X_WIDTH-1:0] x,					// input
    input [(COEFF_WIDTH*N)-1:0] packed_coeffs,	// packed coefficients
    output [Y_WIDTH-1:0] y								// output
    );

	reg signed[PRECISION-1:0] z [0:N-1];					// delay line
	wire signed[PRECISION-1:0] m [0:N-1];					// accumulator
	wire signed [COEFF_WIDTH-1:0] h [0:N-1];				// unpacked coefficients
	
	wire signed [PRECISION-1:0] _x;							// preconditioned input
	wire signed [PRECISION-1:0] _y;							// preconditioned output
	
	assign _y = m[N-1];
	
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
		for (t = 0; t < N ; t = t + 1) begin : for_taps
			assign h[t] = packed_coeffs[((COEFF_WIDTH*t)+COEFF_WIDTH)-1:COEFF_WIDTH*t];
			if (t == 0) begin : sum_initial
				assign m[t] = z[t] * h[t];
			end else begin : sum_cascade
				assign m[t] = m[t-1] + (z[t] * h[t]);
			end
		end
	endgenerate
	
	integer i;
	always @(posedge clk or rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < N ; i = i + 1) begin : delay_line_reset
				z[i] <= 0;
			end
		end else begin
			z[0] <= _x;
			for (i = 1; i < N ; i = i + 1) begin : delay_line_cascade
				z[i] <= z[i-1];
			end
		end
	end
	
endmodule
