package RAM_scoreboard;
	import RAM_seq_item::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_scoreboard extends uvm_scoreboard;
		`uvm_component_utils(ram_scoreboard);
		uvm_analysis_export #(ram_seq_item) sb_export;
		uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;

		ram_seq_item seq_item_sb;
		logic [3:0] ram_out_ref;

		int error_count = 0, correct_count = 0;

		function new (string name = "ram_scoreboard", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase (uvm_phase phase);
			super.build_phase(phase);
			sb_export = new("sb_export", this);
			sb_fifo = new("sb_fifo", this);
		endfunction : build_phase

		function void connect_phase (uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin 
				sb_fifo.get(seq_item_sb);
				ref_model(seq_item_sb);
				if(seq_item_sb.dout != ram_out_ref) begin 
					`uvm_error("run_phase", $sformatf("Comparison Failed, Transaction received by the DUT is: %s  While the Reference out is: 0d%0d",
						seq_item_sb.convert2string(), ram_out_ref));
					error_count++;
				end
				else begin 
					`uvm_info("run_phase", $sformatf("Correct RAM Out: %s", seq_item_sb.convert2string()), UVM_HIGH);
					correct_count++;
				end
			end
		endtask : run_phase

		task ref_model(ram_seq_item seq_item_chk);
			if(!seq_item_chk.rst_n)
				ram_out_ref = 0;
		endtask : ref_model

		function void report_phase (uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("Total Successful Transactions: %0d", correct_count), UVM_MEDIUM);
			`uvm_info("report_phase", $sformatf("Total Failed Transactions: %0d", error_count), UVM_MEDIUM);
		endfunction : report_phase
	endclass : ram_scoreboard

endpackage