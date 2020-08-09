`timescale 1ns / 1ps
module clock_divider(in_clk, reset, out_clk);
input wire in_clk;
input wire reset;
output wire out_clk;
reg [1:0]next_state, state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

always @(*)
begin
	case(state)
		S0: next_state = S1;
		S1: next_state = S2;
		S2: next_state = S0;
		default: next_state = S0;
	endcase
end

always @(posedge in_clk, posedge reset)
begin
	if(reset) state <= S0;
	else		 state <= next_state;
end

assign out_clk = (state==S0);

endmodule
