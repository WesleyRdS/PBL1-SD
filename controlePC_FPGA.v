module controlePC_FPGA(clk, rst, Rx, End, Req);
	input clk, rst, Rx;
	output reg [7:0] End, Req;

	
	//fios
	wire [3:0] N_bits;
	wire [15:0] baud_rate;
	wire tick, rx_stop; //sinal de saida do baud rate generator e stop bit do modulo rx
	wire [7:0] RxData; // saida do modulo rx
	//registradores
	reg [3:0] state, next_state;
	reg [7:0] tempE = 8'b00000000;
	reg [7:0] tempR = 8'b00000000; //variavel temporaria pra guardar os dados
	//parametros
	parameter [3:0] idle = 3'b000,
				 header = 3'b001,
				 adress = 3'b010,
				 data = 3'b011,	
				 baseboard = 3'b100;
	
	//atribuição de valores
	assign baud_rate = 3'd325; // valor da 1/baud rate x16 em decimal 
	assign N_bits = 4'b1000; // Numero de bits para o contador de dados do gerador de baud rate
	
	//chamadas
	BaudRateGenerator(.clk(clk), .reset(rst), .Tick(tick), .BaudRate(baud_rate));
	Rx_module(.clk(clk), .Tick(tick), .rst(rst), .Rx(Rx), .RxD(RxData), .Stop_bit(rx_stop), .N_bits(N_bits));
	
	always @(posedge clk) begin
		if(rst) state <= idle;
		else state <= next_state;
	end
	
	always @* begin
		case(state)
			idle: begin //estado ocioso
				if(RxData == 8'b11111111) begin // Recebendo codigo referente ao cabeçalho
					next_state <= header; // muda para o estado de cabeçalho
				end
				else begin
					next_state <= idle; //se não permanece no mesmo estado
				end
			end
			header: begin // cabeçalho
				if((RxData >= 8'b00000001) & (RxData <= 8'b00100000)) begin //Checa se o valor recebido ta no intervalo dos codigos do protocolo
					next_state <= adress; // se sim vai para o estado de recebimento de endereços
				end
				else if(RxData == 8'b11111111) begin
					next_state <= header;
				end
				else begin
					next_state <= idle;
				end
			end
			adress: begin //endereço
				if((RxData >= 8'b10000001) & (RxData <= 8'b10001000)) begin // verifica se os dados é alguma das requisições disponiveis
					next_state <= data; //muda para o estado de dados
				end
				else if((RxData >= 8'b00000001) & (RxData <= 8'b00100000)) begin
					tempE = RxData;
					next_state <= adress;
				end
				else begin
					next_state <= idle;
				end
			end
			data: begin //dados
				if(RxData == 8'b01111111) begin //verifica se ja acabou de receber os dados
					next_state <= baseboard; // se sim, significa que o codigo do cabeçalho é o proximo e o mandam para o estado do mesmo
				end
				else if((RxData >= 8'b10000001) & (RxData <= 8'b10001000)) begin
					tempR = RxData;
					next_state <= data;
				end
				else begin
					next_state <= idle;
				end
			end
			baseboard: begin
				if(RxData == 8'b01111111) begin
					next_state <= baseboard;
				end
				else begin
					tempR <= 8'b00000000;
					tempE <= 8'b00000000;
					next_state <= idle;
				end
			end
			default: begin
				next_state <= idle;
			end
		endcase
	end
	
	always @(posedge clk) begin
		case(state)
			baseboard: begin
				Req <= tempR;
				End <= tempE;
			end
			default: begin
				Req <= 8'b00000000;
				End <= 8'b00000000;
			end
		endcase
	end
endmodule