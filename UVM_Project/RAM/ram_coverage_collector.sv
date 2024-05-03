package RAM_coverage_collector;
	import RAM_seq_item::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_coverage extends uvm_component;
		`uvm_component_utils(ram_coverage)
		uvm_analysis_export #(ram_seq_item) cov_export;
		uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;

		ram_seq_item seq_item_cov;

		covergroup cg ();
		   	reset_cp: coverpoint seq_item_cov.rst_n{
		   		bins rst = {0}; 
		   		bins noRst = {1};
		   	}
		   	din_op1_cp: coverpoint seq_item_cov.din[9]{
		   		bins writeOp = {0};
		   		bins readOp = {1};
		   	}
		   	din_op2_cp: coverpoint seq_item_cov.din[8]{
		   		bins addr = {0};
		   		bins data = {1};
		   	}
		   	din_cp: coverpoint seq_item_cov.din[7:0];
		   	rx_cp: coverpoint seq_item_cov.rx_valid{
		   		bins rx_active = {1};
		   		bins rx_low = {0};
		   	}
		   	dout_cp: coverpoint seq_item_cov.dout;

		   	cross reset_cp, din_op1_cp{	
		   		ignore_bins noRst_write = !binsof(reset_cp.noRst);
		   	}

		   	cross reset_cp, rx_cp{
		   		ignore_bins noRst_Rx = !binsof(reset_cp.noRst);
		   	}

		endgroup : cg

		function new (string name = "ram_coverage", uvm_component parent = null);
			super.new(name, parent);
			cg = new;
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
				cg.sample();
			end
		endtask : run_phase
	endclass : ram_coverage
endpackage