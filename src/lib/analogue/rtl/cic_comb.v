`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    21:09:31 12/15/2020 
// Design Name:    cic_comb
// Module Name:    cic_comb.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	Provides a generic comb stage implmentation.
//
//						A from scratch implementation of a Cascading Integrator-Comb
//                Filter inspired by the the article:
//						'A Beginner's Guide To Cascaded Integrator-Comb (CIC) Filters'						
//						https://www.dsprelated.com/showarticle/1337.php
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// License:        https://www.apache.org/licenses/LICENSE-2.0
//
//////////////////////////////////////////////////////////////////////////////////
module cic_comb
	#(
		// characteristics
		parameter D = 1,						// feedback delay line length - default 1
		
		// precision
		parameter PRECISION = 12			// the vertical precision
	)
	(
		input rst_n,							// reset (active low)
		input clk,								// clock
		input signed [PRECISION-1:0] x,	// stage input
		output signed [PRECISION-1:0] y	// stage output
    );

	reg signed [PRECISION-1:0] z[0:D-1];
	
	integer i;
	
	always @(posedge clk or rst_n) begin
		if (!rst_n) begin
			for (i = 0; i < D; i = i + 1) begin
				z[i] <= 0;
			end
		end else begin
			z[0] <= x - z[D-1];
			for (i = 1; i < D; i = i + 1) begin
				z[i] <= z[i-1];
			end
		end
	end
	
	assign y = z[0];
	
endmodule
