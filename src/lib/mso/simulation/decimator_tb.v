`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:42:43 12/16/2020
// Design Name:   decimator
// Module Name:   C:/Users/paulw/Development/FPGA/FPGA_MSO/src/lib/mso/simulation/deimator_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: decimator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module decimator_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg [7:0] data_in;

	// Outputs
	wire [7:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	decimator 
		#(
			.X_WIDTH(8),	// test input trimming
			.Y_WIDTH(12), 	// test ouput padding
			.PRECISION(16)		// test reduced precision processing
		)
		uut (
			.rst_n(rst_n),
			.clk(clk),
			.x(data_in), 
			.y(data_out)
		);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst_n = 1;
        
		// Add stimulus here
		data_in = 1;  #40;
      data_in = 0; #10;
		/*data_in = 0;  #40;
      data_in = -3; #10;
      data_in = 1;  #10;
      data_in = 0;  #10;
      data_in = -2; #10;
      data_in = -1; #10;
      data_in = 4;  #10;
      data_in = -5; #10;
      data_in = 6;  #10;
      data_in = 0;  #10;*/
		
		$finish;
	end
      
	always #5 clk = ~clk;
      
endmodule

