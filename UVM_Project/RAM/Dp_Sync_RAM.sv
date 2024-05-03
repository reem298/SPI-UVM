module Dp_Sync_RAM(RAM_interface.DUT ramIF);

	logic clk, rst_n, rx_valid, tx_valid;
	logic [9:0] din;
	logic [7:0] dout;

	assign clk 				= ramIF.clk;
	assign rst_n 			= ramIF.rst_n;
	assign rx_valid 		= ramIF.rx_valid;
	assign din 				= ramIF.din;
	assign ramIF.dout 		= dout;
	assign ramIF.tx_valid 	= tx_valid;

	reg [7:0] mem [ramIF.MEM_DEPTH-1:0];
	reg [ramIF.ADDR_SIZE-1:0] addr_rd;
	reg [ramIF.ADDR_SIZE-1:0] addr_wr;

	//integer i;  				/* was part of the original RTL, but comment-ed to achieve 100% toggle coverage */
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
		   dout <= 0;
		   for(int i=0; i<ramIF.MEM_DEPTH; i=i+1)
			mem[i] <= 0;
		end
		else if (rx_valid) begin
		   tx_valid <= 0;
		   case (din[9:8])
			2'b00: addr_wr <= din[7:0];
			2'b01: mem[addr_wr] <= din[7:0];
			2'b10: addr_rd <= din[7:0];
			2'b11: {dout, tx_valid} <= {mem[addr_rd], 1'b1};
		   endcase
		end
	end

endmodule
