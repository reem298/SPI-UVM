package SPI_seq_item;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_seq_item extends uvm_sequence_item;
		`uvm_object_utils(spi_seq_item)

		rand bit rst_n, SS_n;
		rand bit MOSI;
		bit MISO;

		function new (string name = "spi_seq_item");
			super.new(name);
		endfunction

		function string convert2string();
			return $sformatf("%s Reset = 0b%0b, Slave Select = 0b%0b, MOSI = 0b%0b"
							 , super.convert2string, rst_n, SS_n, MOSI);
		endfunction : convert2string

		function string convert2string_stimulus();
			return $sformatf("Reset = 0b%0b, Slave Select = 0b%0b, MOSI = 0b%0b"
							 , rst_n, SS_n, MOSI);
		endfunction : convert2string_stimulus
	
	endclass : spi_seq_item
endpackage