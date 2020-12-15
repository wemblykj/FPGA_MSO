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
module cic_decimator#(
		parameter R = 6,	// decimation factor
		parameter D = 1,	// delay line length - currently implementation is hardcoded to 1
		parameter M = 2,	// multistage order - currently implementation is hardcoded to 2
		parameter INPUT_WIDTH = 12,
		parameter OUTPUT_WIDTH = 16,
		parameter ACC_WIDTH = 24
	)
	(
		input rst_n,
		input clk,
		input enabled,
		input signed [INPUT_WIDTH-1:0] data_in,
		output reg clk_transfer,
		output reg [OUTPUT_WIDTH-1:0] data_out
	);

reg [$clog2(R+1):0] counter;
reg [INPUT_WIDTH-1:0] input_register;

wire [ACC_WIDTH-1:0] integrator1_in;
wire [ACC_WIDTH-1:0] integrator1_sum;
reg [ACC_WIDTH-1:0] integrator1_out;

wire [ACC_WIDTH-1:0] integrator2_in;
wire [ACC_WIDTH-1:0] integrator2_sum;
reg [ACC_WIDTH-1:0] integrator2_out;

wire [ACC_WIDTH-1:0] comb1_in;
reg [ACC_WIDTH-1:0] comb1_diff;
reg [ACC_WIDTH-1:0] comb1_delay;
reg [ACC_WIDTH-1:0] comb1_out;

wire [ACC_WIDTH-1:0] comb2_in;
reg [ACC_WIDTH-1:0] comb2_diff;
reg [ACC_WIDTH-1:0] comb2_delay;
reg [ACC_WIDTH-1:0] comb2_out;

always @(posedge clk or rst_n) begin
	if (!rst_n) begin
		counter = 0;
		input_register <= 0;
		integrator1_out <= 0;
		integrator2_out <= 0;
		
		comb1_out <= 0;
		comb1_delay <= 0;
		comb1_diff <= 0;
		
		comb2_out <= 0;
		comb2_delay <= 0;
		comb2_diff <= 0;
		
		data_out <= 0;
	end else if (enabled) begin
		input_register <= data_in;
		
		integrator1_out <= integrator1_sum;
		integrator2_out <= integrator2_sum;
		
		// ? perform decimation after 1 input has been processed ? 
		// based on Googled code - this may or may not be correct
		if (counter === 1) begin
			comb1_diff <= comb1_delay;
			comb1_delay <= comb1_in;
			
			comb2_diff <= comb2_delay;
			comb2_delay <= comb2_in;
			
			data_out <= comb2_out[ACC_WIDTH-1:ACC_WIDTH-OUTPUT_WIDTH];
			clk_transfer <= 1;
		end else
			clk_transfer <= 0;
		
		if (counter <= R)
			counter <= counter + 1;
		else
			counter <= 0;
	end
end

assign integrator1_in = { {(ACC_WIDTH-INPUT_WIDTH){input_register[INPUT_WIDTH-1]}}, input_register[INPUT_WIDTH-1:0] };
assign integrator1_sum = integrator1_out + integrator1_in;

assign integrator2_in = integrator1_out;
assign integrator2_sum = integrator2_out + integrator2_in;

assign comb1_in = integrator2_out;
assign comb1_sub = comb1_in + comb1_diff;

assign comb2_in = comb1_out;
assign comb2_sub = comb2_in + comb2_diff;

endmodule
