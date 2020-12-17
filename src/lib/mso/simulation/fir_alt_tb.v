`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:08:17 12/13/2020
// Design Name:   fir
// Module Name:   C:/Users/paulw/Development/FPGA/FPGA_MSO/src/lib/mso/simulation/fir_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fir
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fir_alt_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg [15:0] data_in;
	wire [15:0] data_out;
	reg [31:0] packed_coeffs;

	// Instantiate the Unit Under Test (UUT)
	fir_alt
	# (.DATA_WIDTH(16),
		.COEFF_WIDTH(8),
		.NUM_TAPS(4))
		uut 
	(
		.rst_n(rst_n),
		.clk(clk), 
		.data_in(data_in), 
		.data_out(data_out), 
		.packed_coeffs(packed_coeffs)
	);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		data_in = 0;
		packed_coeffs = { 8'd4, 8'd3, -8'd1, -8'd2 };
		
		// Wait 100 ns for global reset to finish
		#20;
      rst_n = 1;
		  
		// Add stimulus here
		data_in = 0;  #40;
      data_in = -3; #10;
      data_in = 1;  #10;
      data_in = 0;  #10;
      data_in = -2; #10;
      data_in = -1; #10;
      data_in = 4;  #10;
      data_in = -5; #10;
      data_in = 6;  #10;
      data_in = 0;  #10;
		
		$finish;
	end
      
	always #5 clk = ~clk;
	
endmodule

