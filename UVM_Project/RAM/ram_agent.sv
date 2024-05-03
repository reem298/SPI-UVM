package RAM_agent;
	import RAM_monitor::*;
	import RAM_sequence::*;
	import RAM_seq_item::*;
	import RAM_sequencer::*;
	import RAM_config_obj::*;
	import RAM_driver::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_agent extends uvm_agent;
		`uvm_component_utils(ram_agent)
		ram_config_obj ram_config_obj_agent;
		ram_driver driver;
		ram_sequencer sqr;
		ram_monitor mon;
		uvm_analysis_port #(ram_seq_item) agt_ap;

		function new (string name = "ram_agent", uvm_component parent = null);
			super.new(name, parent);
		endfunction 

		function void build_phase (uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(ram_config_obj)::get(this, "", "Virtual_IF", ram_config_obj_agent))
				`uvm_fatal("build_phase", "Agent - Unable to Get the Configuration Object")

			sqr 	= ram_sequencer::type_id::create("sqr", this);
			driver 	= ram_driver::type_id::create("driver", this);
			mon 	= ram_monitor::type_id::create("mon", this);
			agt_ap 	= new("agt_ap", this);
		endfunction : build_phase

		function void connect_phase (uvm_phase phase);
			driver.ram_driver_vif 	= ram_config_obj_agent.ram_config_vif;
			mon.ram_monitor_vif 	= ram_config_obj_agent.ram_config_vif;
			driver.seq_item_port.connect(sqr.seq_item_export);
			mon.mon_ap.connect(agt_ap);
		endfunction : connect_phase
	
	endclass : ram_agent

endpackage