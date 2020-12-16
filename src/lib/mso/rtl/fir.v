`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Compandata_out: 
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
module fir
	#(
		parameter DATA_WIDTH = 8,
		parameter COEFF_WIDTH = 8,
		parameter NUM_TAPS = 4
	)
	(
		 input rst_n,
		 input clk,
		 input signed [DATA_WIDTH-1:0] data_in,
		 input [(COEFF_WIDTH*NUM_TAPS)-1:0] packed_coeffs,
		 output reg [DATA_WIDTH-1:0] data_out
    );

	reg signed[DATA_WIDTH-1:0] Q [1:NUM_TAPS-1];
	wire signed [DATA_WIDTH-1:0] MCM [0:NUM_TAPS-1];
	wire signed [DATA_WIDTH-1:0] ADD_OUT [1:NUM_TAPS-1];
	wire signed [COEFF_WIDTH-1:0] h [0:NUM_TAPS-1];
	
	genvar i;
	genvar a_msb;
	genvar a_lsb;
	generate
		for (i = 0; i < NUM_TAPS ; i = i + 1) begin : for_taps
			assign h[i] = packed_coeffs[((COEFF_WIDTH*i)+COEFF_WIDTH)-1:COEFF_WIDTH*i];
			assign MCM[i] = h[i] * data_in;
			if (i != 0) begin : no_first
				assign ADD_OUT[i] = Q[i] + MCM[(NUM_TAPS-1)-i];
			end
		end
	endgenerate
	
	always @(posedge clk or rst_n) begin
		if (!rst_n) begin
			Q[1] <= 0;
			Q[2] <= 0;
			Q[3] <= 0;
			data_out <= 0;
		end else begin
			Q[1] <= MCM[3];
			Q[2] <= ADD_OUT[1];
			Q[3] <= ADD_OUT[2];
			data_out <= ADD_OUT[3];
		end
	end
	
endmodule
