package SPI_monitor;
	import SPI_seq_item::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_monitor extends uvm_monitor;
		`uvm_component_utils(spi_monitor)
		virtual SPI_interface spi_monitor_vif;
		spi_seq_item rsp_seq_item;
		uvm_analysis_port #(spi_seq_item) mon_ap;

		function new (string name = "spi_monitor", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase (uvm_phase phase);
			super.build_phase(phase);
			mon_ap = new("mon_ap", this);
		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin 
				rsp_seq_item = spi_seq_item::type_id::create("rsp_seq_item");
				@(negedge spi_monitor_vif.clk);
				rsp_seq_item.rst_n 		= spi_monitor_vif.rst_n;
				rsp_seq_item.SS_n 		= spi_monitor_vif.SS_n;
				rsp_seq_item.MOSI 		= spi_monitor_vif.MOSI;
				rsp_seq_item.MISO 		= spi_monitor_vif.MISO;
				mon_ap.write(rsp_seq_item);
				`uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
			end
		endtask : run_phase
	endclass : spi_monitor

endpackage