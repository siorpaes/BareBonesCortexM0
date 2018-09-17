`include "barebonesCM0_top.v"
`timescale 1ns/1ns

module bbCM0_tb;

reg r_CLOCK    = 1'b0;
reg r_reset	   = 1'b0;

barebonesCM0_top UUT
(
	.i_clk	(r_CLOCK),
	.i_reset (r_reset)
);

/* 100MHz Clock */
always #10 r_CLOCK <= !r_CLOCK;

initial begin

#100000

/* Give reset */
#100000
r_reset <= 1'b1;

end

endmodule
