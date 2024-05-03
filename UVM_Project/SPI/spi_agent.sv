package SPI_agent;
	import SPI_monitor::*;
	import SPI_seq_item::*;
	import SPI_sequencer::*;
	import SPI_config_obj::*;
	import SPI_driver::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_agent extends uvm_agent;
		`uvm_component_utils(spi_agent)
		spi_config_obj spi_config_obj_agent;
		spi_driver driver;
		spi_sequencer sqr;
		spi_monitor mon;
		uvm_analysis_port #(spi_seq_item) agt_ap;

		function new (string name = "spi_agent", uvm_component parent = null);
			super.new(name, parent);
		endfunction 

		function void build_phase (uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(spi_config_obj)::get(this, "", "Virtual_IF", spi_config_obj_agent))
				`uvm_fatal("build_phase", "Agent - Unable to Get the Configuration Object")

			sqr 	= spi_sequencer::type_id::create("sqr", this);
			driver 	= spi_driver::type_id::create("driver", this);
			mon 	= spi_monitor::type_id::create("mon", this);
			agt_ap 	= new("agt_ap", this);
		endfunction : build_phase

		function void connect_phase (uvm_phase phase);
			driver.spi_driver_vif 	= spi_config_obj_agent.spi_config_vif;
			mon.spi_monitor_vif 	= spi_config_obj_agent.spi_config_vif;
			driver.seq_item_port.connect(sqr.seq_item_export);
			mon.mon_ap.connect(agt_ap);
		endfunction : connect_phase
	endclass : spi_agent
endpackage