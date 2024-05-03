interface SPI_interface (
	input bit clk
	);

	logic MOSI, SS_n, rst_n;
	logic MISO;

	modport TEST 	(input MISO, clk,
				 	 output MOSI, SS_n, rst_n);
	modport DUT 	(input MOSI, SS_n, rst_n, clk,
				 	 output MISO);
	modport MONITOR (input MOSI, SS_n, rst_n, clk, MISO);
	
endinterface : SPI_interface