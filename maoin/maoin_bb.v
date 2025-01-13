
module maoin (
	btn0_i_export,
	clk_clk,
	reset_reset_n,
	segm_con_new_signal,
	segm_con_new_signal_1,
	segm_con_new_signal_2);	

	input		btn0_i_export;
	input		clk_clk;
	input		reset_reset_n;
	output	[7:0]	segm_con_new_signal;
	output	[7:0]	segm_con_new_signal_1;
	output	[7:0]	segm_con_new_signal_2;
endmodule
