`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:52:52 12/15/2020
// Design Name:   cic_integrator
// Module Name:   C:/Development/FPGA/FPGA_MSO/src/lib/mso/simulation/cic_integrator_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cic_integrator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cic_integrator_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg [11:0] x;

	// Outputs
	wire [11:0] y;

	// Instantiate the Unit Under Test (UUT)
	cic_integrator uut (
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
      rst_n = 1;
		
		// Add stimulus here
		x = 1;  #10;
		x = 0;  #10;
		#100;
		
		$finish;
	end
      
	always #5 clk = ~clk;
      
endmodule

