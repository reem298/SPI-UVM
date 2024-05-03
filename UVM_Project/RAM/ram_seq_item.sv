package RAM_seq_item;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	typedef enum{SEND_ADDR, SEND_DATA}op_e;
	typedef enum{WRITE, READ}operation_e;

	class ram_seq_item extends uvm_sequence_item;
		`uvm_object_utils(ram_seq_item)

		rand bit rst_n;
		rand bit rx_valid;
		rand bit [9:0] din;
		bit tx_valid;
		bit [7:0] dout;
		bit old_op = 0;

		constraint rstConstr {
			rst_n dist {0 := 4, 1 := 96};
		}

		constraint dinConstr {
			if(old_op == SEND_ADDR)
				din[8] != SEND_ADDR;
		}

		function void post_randomize ();
			old_op = din[8];
		endfunction : post_randomize 

		function new (string name = "ram_seq_item");
			super.new(name);
		endfunction

		function string convert2string();
			return $sformatf("%s Reset = 0b%0b, Rx_Valid = 0b%0b, Data-in = 0b%0b"
							 , super.convert2string, rst_n, rx_valid, din);
		endfunction : convert2string

		function string convert2string_stimulus();
			return $sformatf("Reset = 0b%0b, Rx_Valid = 0b%0b, Data-in = 0b%0b"
							 ,rst_n, rx_valid, din);
		endfunction : convert2string_stimulus
	
	endclass : ram_seq_item
endpackage