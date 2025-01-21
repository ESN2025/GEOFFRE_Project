
module maoin (
	btn0_export,
	clk_clk,
	opencores_i2c_0_export_0_scl_pad_io,
	opencores_i2c_0_export_0_sda_pad_io,
	reset_reset_n,
	segm_con_new_signal,
	segm_con_new_signal_1,
	segm_con_new_signal_2,
	segm_con2_new_signal,
	segm_con2_new_signal_1,
	segm_con2_new_signal_2,
	vga_0_vga_g,
	vga_0_vga_b,
	vga_0_vga_hsync,
	vga_0_vga_vsync,
	vga_0_vga_r);	

	input		btn0_export;
	input		clk_clk;
	inout		opencores_i2c_0_export_0_scl_pad_io;
	inout		opencores_i2c_0_export_0_sda_pad_io;
	input		reset_reset_n;
	output	[7:0]	segm_con_new_signal;
	output	[7:0]	segm_con_new_signal_1;
	output	[7:0]	segm_con_new_signal_2;
	output	[7:0]	segm_con2_new_signal;
	output	[7:0]	segm_con2_new_signal_1;
	output	[7:0]	segm_con2_new_signal_2;
	output	[3:0]	vga_0_vga_g;
	output	[3:0]	vga_0_vga_b;
	output		vga_0_vga_hsync;
	output		vga_0_vga_vsync;
	output	[3:0]	vga_0_vga_r;
endmodule
