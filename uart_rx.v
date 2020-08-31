`timescale 1ns / 1ps
module uart_rx(input clk,
	input data_line,
	output flag,
	output [7:0]data_byte
    );

parameter CLKS_PER_BIT = 3'b111;
parameter S_IDLE = 3'b000;
parameter S_START = 3'b001;
parameter S_DATA = 3'b010;
parameter S_PARITY = 3'b011;
parameter S_STOP = 3'b100;
parameter S_CLEANUP = 3'b101;

reg [2:0]current_state = 3'b000;
reg current_data;
reg current_data_temp;
reg [3:0]clk_counter = 4'b0000;
reg [2:0]bit_index = 3'b000;
reg [7:0]data = 8'b00000000;
reg parity_bit = 1'b0;
reg parity_flag = 1'b0;

always@(posedge clk)
begin
	current_data_temp <= data_line;
	current_data <= current_data_temp;
end

always@(posedge clk)
begin
	case(current_state)
		S_IDLE:
			begin
				if(current_data == 0)
				begin
					current_state <= S_START;
					clk_counter <= 0;
					bit_index <= 0;
					parity_bit <= 0;
					parity_flag <= 0;
				end
				else
					current_state <= S_IDLE;
			end
		
		S_START:
			begin
				if (clk_counter == (CLKS_PER_BIT>>1))
				begin
					if (current_data == 0)
					begin
						current_state <= S_DATA;
						clk_counter <= 0;
					end
					else
						current_state <= S_IDLE;
				end
				else
				begin
					clk_counter <= clk_counter + 1;
					current_state <= S_START;
				end
			end
		
		S_DATA:
			begin
				if (clk_counter == CLKS_PER_BIT)
				begin
					clk_counter <= 0;
					data[bit_index] <= current_data;
					if (bit_index == 7)
					begin
						current_state <= S_PARITY;
						bit_index <= 0;
					end
					else
					begin
						//if (bit_index == 0)
							//parity_bit <= current_data;
						parity_bit <= parity_bit^current_data;
						bit_index <= bit_index + 1;
						current_state <= S_DATA;
					end
				end
				else
				begin
					clk_counter <= clk_counter + 1;
					current_state <= S_DATA;
				end
			end
		
		S_PARITY:
			begin
				if (clk_counter == CLKS_PER_BIT)
				begin
					clk_counter <= 0;
					current_state <= S_STOP;
					/*if (parity_bit == current_data)
						parity_flag <= 1'b1;
					else
						parity_flag <= 1'b0;*/
					if(parity_bit^current_data == 1'b1)
						parity_flag <= 1'b1;
					else
						parity_flag <= 1'b0;
				end
				else
				begin
					clk_counter <= clk_counter + 1;
					current_state <= S_PARITY;
				end
			end
		
		S_STOP:
			begin
				if (clk_counter == CLKS_PER_BIT)
				begin
					clk_counter <= 0;
					current_state <= S_CLEANUP;
				end
				else
				begin
					clk_counter <= clk_counter + 1;
					current_state <= S_STOP;
				end
			end
			
		S_CLEANUP:
			begin
				if (clk_counter == (CLKS_PER_BIT>>1))
				begin
					clk_counter <= 0;
					current_state <= S_IDLE;
					data <= 8'b00000000;
					parity_bit <= 0;
					parity_flag <= 0;
				end
				else
				begin
					clk_counter <= clk_counter + 1;
					current_state <= S_CLEANUP;
				end
			end
			
		default:
			begin
				current_state <= S_IDLE;
			end
	endcase
end

assign data_byte = data;
assign flag = parity_flag;

endmodule
