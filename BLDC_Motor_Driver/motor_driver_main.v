`timescale 1ns / 1ps
module motor_driver_main(
	input [2:0]hall,
	input clk,
	input [4:0]pwm_val,
	output [5:0]mos
    );
wire tmp;
generate_pwm pwm(.in_val(pwm_val[3:0]),.clk(clk),.out_val(tmp));
generate_commutation out(.hall(hall),.sign(pwm_val[4]),.pwm_sig(tmp),.mosfet(mos));
endmodule
