import RAM_config_obj::*;
import RAM_driver::*;
import RAM_env::*;
import RAM_test::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top ();
	bit clk;

	initial begin 
		clk = 0; 
		forever 
			#1 	clk = ~clk;
	end

	RAM_interface ramIF(clk);
	Dp_Sync_RAM DUT (ramIF);

	/* Assertion Binding to the Design */
	bind Dp_Sync_RAM RAM_assertions ram_assert(ramIF);

	initial begin
		uvm_config_db#(virtual RAM_interface)::set(null, "uvm_test_top", "RAM_INTERFACE", ramIF); 
		run_test("ram_test");
	end

endmodule : top