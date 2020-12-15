`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:09:31 12/15/2020 
// Design Name: 
// Module Name:    comb 
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
module cic_comb
	#(
		parameter D = 1,
		parameter DATA_WIDTH = 12
	)
	(
		input rst_n,
		input clk,
		input signed [DATA_WIDTH-1:0] x,
		output signed [DATA_WIDTH-1:0] y
    );

	reg signed [DATA_WIDTH-1:0] z[0:D-1];
	
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
