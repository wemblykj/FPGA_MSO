`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    12:23:08 12/17/2020 
// Design Name:    mso
// Module Name:    msos.v 
// Project Name:   FPGA Mixed Signal Oscilloscope
// Target Devices: 
// Tool versions: 
// Description: 	MSO top module.
//
//						A from scratch implementation of an MSO oscillosope
//						(and signal generator)
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// License:        https://www.apache.org/licenses/LICENSE-2.0
//////////////////////////////////////////////////////////////////////////////////
module mso(
		wire rst_n,
		wire clk,
		wire external_trigger
    );

	wire acquire;
	wire analogue_trigger;
	wire logic_trigger;
	
	analogue_signal_acquisition 
		analogue_signal_acquisition (
			.rst_n(rst_n),
			.clk(clk),
			.acquire(acquire),
			.trigger(analogue_trigger) );
	
	analogue_signal_generation
		analogue_signal_generation (
			.rst_n(rst_n),
			.clk(clk) );
	
	digital_signal_acquisition 
		digital_signal_acquisition (
			.rst_n(rst_n),
			.clk(clk),
			.acquire(acquire),
			.trigger(logic_trigger) );
			
	digital_signal_generation
		digital_signal_generation (
			.rst_n(rst_n),
			.clk(clk) );
			
	digital_signal_generation
		digital_signal_generation (
			.rst_n(rst_n),
			.clk(clk) );	
			
	trigger_hub
		trigger_hub (
			.rst_n(rst_n),
			.clk(clk),
			.triggers( { external_trigger, logic_trigger, analogue_trigger } ),
			.mask(3'b1),
			.state(trigger_state) );
			
endmodule
