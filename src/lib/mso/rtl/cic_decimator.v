`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    12:49:09 12/15/2020 
// Design Name:    cic_decimator
// Module Name:    cic_decimator.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	A from scratch implementation of a Cascading Integrator-Comb
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
module cic_decimator
	#(
		// characteristics
		parameter R = 2,						// decimation factor - default 2 (factor of 2)
		parameter D = 2,						// delay line length - default 2
		parameter M = 2,						// multistage order - default 2
		// precision
		parameter X_WIDTH = 12,				// the input vertical precision
		parameter Y_WIDTH = X_WIDTH,		// the output vertical precision
		parameter PRECISION = Y_WIDTH		// the internal vertical precision
	)
	(
		input rst_n,							// reset (active low)
		input clk,								// clock
		input enabled,
		input signed [X_WIDTH-1:0] x,
		output reg substage_clk,
		output signed [Y_WIDTH-1:0] y
	);

	reg [$clog2(R+1):0] decimation_counter;
	
	always @(posedge clk or rst_n) begin
		if (!rst_n) begin
			decimation_counter = 0;
			substage_clk = 0;
		end else if (enabled) begin
			if (decimation_counter < R) begin	
				substage_clk <= 0;
				decimation_counter <= decimation_counter + 1;
			end else begin
				substage_clk <= 1;
				decimation_counter <= 0;
			end
		end
	end
	
	wire [PRECISION-1:0] integrator_in [0:M-1];
	wire [PRECISION-1:0] integrator_out [0:M-1];
	wire [PRECISION-1:0] comb_in [0:M-1];
	wire [PRECISION-1:0] comb_out [0:M-1];
	
	wire signed [PRECISION-1:0] _x;									// preconditioned input
	wire signed [PRECISION-1:0] _y;									// preconditioned output
	
	assign integrator_in[0] = _x;
	assign _y = comb_out[M-1];
	
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

	genvar i;
	generate
		// generate M integrator stages
		for (i = 0; i < M; i = i + 1) begin : integrator_stage
			cic_integrator 
			#(
				.PRECISION(PRECISION)
			)
			inst
			(
				.rst_n(rst_n), 
				.clk(clk),
				.x(integrator_in[i]),
				.y(integrator_out[i])
			);
			
			if (i !== 0) begin : integrator_stage_interconnects
				assign integrator_in[i] = integrator_out[i-1];
			end
				
		end
		
		// generate M comb [sub]stages
		for (i = 0; i < M; i = i + 1) begin : comb_stage
			cic_comb
			#(
				.D(D/R),	// reduced rate delay line length N can be calculated as D/R (https://www.dsprelated.com/showarticle/1337.php)
				.PRECISION(PRECISION)
			)
			inst
			(
				.rst_n(rst_n), 
				.clk(substage_clk),
				.x(comb_in[i]),
				.y(comb_out[i])
			);
			
			if (i === 0) begin : comb_stage_input
				assign comb_in[i] = integrator_out[M-1];
			end else begin : comb_stage_interconnects
				assign comb_in[i] = comb_out[i-1];
			end
		end
	endgenerate
	
endmodule
