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
	reg [11:0] data_in;

	// Outputs
	wire clk_transfer;
	wire [15:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	cic_decimator uut (
		.rst_n(rst_n), 
		.clk(clk), 
		.enabled(enabled), 
		.data_in(data_in), 
		.clk_transfer(clk_transfer), 
		.data_out(data_out)
	);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		enabled = 0;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst_n = 1;
		
		// Add stimulus here
		enabled = 1;
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
	end
      
	always #5 clk = ~clk;
	
endmodule

