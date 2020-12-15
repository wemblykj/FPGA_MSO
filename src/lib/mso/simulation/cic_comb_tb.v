`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:53:26 12/15/2020
// Design Name:   cic_comb
// Module Name:   C:/Development/FPGA/FPGA_MSO/src/lib/mso/simulation/cic_comb_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cic_comb
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cic_comb_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg [11:0] x;

	// Outputs
	wire [11:0] y;

	// Instantiate the Unit Under Test (UUT)
	cic_comb uut (
		.rst_n(rst_n), 
		.clk(clk), 
		.x(x), 
		.y(y)
	);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		x = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

