`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:22:13 01/04/2021
// Design Name:   iir_df_i
// Module Name:   C:/Development/FPGA/FPGA_MSO/src/lib/analogue/simulation/iir_df_i_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: iir_df_i
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module iir_df_i_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg [11:0] x;
	reg [31:0] packed_a_coeffs;
	reg [47:0] packed_b_coeffs;

	// Outputs
	wire [11:0] y;

	localparam real freq = 50;
	localparam real scale = 2^q;
	localparam real scale_2 = scale / 2.0;
	localparam real sample_rate = 5.0;
	localparam real sample_rate_2 = sample_rate / 2.0;
	localparam real pi = 3.14159;
	localparam real w = 2.0 * pi * freq / sample_rate;
	//real a0 = sin(w) * scale_2;
	localparam real a1 = 2.0 * $cos(w) * scale;
	localparam real a2 = -scale;
	
	// Instantiate the Unit Under Test (UUT)
	iir_df_i #(
		.M(2),					// 2nd-order
		.INPUT_WIDTH(12),
		.OUTPUT_WIDTH(16),
		.PRECISION(16), 
		.COEFF_WIDTH(16),
		.Q(14))
	uut (
		.rst_n(rst_n), 
		.clk(clk), 
		.x(x), 
		.packed_a_coeffs(packed_a_coeffs), 
		.packed_b_coeffs(packed_b_coeffs), 
		.y(y)
	);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		x = 0;
		packed_a_coeffs = 0;
		packed_b_coeffs = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

