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
	
	// Outputs
	wire [11:0] y;
	
	localparam integer cw = 16;
	localparam integer q = 14;
	localparam integer scale = 2**q;
	
	localparam [cw-1:0] b0 = 1 * scale;
	localparam [cw-1:0] b1 = 0.0 * scale;
	localparam [cw-1:0] b2 = -1.0 * scale;
	localparam [cw-1:0] a1_n = 0.0 * scale;
	localparam [cw-1:0] a2_n = -0.50952544994652271 * scale;
	
	// Instantiate the Unit Under Test (UUT)
	iir_df_i #(
		.M(2),					// 2nd-order
		.INPUT_WIDTH(12),
		.OUTPUT_WIDTH(16),
		.PRECISION(16), 
		.COEFF_WIDTH(cw),
		.Q(q))
	uut (
		.rst_n(rst_n), 
		.clk(clk), 
		.x(x), 
		.packed_a_coeffs( { a2_n, a1_n } ), 
		.packed_b_coeffs( { b2, b1, b0 } ), 
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
		x = 1; #10;
		x = 0; #100;
		
		$finish;
	end
   
	always #5 clk = ~clk;
      
endmodule

