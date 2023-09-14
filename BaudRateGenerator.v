module BaudRateGenerator(clk, reset, Tick, BaudRate);

	input clk, reset;
	input [15:0] BaudRate; // baud rate definida no top level
	output Tick; // saida da frequencia dividida 
	
	reg [15:0] BaudRateCounter; //contador

	initial  begin
		BaudRateCounter <= 16'b1; // inicialização(executa uma vez)
	end
	
	always @(posedge clk or posedge reset) begin // dividindo o numero de clocks por 16
		if(reset) begin
			BaudRateCounter <= 16'b1;
		end
		else begin
			BaudRateCounter = BaudRate ? 16'b1: BaudRateCounter + 1'b1; //verifica se o contador chegou ao valor da baud rate se não soma 1 se sim reseta a contagem
		end
	end
	
	assign Tick = BaudRate == BaudRateCounter; // Passa o valor da saida
	
	
endmodule