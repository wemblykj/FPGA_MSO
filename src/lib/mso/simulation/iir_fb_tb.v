`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:25:25 12/22/2020
// Design Name:   iir_fb
// Module Name:   C:/Development/FPGA/FPGA_MSO/src/lib/mso/simulation/iir_fb_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: iir_fb
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module iir_fb_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg [15:0] x;
	
	// Outputs
	wire [15:0] y;
	
	// Instantiate the Unit Under Test (UUT)
	iir_fb 
		#(
			.M(1),
			.PRECISION(16),
			.COEFF_WIDTH(14),
			.Q(12)
		)
		uut (
		.rst_n(rst_n), 
		.clk(clk), 
		.x(x), 
		.packed_a_coeffs({ -2048 }), 
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
		#10;
		x = -3; #10; 
		x = 2; #10; 
		x = 0; #100; 
		
      $finish;
		
	end
      
	always #5 clk = ~clk;
      
endmodule

