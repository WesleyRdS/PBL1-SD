module mcu_top(clk, rst, rx, tx, sensor);
	inout sensor;
	input clk, rst, rx, tx;
	
	wire [7:0] end_sensor, command_req;
	wire [7:0] HumI, HumF, TempI, TempF, Par;
	wire [31:0] locator;
	wire en;
	integer Nbits;
	controlePC_FPGA command_unit(.clk(clk), .rst(rst), .Rx(rx), .End(end_sensor), .Req(command_req));
	MDHT11(.Data(sensor), .clk(clk), .rst(rst), .HumI(HumI), .HumF(HumF), .TempI(TempI), .TempF(TempF), .Par(TempF),.enable(en));
	demultiplexSensor circuit_locator(.clk(clk), .End(end_sensor), .y(locator));
	
	
	always @(posedge clk) begin
		if(locator[31] == 1'b1) begin
			case(command_req)
				8'b10000001: begin
					if(Nbits > 0) begin
						Nbits = Nbits - 1;
					end
				end
				8'b10000010: begin
				
				end
				8'b10000011: begin
				
				end
				8'b10000100: begin
				
				end
				8'b10000101: begin
				
				end
				8'b10000110: begin
				
				end
				8'b10000111: begin
				
				end
				8'b10001000: begin
				
				end
			endcase
		end
			
	
	end
	
endmodule
	
	