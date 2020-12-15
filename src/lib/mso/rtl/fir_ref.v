`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 1
// 
// Create Date:    14:55:50 12/13/2020 
// Design Name: 
// Module Name:    fir 
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
module fir_ref
#(
	parameter DATA_WIDTH = 8,
	parameter COEFF_WIDTH = 8,
	parameter NUM_TAPS = 4
)
(
	 input rst_n,
    input clk,
    input signed [DATA_WIDTH-1:0] data_in,
    input [(COEFF_WIDTH*NUM_TAPS)-1:0] packed_coeff,
    output [DATA_WIDTH-1:0] data_out
    );

	reg signed[DATA_WIDTH-1:0] x [0:NUM_TAPS-1];
	wire signed[DATA_WIDTH-1:0] m [0:NUM_TAPS-1];
	wire signed [COEFF_WIDTH-1:0] h [0:NUM_TAPS-1];
	
	genvar i;
	genvar a_msb;
	genvar a_lsb;
	generate
		for (i = 0; i < NUM_TAPS ; i = i + 1) begin : for_taps
			assign h[i] = packed_coeff[((COEFF_WIDTH*i)+COEFF_WIDTH)-1:COEFF_WIDTH*i];
			if (i == 0) begin : no_first
				assign m[i] = x[i] * h[i];
			end else begin
				assign m[i] = m[i-1] + (x[i] * h[i]);
			end
		end
	endgenerate
	
	assign data_out = m[NUM_TAPS-1];
	
	integer ti;
	always @(posedge clk or rst_n) begin
		if (!rst_n) begin
			for (ti = 0; ti < NUM_TAPS ; ti = ti + 1) begin : reset_taps
				x[ti] <= 0;
			end
		end else begin
			x[0] <= data_in;
			for (ti = 1; ti < NUM_TAPS ; ti = ti + 1) begin : cascade_taps
				x[ti] <= x[ti-1];
			end
		end
	end
	
endmodule
