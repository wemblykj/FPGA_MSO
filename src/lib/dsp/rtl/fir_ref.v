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
	parameter N = 4,							// order
	
	// precision
	parameter X_WIDTH = 12,					// input vertical precision
	parameter Y_WIDTH = 16,					// ouput vertical precision
	parameter PRECISION = 24,				// internal vertical precision
	parameter COEFF_WIDTH = 16,			// coefficient precision
	parameter Q = 14							// coefficient scale factor index (2^Q)
)
(
	 input rst_n,											// reset
    input clk,												// clock
    input signed [X_WIDTH-1:0] x,					// input
    input [(COEFF_WIDTH*(N+1))-1:0] packed_coeffs,	// packed coefficients
    output signed [Y_WIDTH-1:0] y								// output
    );
	
	reg signed[PRECISION-1:0] z [0:N];					// delay line
	wire signed[PRECISION-1:0] m [0:N];					// accumulator
	wire signed [COEFF_WIDTH-1:0] h [0:N];				// unpacked coefficients
	
	//wire signed [PRECISION-1:0] _x;							// preconditioned input
	wire signed [PRECISION-1:0] _y;							// pre-scaled output
	
	assign _y = m[N];
	assign y = _y >> Q;
	
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
				
	genvar t;
	generate
		for (t = 0; t < (N+1) ; t = t + 1) begin : for_taps
			assign h[t] = packed_coeffs[((COEFF_WIDTH*t)+COEFF_WIDTH)-1:COEFF_WIDTH*t];
			if (t == 0) begin : sum_initial
				assign m[t] = z[t] * h[t];
			end else begin : sum_cascade
				assign m[t] = m[t-1] + (z[t] * h[t]);
			end
		end
	endgenerate
	
	integer i;
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < (N+1) ; i = i + 1) begin : delay_line_reset
				z[i] <= 0;
			end
		end else begin
			z[0] <= x;
			for (i = 1; i < (N+1) ; i = i + 1) begin : delay_line_cascade
				z[i] <= z[i-1];
			end
		end
	end
	
endmodule
