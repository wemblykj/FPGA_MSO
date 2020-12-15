`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:26:04 12/15/2020
// Design Name:   cic_decimator
// Module Name:   /home/administrator/Development/fpga/FPGA_MSO/src/lib/mso/simulation/cic_decimator_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cic_decimator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cic_decimator_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg enabled;
	reg signed [11:0] x;

	// Outputs
	wire clk_transfer;
	wire signed [15:0] y;

	// Instantiate the Unit Under Test (UUT)
	cic_decimator
		#(
			.M(1),
			.D(5),
			.R(1)
		)
		uut
		(
			.rst_n(rst_n), 
			.clk(clk), 
			.enabled(enabled), 
			.x(x), 
			.clk_transfer(clk_transfer), 
			.y(y)
	);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		enabled = 0;
		x = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst_n = 1;
		
		// Add stimulus here
		enabled = 1;	#10
		
		x = 1000;  #10;
		x = 0;  #10;
		#100;
		
		$finish;
	end
      
	always #5 clk = ~clk;
	
endmodule

