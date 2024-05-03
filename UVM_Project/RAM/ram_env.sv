package RAM_env;
	import RAM_scoreboard::*;
	import RAM_coverage_collector::*;
	import RAM_agent::*;
	import RAM_sequence::*;
	import RAM_seq_item::*;
	import RAM_sequencer::*;
	import RAM_config_obj::*;
	import RAM_driver::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

		class ram_env extends uvm_env;
		`uvm_component_utils(ram_env)

		ram_agent agt;
		ram_scoreboard sb;
		ram_coverage cov;
		
		function new (string name = "ram_env", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase (uvm_phase phase);
			super.build_phase(phase);
			agt = ram_agent::type_id::create("agt", this);
			sb = ram_scoreboard::type_id::create("sb", this);
			cov = ram_coverage::type_id::create("cov", this);

			// agt_ap = new("agt_ap", this);
			// cov_export = new("cov_export", this);

			// driver = shftreg_driver::type_id::create("driver", this);
			// sqr = shftreg_sequencer::type_id::create("sqr", this);
		endfunction : build_phase

		function void connect_phase (uvm_phase phase);
			agt.agt_ap.connect(sb.sb_export);
			agt.agt_ap.connect(cov.cov_export);
			// driver.seq_item_port.connect(sqr.seq_item_export);
		endfunction : connect_phase
	endclass : ram_env

endpackage