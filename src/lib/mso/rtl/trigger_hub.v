`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:       Paul Wightmore
// 
// Create Date:    13:14:40 12/17/2020 
// Design Name:    trigger_hub
// Module Name:    trigger_hub.v 
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
// License:        https://www.apache.org/licenses/LICENSE-2.0
//////////////////////////////////////////////////////////////////////////////////
module trigger_hub
	#(
		parameter NUM_TRIGGER_LINES = 1
	)
	(
		input rst_n,
		input clk,
		input arm,
		input reset,
		input [NUM_TRIGGER_LINES-1:0] triggers,
		input [NUM_TRIGGER_LINES-1:0] mask,
		output [1:0] trigger_state
    );

	localparam 
		State_Disarmed = 2'd0,
		State_Armed = 2'd1,
		State_Triggered = 2'd2,
		State_Cleared = 2'd3;
		
	reg[1:0] State_reg, State_next;
	
	assign trigger_state = State_reg;
	
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			State_reg <= State_Disarmed;
		end else begin
			State_reg <= State_next;
		end
	end

	// Moore Design 
	always @(State_reg, triggers, posedge arm, posedge reset)
	begin
		 // store current state as next
		 State_next = State_reg; // required: when no case statement is satisfied
		 
		 case(State_reg)
			  State_Disarmed: 
					if(arm)
						State_next = State_Armed;
						
			  State_Armed: 
					begin
						if(reset)
							State_next = State_Disarmed;
						else if ((triggers & mask) !== 0)
							State_next = State_Triggered;
					end

			  State_Triggered:
					begin
						if(reset)
							State_next = State_Disarmed;
						else if ((triggers & mask) === 0)
							State_next = State_Cleared;
					end
					
			  State_Cleared: 
					if(reset)
							State_next = State_Disarmed;
		 endcase
	end
endmodule
