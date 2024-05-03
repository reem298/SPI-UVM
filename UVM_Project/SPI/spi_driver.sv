package SPI_driver;
	import SPI_seq_item::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_driver extends uvm_driver #(spi_seq_item);
		`uvm_component_utils(spi_driver)

		virtual SPI_interface spi_driver_vif;
		spi_seq_item stim_seq_item;
		
		function new (string name = "spi_driver", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);	
			forever begin 
				stim_seq_item = spi_seq_item::type_id::create("stim_seq_item");
				seq_item_port.get_next_item(stim_seq_item);
				spi_driver_vif.rst_n = stim_seq_item.rst_n;
				spi_driver_vif.SS_n = stim_seq_item.SS_n; 	
				spi_driver_vif.MOSI = stim_seq_item.MOSI; 	
				@(negedge spi_driver_vif.clk);
				seq_item_port.item_done();
				`uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH)
			end
		endtask : run_phase
	endclass : spi_driver
endpackage