module MDHT11(Data, clk, rst,HumI, HumF, TempI, TempF, Par, enable);
	inout Data;
	input clk, rst, enable;
	output [7:0] HumI, HumF, TempI, TempF, Par;
	
	reg [39:0] DataRead;
	reg [2:0] state;
<<<<<<< HEAD
	reg dht11_temp;
	reg low_signal;
	reg high_signal;
	reg clear;
	
	wire rising_edge, falling_edge;
	
	reg [13:0] count;
	reg [6:0] Nbits;

	parameter  [2:0] idle = 3'd0, start_bit = 3'd1, responseWait = 3'd2, responseReceived = 3'd3, up_signal = 3'd4, bitCheckout = 3'd5, dataStart = 3'd6, dataReceived = 3'd7;
	
	assign Data = dht11_temp;
	assign rising_edge = ~high_signal & low_signal;
	assign falling_edge = ~low_signal & high_signal;
	assign HumI[7:0] = DataRead[7:0];
	assign HumF[7:0] = DataRead[15:8];
	assign TempI[7:0] = DataRead[23:16];
	assign TempF[7:0] = DataRead[31:24];
	assign Par[7:0] = DataRead[39:32];
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			high_signal <= 1'bz;
			low_signal <= 1'bz;
		end
		else begin
			high_signal <= low_signal;
			low_signal <= dht11_temp;
		end
	end
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			count = 0;
		end
		else if(clear)begin 
			count = 0;
		end
		else begin
			count = count + 1;
		end
	end
=======
	reg dir;
	
	integer count18ms, count80usw, count80us, count20_to_40us, count50us, count0, count1, Nbits;
	
	

	parameter reg [2:0] idle = 3'b000, check = 3'b001, start_bit = 3'b010, responseWait = 3'b011, responseReceived = 3'b100, bitCheckout = 3'b101, dataStart = 3'b110, dataReceived = 3'b111;
	
	reg send1;
	wire read;

	
	bidirecional tristate(.En(dir), .Bdir(Data), .dataRx(read), .dataTx(send1));
>>>>>>> ed6e09f8afa79c79d1706bf5e317b7eb4c2af8a9
	
	always @(posedge clk) begin
		case(state)
			idle: begin // estado inativo
				if(enable) begin // se estiver pronto para leitura
<<<<<<< HEAD
					state <= start_bit; //va para o estado e checagem
					dht11_temp <= 1'b0;
=======
					dir <= 0; // mude a porta o DHT11 para modo de recebimento
					state <= check; //va para o estado e checagem
				end
				else begin
					state <= idle;
				end
			end
			check: begin
				if(read) begin
					dir <= 1;
					send1 <= 0;
					state <= start_bit;
>>>>>>> ed6e09f8afa79c79d1706bf5e317b7eb4c2af8a9
				end
				else begin
					state <= idle;
				end
			end
			start_bit: begin
<<<<<<< HEAD
				if(count < 9100) begin
					clear = 1'b0;
					dht11_temp = 1'b0;
					state <= start_bit;
				end
				else begin
					clear = 1'b1;
					state <= responseWait;
				end
			end
			responseWait: begin
				if(rising_edge) begin
					clear = 1'b0;
					state <= responseWait;
				end
				else begin
					if((count > 1000) & (count < 2000)) begin
						clear = 1'b1;
						state <= responseReceived;
					end
					else begin
						state <= responseWait; 
					end
				end
			end
			responseReceived: begin
				if(falling_edge) begin
					clear = 1'b0;
					state <= responseReceived;
				end
				else begin
					if(count > 4000) begin
						clear = 1'b1;
						state <= up_signal;
					end
					else begin
						state <= responseReceived;
					end
				end
			end
			up_signal: begin
				if(rising_edge) begin
					clear = 1'b0;
					state <= up_signal;
				end
				else begin
					if(count > 4000) begin
						clear = 1'b1;
						state <= bitCheckout;
					end
					else begin
						state <= up_signal;
					end
				end
			end
			bitCheckout: begin
				if(Nbits > 40) begin
					clear = 1'b1;
					Nbits = Nbits + 1;
					state <= dataStart;
				end
				else begin
					clear = 1'b1;
					Nbits = 0;
					state <= idle;
				end
			end
			dataStart: begin
				if(falling_edge) begin
					clear = 1'b0;
					 
					state <= dataStart;
				end
				else begin
					if(count > 2500) begin
						clear = 1'b1;
						state <= dataReceived;
					end
					else begin
						state <= dataStart;
					end
				end
			end
			dataReceived: begin
				if(rising_edge) begin
					clear = 1'b0;
					
					state <= dataReceived;
				end
				else begin
					if((count >= 1300) & (count < 1400)) begin
						clear = 1'b1;
						DataRead = {1'b0,DataRead[39:1]};
						state <= bitCheckout;
					end
					if(count == 3500) begin
						clear = 1'b1;
						DataRead = {1'b1,DataRead[39:1]};
						state <= bitCheckout;
					end
					else begin
						clear = 1'b1;
						state <= bitCheckout;
					end
				end
=======
				if(count18ms < 9000) begin
					state <= responseWait;
				end
				else begin
					count18ms = count18ms + 1;
				end
			end
			responseWait: begin
		
>>>>>>> ed6e09f8afa79c79d1706bf5e317b7eb4c2af8a9
			end
		endcase  
	end
	
endmodule