import SPI_config_obj::*;
import SPI_test::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module SPI_top();
	bit clk;

	/* Clock Generation */
	initial begin 
		clk = 0;
		forever 
			#1 clk = ~clk;
	end

	SPI_interface SPI_if(clk);
	SPI_Wrapper DUT(SPI_if);

	bind SPI_Wrapper SPI_assertions spi_assert(SPI_if);

	initial begin
		uvm_config_db#(virtual SPI_interface)::set(null, "uvm_test_top", "SPI_INTERFACE", SPI_if); 
		run_test("spi_test");
	end

endmodule : SPI_top 