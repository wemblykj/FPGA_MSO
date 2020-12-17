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
	reg signed [7:0] x;

	// Outputs
	wire substage_clk;
	wire signed [7:0] y;

	// Instantiate the Unit Under Test (UUT)
	cic_decimator
		#(
			// characteristics
			.M(1),
			.D(5),
			.R(1),
			// precision
			.X_WIDTH(8),	// test input trimming
			.Y_WIDTH(8), // test ouput padding
			.PRECISION(3)		// test reduced precision processing
		)
		uut
		(
			.rst_n(rst_n), 
			.clk(clk), 
			.enabled(enabled), 
			.x(x), 
			.substage_clk(substage_clk), 
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
		
		x = 'h80;  #10;
		x = 0;  #10;
		#100;
		
		$finish;
	end
      
	always #5 clk = ~clk;
	
endmodule

