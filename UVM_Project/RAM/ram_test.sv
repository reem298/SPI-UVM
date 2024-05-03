package RAM_test;
	import RAM_agent::*;
	import RAM_seq_item::*;
	import RAM_sequence::*;
	import RAM_config_obj::*;
	import RAM_env::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_test extends uvm_test;
		`uvm_component_utils(ram_test)

		ram_config_obj ram_config_obj_test;
		ram_env env;
		ram_agent agt;
		ram_reset_sequence reset_seq;
		ram_write_sequence write_seq;
		ram_read_sequence read_seq;
		ram_read_write_sequence read_write_seq;
		virtual RAM_interface ram_test_vif;


		function new (string name = "ram_test", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase (uvm_phase phase);
			super.build_phase(phase);
			env = ram_env::type_id::create("env", this);
			agt = ram_agent::type_id::create("agt", this);
			ram_config_obj_test = ram_config_obj::type_id::create("ram_config_obj_test", this);
			write_seq 			= ram_main_sequence::type_id::create("write_seq", this);
			read_seq 			= ram_main_sequence::type_id::create("read_seq", this);
			reset_seq 			= ram_reset_sequence::type_id::create("reset_seq", this);
			read_write_seq 		= ram_read_write_sequence::type_id::create("read_write_seq", this);

			if(!uvm_config_db#(virtual RAM_interface)::get(this, "", "RAM_INTERFACE", ram_config_obj_test.ram_config_vif))
				`uvm_fatal("build_phase", "TEST - Unable to Get the Virtual Interface from the config_db");

			uvm_config_db#(ram_config_obj)::set(this, "*", "Virtual_IF", ram_config_obj_test);
		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);

			`uvm_info("run_phase", "RESET ASSERTED", UVM_NONE);
			reset_seq.start(env.agt.sqr);
			`uvm_info("run_phase", "RESET DE-ASSERTED", UVM_NONE);

			`uvm_info("run_phase", "Stimulus Gen. Started --> Write", UVM_NONE);
			write_seq.start(env.agt.sqr);
			`uvm_info("run_phase", "Stimulus Gen. Ended (Write)", UVM_NONE);

			`uvm_info("run_phase", "Stimulus Gen. Started --> Read", UVM_NONE);
			read_seq.start(env.agt.sqr);
			`uvm_info("run_phase", "Stimulus Gen. Ended (Read)", UVM_NONE);

			`uvm_info("run_phase", "Stimulus Gen. Started --> Read-Write", UVM_NONE);
			read_write_seq.start(env.agt.sqr);
			`uvm_info("run_phase", "Stimulus Gen. Ended (Read-Write)", UVM_NONE);

			phase.drop_objection(this);
		endtask : run_phase
	
	endclass : ram_test
endpackage