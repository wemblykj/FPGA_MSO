`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 1
// 
// Create Date:    14:55:50 12/13/2020 
// Design Name: 
// Module Name:    decimator 
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
module decimator#(
	SRC_DATA_WIDTH,
	DEST_DATA_WIDTH,
	COEFF_WIDTH = 7,
	NUM_TAPS = 5
)
(
    input src_clk,
    input [11:0] x,
    output dst_clk,
	 output reg [11:0] y
    );

	reg [SRC_DATA_WIDTH-1:0] Q [1:NUM_TAPS-1];
	wire [SRC_DATA_WIDTH-1:0] MCM [0:NUM_TAPS-1];
	wire [SRC_DATA_WIDTH-1:0] ADD_OUT [1:NUM_TAPS-1];
	
	genvar i;
	generate
		for (i = 0; i < 3 ; i = i + 1) begin
			assign MCM[i] = coeff[i]*x;
			if (i != 0)
				assign ADD_OUT[i] = Q[i] + MCM[(NUM_TAPS-1)-i];
		end
	endgenerate
	
	always @(posedge src_clk) begin
		Q1 <= MCM[3];
		Q2 <= ADD_OUT[1];
		Q3 <= ADD_OUT[2];
	end
	
	always @(posedge dest_clk) begin
		y <= ADD_OUT[3][SRC_DATA_WIDTH:SRC_DATA_WIDTH-DEST_DATA_WIDTH];
	end

endmodule
