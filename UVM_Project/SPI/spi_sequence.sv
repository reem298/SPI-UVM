package SPI_sequence;
	import SPI_seq_item::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_reset_sequence extends uvm_sequence #(spi_seq_item);
		`uvm_object_utils(spi_reset_sequence)

		spi_seq_item seq_item;

		function new (string name = "spi_reset_sequence");
			super.new(name);
		endfunction

		task body();
			seq_item = spi_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst_n 		= 0;
			seq_item.SS_n 		= 0;
			seq_item.MOSI		= 0;
			finish_item(seq_item);
		endtask : body
	endclass : spi_reset_sequence

	/**************************************************/

	class spi_main_sequence extends uvm_sequence #(spi_seq_item);
		`uvm_object_utils(spi_main_sequence)

		spi_seq_item seq_item;

		function new (string name = "spi_main_sequence");
			super.new(name);
		endfunction

		task body();
			seq_item = spi_seq_item::type_id::create("seq_item");
			repeat (1000) begin
			start_item(seq_item);
				assert(seq_item.randomize());
			finish_item(seq_item);
			end
		endtask : body
	endclass : spi_main_sequence
endpackage