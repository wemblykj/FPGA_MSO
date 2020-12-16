`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:49:09 12/15/2020 
// Design Name: 
// Module Name:    cic_decimator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module cic_decimator
	#(
		// characteristics
		parameter R = 2,	// decimation factor - default 2 (factor of 2)
		parameter D = 1,	// delay line length - currently implementation is hardcoded to 1
		parameter M = 2,	// multistage order - currently implementation is hardcoded to 2
		// precision
		parameter X_WIDTH = 12,
		parameter Y_WIDTH = X_WIDTH,
		parameter PRECISION = Y_WIDTH
	)
	(
		input rst_n,
		input clk,
		input enabled,
		input signed [X_WIDTH-1:0] x,
		output reg clk_transfer,
		output [Y_WIDTH-1:0] y
	);

	reg [$clog2(R+1):0] decimation_counter;
	reg substage_clk;
	
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
	
	genvar i;
	generate
		// input conditioning
		if (X_WIDTH > PRECISION) begin : trim_input
			assign integrator_in[0] = x[X_WIDTH-1:X_WIDTH-PRECISION];
		end else begin : pad_input
			assign integrator_in[0] = {x[X_WIDTH-1:0], {(PRECISION-X_WIDTH){1'b0}}};
		end
		
		// output conditioning
		if (PRECISION > Y_WIDTH) begin : trim_output
			assign y = comb_out[M-1][PRECISION-1:PRECISION-Y_WIDTH];	
		end else begin : pad_output
			assign y = {comb_out[M-1], {(Y_WIDTH-PRECISION){1'b0}}};	
		end
	
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
				.D(D),
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
