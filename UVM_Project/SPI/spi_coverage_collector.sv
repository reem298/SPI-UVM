package SPI_coverage_collector;
	import SPI_seq_item::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_coverage extends uvm_component;
		`uvm_component_utils(spi_coverage)
		uvm_analysis_export #(spi_seq_item) cov_export;
		uvm_tlm_analysis_fifo #(spi_seq_item) cov_fifo;

		spi_seq_item seq_item_cov;

		covergroup SPI_cg();
		   	reset_cp: coverpoint seq_item_cov.rst_n{
		   		bins rst 	= {0};
		   		bins noRst 	= {1};
		   	}

		   	slaveSel_cp: coverpoint seq_item_cov.SS_n{
		   		bins sel 	= {0};
		   		bins noSel 	= {1};
		   	}

		   	MOSI_cp: coverpoint seq_item_cov.MOSI{
		   		bins MOSI_high = {1};
		   		bins MOSI_low  = {0};
		   	}

		   	MISO_cp: coverpoint seq_item_cov.MISO{
		   		bins MISO_high = {1};
		   		bins MISO_low  = {0};
		   	}

		   	cross reset_cp, slaveSel_cp, MOSI_cp{
		   		ignore_bins crsRst = !binsof(reset_cp.rst); 
		   	}

		   	cross reset_cp, slaveSel_cp, MOSI_cp{
		   		bins crsMOSI = binsof(reset_cp.noRst) && binsof(slaveSel_cp.sel);
		   	}
		endgroup : SPI_cg

		function new (string name = "spi_coverage", uvm_component parent = null);
			super.new(name, parent);
			SPI_cg = new;
		endfunction

		function void build_phase (uvm_phase phase);
		 	super.build_phase(phase);
		 	cov_export = new("cov_export", this);
		 	cov_fifo = new("cov_fifo", this);
		endfunction :  build_phase

		function void connect_phase (uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin 
				cov_fifo.get(seq_item_cov);
				SPI_cg.sample();
			end
		endtask : run_phase
	endclass : spi_coverage
endpackage