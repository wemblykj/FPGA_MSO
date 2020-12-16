`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 1
// 
// Create Date:    14:55:50 12/13/2020 
// Design Name: 
// Module Name:    decimator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module decimator
	#(
		// precision
		parameter X_WIDTH = 12,				// sensible default for a 12-bit ADC
		parameter Y_WIDTH = 16,				// sensible default for a 16-bit sample
		parameter PRECISION = Y_WIDTH		// sensible default for accumulating 12-bit input data
													// when using a multistage CIC pipeline
	)
	(
		input [X_WIDTH-1:0] x,
		output [Y_WIDTH-1:0] y
	);
	
	wire substage_clk;
	
    cic_decimator
		#(
			.M(1),
			.D(5),
			.R(1),
			.X_WIDTH(X_WIDTH),	// test input trimming
			.Y_WIDTH(Y_WIDTH), // test ouput padding
			.PRECISION(PRECISION)		// test reduced precision processing
		)
		uut
		(
			.rst_n(rst_n), 
			.clk(clk), 
			.enabled(1), 
			.x(x), 
			.clk_transfer(substage_clk), 
			.y(y)
		);
	
	/*fir
		#()
		compensator
		(
			.rst_n(rst_n), 
			.clk(substage_clk),
		)*/
endmodule
