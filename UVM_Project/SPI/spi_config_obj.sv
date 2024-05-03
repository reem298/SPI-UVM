package SPI_config_obj;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_config_obj extends uvm_object;
		`uvm_object_utils(spi_config_obj)

		virtual SPI_interface spi_config_vif;

		function new (string name = "spi_config_obj");
			super.new(name);
		endfunction
	endclass : spi_config_obj
endpackage