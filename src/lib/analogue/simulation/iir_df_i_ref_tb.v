`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:41:34 12/17/2020
// Design Name:   iir_ref
// Module Name:   C:/Users/paulw/Development/FPGA/FPGA_MSO/src/lib/analogue/simulation/iir_ref_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: iir_ref
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module iir_df_i_ref_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg [11:0] x;

	// Outputs
	wire [11:0] y;

	// Instantiate the Unit Under Test (UUT)
	iir_df_i_ref #(
		.M(2),					// 2nd-order
		.INPUT_WIDTH(12),
		.OUTPUT_WIDTH(16),
		.PRECISION(16), 
		.COEFF_WIDTH(14) )
	uut (
		.rst_n(rst_n), 
		.clk(clk), 
		.x(x), 
		.packed_a_coeffs({ 14'd5 }), 
		.packed_b_coeffs({ 14'd20, -14'd30 }), 
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
		x = 10; #10;
		x = 0; #100;


		$finish;
	end
   
	always #5 clk = ~clk;
	
endmodule

