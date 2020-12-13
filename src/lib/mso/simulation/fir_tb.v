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

module fir_tb;

	// Inputs
	reg clk;
	reg [11:0] data_in;
	wire [11:0] data_out;
	reg [23:0] coeff;

	// Instantiate the Unit Under Test (UUT)
	fir 
	# (.DATA_WIDTH(16),
		.COEFF_WIDTH(7),
		.NUM_TAPS(4))
		uut 
	(
		.clk(src_clk), 
		.data_in(data_in), 
		.data_out(data_out), 
		.coeff(coeff)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		data_in = 0;
		coeff = { 4, 3, -1, -2 };
		
		// Wait 100 ns for global reset to finish
		#100;
        
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
	end
      
	always #5 clk = ~clk;
	
endmodule

