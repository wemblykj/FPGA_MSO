`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:51:34 12/17/2020
// Design Name:   trigger_hub
// Module Name:   /home/administrator/Development/fpga/FPGA_MSO/src/lib/mso/simulation/trigger_hub_tb.v
// Project Name:  mso
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: trigger_hub
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module trigger_hub_tb;

	// Inputs
	reg rst_n;
	reg clk;
	reg arm;
	reg reset;
	reg triggers;
	wire [1:0] trigger_state;

	// Instantiate the Unit Under Test (UUT)
	trigger_hub uut (
		.rst_n(rst_n), 
		.clk(clk), 
		.arm(arm), 
		.reset(reset), 
		.triggers(triggers),
		.mask(1'b1),
		.trigger_state(trigger_state)
	);

	initial begin
		// Initialize Inputs
		rst_n = 0;
		clk = 0;
		arm = 0;
		reset = 0;
		triggers = 0;

		// Wait 100 ns for global reset to finish
		#100;
      rst_n = 1;
		  
		// Add stimulus here
		
		arm = 1; # 10;				// arm - state = armed
		arm = 0; # 10;				// suppress request - state = armed
		
		reset = 1; # 10;			// disarm - state = disarmed
		reset = 0; # 10;			// suppress request
		
		triggers = 1; # 20;		// trigger when disarmed - state = disarmed
		triggers = 0; # 10;		// suppress request
		
		$stop;
		
		arm = 1; # 10;				// arm - state = armed
										// keep arm request high
		
		reset = 1; # 10;			// reset with arm request - state = armed
		reset = 0; # 10;			// suppress request
		
		triggers = 1; # 20;		// trigger when armed - state = triggered
		
		$stop;
				
		triggers = 0; # 20;		// trigger disengaged when triggered - state = cleared
		
		triggers = 1; # 20;		// trigger when cleared - state = cleared
		
		reset = 1; # 10;			// reset with arm request - state = disarmed
		reset = 0; # 10;			// suppress request
		
		$finish;
	end
     
	always #5 clk = ~clk;
	
	
endmodule

