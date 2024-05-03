module SPI_assertions(SPI_interface.DUT SPI_if);

	logic MOSI, SS_n, clk, rst_n;
	logic MISO;

	assign clk 			= SPI_if.clk;
	assign rst_n 		= SPI_if.rst_n;
	assign MOSI 		= SPI_if.MOSI;
	assign SS_n 		= SPI_if.SS_n;
	assign MISO 		= SPI_if.MISO;

	property rstTest;
		@(posedge clk) 
		!(rst_n) |=> !MISO
	endproperty

	assert property(rstTest);

	case_RESET:	 	cover property(rstTest);

endmodule : SPI_assertions