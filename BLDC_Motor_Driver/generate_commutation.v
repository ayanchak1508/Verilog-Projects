`timescale 1ns / 1ps
module generate_commutation(
	input [2:0]hall,
	input sign,
	input pwm_sig,
	output [5:0]mosfet
    );

assign mosfet[0] = (sign==1)?~(pwm_sig&(hall[0]&(~hall[1]))):(pwm_sig&(hall[0]&(~hall[1])));
assign mosfet[1] = (sign==1)?(hall[1]&(~hall[0])):~(hall[1]&(~hall[0]));
assign mosfet[2] = (sign==1)?~(pwm_sig&(hall[1]&(~hall[2]))):(pwm_sig&(hall[1]&(~hall[2])));
assign mosfet[3] = (sign==1)?(hall[2]&(~hall[1])):~(hall[2]&(~hall[1]));
assign mosfet[4] = (sign==1)?~(pwm_sig&(hall[2]&(~hall[0]))):(pwm_sig&(hall[2]&(~hall[0])));
assign mosfet[5] = (sign==1)?(hall[0]&(~hall[2])):~(hall[0]&(~hall[2]));
endmodule
