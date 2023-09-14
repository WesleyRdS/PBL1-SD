module bidirecional(En, Bdir, dataRx, dataTx);

	input En;
	inout Bdir;
	input dataTx;
	output dataRx;
	
	
	assign Bdir = En? dataTx: 1'bZ;
	assign dataRx = En? 1'bz: Bdir;
	
endmodule 