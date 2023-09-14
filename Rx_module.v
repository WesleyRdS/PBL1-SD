module Rx_module(clk, Tick, rst,Rx, RxD, Stop_bit, N_bits);

	input clk, rst, Tick, Rx; //respectivamente clock, reset e frequencia 16 vezes o valor da baud rate
	input [3:0] N_bits; // Conta de 8 em 8 para identificar o inicio do start bit;
	output Stop_bit; // sinal de saida para indicar que a leitura foi concluida;
	output reg [7:0] RxD; // saida do Rx data

	
	//estados
	reg [1:0] state, next_state;
	
	//parametros
	parameter [1:0] idle = 1'b0, receving = 1'b1;
	
	//registradores
	reg [4:0] bits = 5'b00000; // numero de bits para contar o loop de 8 em 8 
	reg [1:0] Start_bit = 1'b1;
	reg [1:0] Stop_bit = 1'b0; 
	reg [1:0] read_enable = 1'b0; //liberação de leitura
	reg [3:0] counter = 4'b0000; // contador de 4 bits		
	reg [7:0] Read_data= 8'b00000000; // dados de 8 bits
	reg [3:0] check = 4'b1000;
	
	always @(posedge clk) begin
		if(rst) state <= idle;
		else state <= next_state;
	end
	
	always @(*) begin
		case(state)
			idle: begin
				if(Rx & ~Start_bit) begin
					next_state <= receving; // vai para o estado de recebimento se tiver 
					read_enable <= 1'b1;
				end
				else begin
					next_state <= idle; // se não permanece na espera
					read_enable <= 1'b0;
				end
			end
			receving: begin
				if(Stop_bit) begin
					next_state <= idle; // detectou o stop bit volta para o estado de espera
					read_enable <= 1'b0;
				end
				else begin
					next_state <= receving; // se não continua no mesmo estado
					read_enable <= 1'b1;
				end
			end
		endcase
	end
	
	
	always @(posedge Tick)begin
		if(read_enable) begin // leitura aberta
			Stop_bit <= 1'b0;
			counter <= counter + 1; // contando de "Tick" que é 16 vezes mais rapidos que a baud rate
		
			if((counter == 4'b1000) & (Start_bit)) begin // ao chegar em oito ele vai ta exatamente no meio do start bit
				Start_bit = 1'b0; // manda o sinal para zero para liberar o recebimento
				counter <= 4'b0000; // contador zerado
			end
			
			if((counter == 4'b1111) & (~Start_bit) & bits < N_bits) begin // conta mais 16 para pegar exatamente o meio do sinal do proximo bit de dado, assim como verifica se o start bit foi recebido e se o numero de bits lidos ainda é menor que 8
				bits <= bits + 1; // incrementa o numero de bits lidos
				Read_data <= {Rx,Read_data[7:1]}; //pega o valor de rx e concatea com o valor de read data deslocado uma posição para a direita
				counter <= 4'b0000; // zera o valor do contador
			end
			if((counter == 4'b1111) & (bits == N_bits) & (Rx)) begin // Depois de 16 "Ticks" se o numero de bits lidos for 8 e o sinal de Rx ta em alto
				counter <= 4'b0000; //zera o contador
				Start_bit <= 1'b1; // manda o stop bit para nivel logico alto para esperar a proxima leitura
				Stop_bit <= 1'b1; //aciona o stop bit indicando que terminou
				bits <= 5'b00000; // zera o numero bits lidos
			end
		end
	end
	
	
	always @(posedge clk) begin
		if(N_bits == 4'b1000) begin // verificando se o numero de bits é exatamente 8
			RxD[7:0] = Read_data[7:0]; //repaça os dados
		end
		else begin
			RxD[7:0] = (check-N_bits) >> Read_data;
			
		end

	end
	
endmodule 
	
