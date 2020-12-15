`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:09:14 12/15/2020 
// Design Name: 
// Module Name:    integrator 
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
module cic_integrator
	#(
		parameter DATA_WIDTH = 12
	)
	(
		input rst_n,
		input clk,
		input [DATA_WIDTH-1:0] x,
		output [DATA_WIDTH-1:0] y
    );

	reg [DATA_WIDTH-1:0] z;
	
	always @(posedge clk or rst_n) begin
		if (!rst_n) begin
			z <= 0;
		end else begin
			z <= z + x;
		end
	end
	
	assign y = z;
	
endmodule