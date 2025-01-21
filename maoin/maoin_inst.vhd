	component maoin is
		port (
			btn0_export                         : in    std_logic                    := 'X'; -- export
			clk_clk                             : in    std_logic                    := 'X'; -- clk
			opencores_i2c_0_export_0_scl_pad_io : inout std_logic                    := 'X'; -- scl_pad_io
			opencores_i2c_0_export_0_sda_pad_io : inout std_logic                    := 'X'; -- sda_pad_io
			reset_reset_n                       : in    std_logic                    := 'X'; -- reset_n
			segm_con_new_signal                 : out   std_logic_vector(7 downto 0);        -- new_signal
			segm_con_new_signal_1               : out   std_logic_vector(7 downto 0);        -- new_signal_1
			segm_con_new_signal_2               : out   std_logic_vector(7 downto 0);        -- new_signal_2
			segm_con2_new_signal                : out   std_logic_vector(7 downto 0);        -- new_signal
			segm_con2_new_signal_1              : out   std_logic_vector(7 downto 0);        -- new_signal_1
			segm_con2_new_signal_2              : out   std_logic_vector(7 downto 0)         -- new_signal_2
		);
	end component maoin;

	u0 : component maoin
		port map (
			btn0_export                         => CONNECTED_TO_btn0_export,                         --                     btn0.export
			clk_clk                             => CONNECTED_TO_clk_clk,                             --                      clk.clk
			opencores_i2c_0_export_0_scl_pad_io => CONNECTED_TO_opencores_i2c_0_export_0_scl_pad_io, -- opencores_i2c_0_export_0.scl_pad_io
			opencores_i2c_0_export_0_sda_pad_io => CONNECTED_TO_opencores_i2c_0_export_0_sda_pad_io, --                         .sda_pad_io
			reset_reset_n                       => CONNECTED_TO_reset_reset_n,                       --                    reset.reset_n
			segm_con_new_signal                 => CONNECTED_TO_segm_con_new_signal,                 --                 segm_con.new_signal
			segm_con_new_signal_1               => CONNECTED_TO_segm_con_new_signal_1,               --                         .new_signal_1
			segm_con_new_signal_2               => CONNECTED_TO_segm_con_new_signal_2,               --                         .new_signal_2
			segm_con2_new_signal                => CONNECTED_TO_segm_con2_new_signal,                --                segm_con2.new_signal
			segm_con2_new_signal_1              => CONNECTED_TO_segm_con2_new_signal_1,              --                         .new_signal_1
			segm_con2_new_signal_2              => CONNECTED_TO_segm_con2_new_signal_2               --                         .new_signal_2
		);

