`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    21:09:14 12/15/2020  
// Design Name:    cic_integrator
// Module Name:    cic_integrator.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	Provides a generic integrator stage implmentation.
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
module cic_integrator
	#(
		// characteristics
		
		// precision
		parameter PRECISION = 12			// the vertical precision
	)
	(
		input rst_n,							// reset (active low)
		input clk,								// clock
		input [PRECISION-1:0] x,			// stage input
		output [PRECISION-1:0] y			// stage output
    );

	reg [PRECISION-1:0] z;
	
	always @(posedge clk or rst_n) begin
		if (!rst_n) begin
			z <= 0;
		end else begin
			z <= z + x;
		end
	end
	
	assign y = z;
	
endmodule
