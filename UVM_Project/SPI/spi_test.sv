package SPI_test;
	import SPI_seq_item::*;
	import SPI_agent::*;
	import SPI_sequence::*;
	import SPI_env::*;
	import SPI_config_obj::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class spi_test extends uvm_test;
		`uvm_component_utils(spi_test)

		spi_agent agt;
		spi_env env;
		spi_reset_sequence reset_seq;
		spi_main_sequence main_seq;
		spi_config_obj spi_config_obj_test;
		virtual SPI_interface spi_test_vif;

		function new (string name = "spi_test", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase (uvm_phase phase);
			super.build_phase(phase);
			env 				= spi_env::type_id::create("env", this);
			agt 				= spi_agent::type_id::create("agt", this);
			spi_config_obj_test = spi_config_obj::type_id::create("spi_config_obj_test", this);
			main_seq 			= spi_main_sequence::type_id::create("main_seq", this);
			reset_seq 			= spi_reset_sequence::type_id::create("reset_seq", this);

			if(!uvm_config_db#(virtual SPI_interface)::get(this, "", "SPI_INTERFACE", spi_config_obj_test.spi_config_vif))
				`uvm_fatal("build_phase", "TEST - Unable to Get the Virtual Interface from the config_db");

			uvm_config_db#(spi_config_obj)::set(this, "*", "Virtual_IF", spi_config_obj_test);
		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);

			`uvm_info("run_phase", "RESET ASSERTED", UVM_NONE);
			reset_seq.start(env.agt.sqr);
			`uvm_info("run_phase", "RESET DE-ASSERTED", UVM_NONE);

			`uvm_info("run_phase", "Stimulus Gen. Started", UVM_NONE);
			main_seq.start(env.agt.sqr);
			`uvm_info("run_phase", "Stimulus Gen. Ended", UVM_NONE);

			phase.drop_objection(this);
		endtask : run_phase
	
	endclass : spi_test
endpackage