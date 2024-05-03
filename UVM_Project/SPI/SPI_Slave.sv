module SPI_Slave(MOSI, SS_n, clk, rst_n, tx_data, tx_valid, MISO, rx_data, rx_valid);
	parameter IDLE = 0; parameter CHK_CMD = 1; parameter WRITE = 2;
	parameter READ_ADD = 3; parameter READ_DATA = 4;

	input MOSI, SS_n, clk, rst_n, tx_valid;
	input [7:0] tx_data;
	output MISO;
	output reg rx_valid;
	output reg [9:0] rx_data;


	reg [2:0] cs, ns;
	reg [9:0] PO;
	wire [7:0] temp;
	reg SO, flag_rd = 0;
	bit[3:0] state_count = 0, final_count = 0;
	/* Before: integer 
	   After: bit[3:0] --> to achieve 100% toggle coverage */

	assign temp = (tx_valid)? tx_data: temp;
	assign MISO = SO;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin 
			cs <= IDLE;
			SO <= 0;
		end
		    
		else
		    cs <= ns;
	end

	always @(cs) begin
		case (cs)
		      IDLE: 		rx_valid = 0;
		      WRITE: 		rx_valid = 1;
		      READ_ADD: 	rx_valid = 1;
		      READ_DATA: 	rx_valid = 1;
		      default: 		rx_valid = 0;
		endcase
	end

	always @(posedge clk or negedge SS_n) begin
		if ((cs == WRITE) || (cs == READ_ADD) || (cs == READ_DATA)) begin
		    PO <= {PO[8:0], MOSI}; 
		    state_count <= state_count + 1;
		    if (state_count == 10) begin
				rx_data <= PO; 		state_count <= 0;
		    end
		end
		if (rx_data[9:8] == 2'b11 && temp) begin
		    SO <= temp[7-final_count];
		    final_count <= final_count + 1;
		    if (final_count == 10)
				final_count <= 0;
		end
		// else 
		// 	SO <= 0;
	end

	always @(MOSI, SS_n, cs) begin
		case (cs)
		    IDLE:
				if (SS_n)
				    ns = IDLE;
				else
				    ns = CHK_CMD;
		    CHK_CMD:
				if (SS_n)
				    ns = IDLE;
				else begin
				    if (!MOSI)
					ns = WRITE;
				    else begin
						if (!flag_rd)
						    ns = READ_ADD;
						else
						    ns = READ_DATA;
				    end
				end
		    WRITE:
				if (SS_n)
				    ns = IDLE;
				else
				    ns = WRITE;
		    READ_ADD:
				if (SS_n)
				    ns = IDLE;
				else begin
				    ns = READ_ADD; flag_rd = 1;
				end
		    READ_DATA:
				if (SS_n)
				    ns = IDLE;
				else begin
				    ns = READ_DATA; flag_rd = 0;
				end
		    default: ns = IDLE;
		endcase
	end


	/* ASSERTIONS */
	property p1;
		@(posedge clk) 
		!rst_n |-> (cs == IDLE && !MISO)
	endproperty

	property p2;
		@(posedge clk) disable iff(!rst_n)
		(cs == IDLE) && (!SS_n) |-> (ns == CHK_CMD)
	endproperty

	property p3;
		@(posedge clk) disable iff(!rst_n || SS_n)
		(cs == CHK_CMD && !MOSI) |-> (ns == WRITE)
	endproperty

	property p4;
		@(posedge clk) disable iff(!rst_n || SS_n)
		(cs == CHK_CMD && MOSI && !flag_rd) |-> (ns == READ_ADD)
	endproperty

	property p5;
		@(posedge clk) disable iff(!rst_n || SS_n)
		(cs == CHK_CMD && MOSI && flag_rd) |-> (ns == READ_DATA)
	endproperty

	property p6;
		@(posedge clk) disable iff(!rst_n || SS_n)
		(cs == WRITE) |-> (ns == WRITE)
	endproperty

	property p7;
		@(posedge clk) disable iff(!rst_n || SS_n)
		(cs == READ_ADD) |-> (ns == READ_ADD)
	endproperty

	property p8;
		@(posedge clk) disable iff(!rst_n || SS_n)
		(cs == READ_DATA) |-> (ns == READ_DATA)
	endproperty

	property p9;
		@(posedge clk) disable iff(!rst_n || SS_n)
		(cs == IDLE) |-> (!rx_valid)
	endproperty

	assert property(p1);
	assert property(p2);
	assert property(p3);
	assert property(p4);
	assert property(p5);
	assert property(p6);
	assert property(p7);
	assert property(p8);
	assert property(p9);
	
	cover property(p1);
	cover property(p2);
	cover property(p3);
	cover property(p4);
	cover property(p5);
	cover property(p6);
	cover property(p7);
	cover property(p8);
	cover property(p9);
		
endmodule
