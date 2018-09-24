module t_flipflop
(
	input  wire clk,
	input wire reset, 
	output wire  q_out
);

reg q;

always @ ( posedge clk)
if (~reset)
	begin
		q <= 1'b0;
	end
else
	begin
    	q <= !q;
	end

assign q_out = q;

endmodule
