module SPI_Wrapper(SPI_interface.DUT SPI_if);

	// input MOSI, SS_n, clk, rst_n;
	// output MISO;

	logic MOSI, SS_n, clk, rst_n;
	logic MISO;

	assign clk 			= SPI_if.clk;
	assign rst_n 		= SPI_if.rst_n;
	assign MOSI 		= SPI_if.MOSI;
	assign SS_n 		= SPI_if.SS_n;
	assign SPI_if.MISO 	= MISO;

	wire rx_valid, tx_valid;
	wire [9:0] rx_data;
	wire [7:0] tx_data;

	SPI_Slave SLAVE(MOSI, SS_n, clk, rst_n, tx_data, tx_valid, MISO, rx_data, rx_valid);
	Dp_Sync_RAM RAM(clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);

endmodule