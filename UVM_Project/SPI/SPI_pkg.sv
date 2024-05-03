package SPI_pkg;
	class SPI_rand;
		rand bit rst_n, SS_n, MOSI;
		bit clk, MISO;
		bit old_mosi;

		constraint rst_Constr {
			rst_n dist {0 := 4, 1 := 96};
		}

		constraint slaveSel_Constr {
			SS_n dist {0 := 98, 1 := 2};
		}

		covergroup SPI_cg @(posedge clk);
		   	reset_cp: coverpoint rst_n{
		   		bins rst 	= {0};
		   		bins noRst 	= {1};
		   	}

		   	slaveSel_cp: coverpoint SS_n{
		   		bins sel 	= {0};
		   		bins noSel 	= {1};
		   	}

		   	MOSI_cp: coverpoint MOSI{
		   		bins MOSI_high = {1};
		   		bins MOSI_low  = {0};
		   	}

		   	MISO_cp: coverpoint MISO{
		   		bins MISO_high = {1};
		   		bins MISO_low  = {0};
		   	}

		   	cross reset_cp, slaveSel_cp, MOSI_cp{
		   		ignore_bins crsRst = !binsof(reset_cp.rst); 
		   	}

		   	cross reset_cp, slaveSel_cp, MOSI_cp{
		   		bins crsMOSI = binsof(reset_cp.noRst) && binsof(slaveSel_cp.sel);
		   	}
		endgroup : SPI_cg

		function void post_randomize ();
			old_mosi = MOSI;
		endfunction : post_randomize 

		function new ();
			SPI_cg = new;
		endfunction : new

	endclass : SPI_rand
endpackage : SPI_pkg