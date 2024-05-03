module RAM_assertions(RAM_interface.DUT ramIF);

	logic clk, rst_n, rx_valid, tx_valid;
	logic [9:0] din;
	logic [7:0] dout;

	assign clk 				= ramIF.clk;
	assign rst_n 			= ramIF.rst_n;
	assign rx_valid 		= ramIF.rx_valid;
	assign din 				= ramIF.din;
	assign dout 			= ramIF.dout;
	assign tx_valid 		= ramIF.tx_valid;

	property rstTest;
		@(posedge clk) 
		!(rst_n) |-> !dout
	endproperty

	assert property(rstTest);

	case_RESET:	 	cover property(rstTest);

endmodule : RAM_assertions