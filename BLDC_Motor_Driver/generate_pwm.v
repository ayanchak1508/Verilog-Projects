`timescale 1ns / 1ps
module generate_pwm(
	input [3:0]in_val,
	input clk,
	output out_val
    );
reg [3:0]val = 0;
reg [3:0]counter = 0;
reg flag = 1;
always @(posedge clk)
begin
	val = in_val;
	if(counter+4'b0001==4'b0000)
		counter = 0;
	flag = (counter<val)?1'b1:1'b0;
	counter = counter + 4'b0001;
end
assign out_val = (flag)?1'b1:1'b0;
endmodule
