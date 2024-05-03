interface RAM_interface (
	input bit clk
	);

	parameter MEM_DEPTH = 256;
	parameter ADDR_SIZE = 8;

	logic rst_n, rx_valid, tx_valid;
	logic [9:0] din;
	logic [7:0] dout;

	modport TEST (input dout, tx_valid, clk,
				  output rx_valid, din, rst_n);
	modport DUT (input din, rx_valid, rst_n, clk,
				 output dout, tx_valid);
	modport MONITOR (input din, rx_valid, rst_n, clk, dout, tx_valid);
	
endinterface : RAM_interface