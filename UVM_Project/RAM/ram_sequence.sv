package RAM_sequence;
	import RAM_seq_item::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class ram_reset_sequence extends uvm_sequence #(ram_seq_item);
		`uvm_object_utils(ram_reset_sequence)

		ram_seq_item seq_item;

		function new (string name = "ram_reset_sequence");
			super.new(name);
		endfunction

		task body();
			seq_item = ram_seq_item::type_id::create("seq_item");

			start_item(seq_item);
			seq_item.rst_n 		= 0;
			seq_item.din 		= 0;
			seq_item.rx_valid 	= 0;
			finish_item(seq_item);
		endtask : body
	endclass : ram_reset_sequence

	/**************************************************/

	class ram_write_sequence extends uvm_sequence #(ram_seq_item);
		`uvm_object_utils(ram_write_sequence)

		ram_seq_item seq_item;

		function new (string name = "ram_write_sequence");
			super.new(name);
		endfunction

		task body();
			seq_item = ram_seq_item::type_id::create("seq_item"); 
			repeat (1000) begin
			start_item(seq_item);
				assert(seq_item.randomize());
				seq_item.rst_n 		= 1;
				seq_item.rx_valid 	= 1;
				seq_item.din[9] 	= WRITE;
			finish_item(seq_item);
			end
		endtask : body
	endclass : ram_write_sequence

	/**************************************************/

	class ram_read_sequence extends uvm_sequence #(ram_seq_item);
		`uvm_object_utils(ram_read_sequence)

		ram_seq_item seq_item;

		function new (string name = "ram_read_sequence");
			super.new(name);
		endfunction

		task body();
			seq_item = ram_seq_item::type_id::create("seq_item");
			repeat (1000) begin
			start_item(seq_item);
				assert(seq_item.randomize());
				seq_item.rst_n 		= 1;
				seq_item.rx_valid 	= 1;
				seq_item.din[9] 	= READ;
			finish_item(seq_item);
			end
		endtask : body
	endclass : ram_read_sequence

	/**************************************************/

	class ram_read_write_sequence extends uvm_sequence #(ram_seq_item);
		`uvm_object_utils(ram_read_write_sequence)

		ram_seq_item seq_item;

		function new (string name = "ram_read_write_sequence");
			super.new(name);
		endfunction

		task body();
			seq_item = ram_seq_item::type_id::create("seq_item");
			repeat (1000) begin
			start_item(seq_item);
				assert(seq_item.randomize());
			finish_item(seq_item);
			end
		endtask : body
	endclass : ram_read_write_sequence

endpackage