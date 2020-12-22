`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:32:54 12/21/2020
// Design Name:   iir_ff
// Module Name:   /home/administrator/Development/fpga/FPGA_MSO/src/lib/analogue/simulation/iir_ff_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: iir_ff
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module iir_ff_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg [15:0] x;
	reg b;

	// Outputs
	wire [15:0] y;

	// Instantiate the Unit Under Test (UUT)
	iir_ff uut (
		.rst_n(rst_n), 
		.clk(clk), 
		.x(x), 
		.b(b), 
		.y(y)
	);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		x = 0;
		b = 1;

		// Wait 100 ns for global reset to finish
		#100;
      rst_n = 1; #10;
		
		// Add stimulus here
		x = 1;	#20;
		x = 0;	#20;
		
		$finish;
		
	end
      
	always #5 clk = ~clk;
	
endmodule

