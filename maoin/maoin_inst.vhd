	component maoin is
		port (
			btn0_i_export         : in  std_logic                    := 'X'; -- export
			clk_clk               : in  std_logic                    := 'X'; -- clk
			reset_reset_n         : in  std_logic                    := 'X'; -- reset_n
			segm_con_new_signal   : out std_logic_vector(7 downto 0);        -- new_signal
			segm_con_new_signal_1 : out std_logic_vector(7 downto 0);        -- new_signal_1
			segm_con_new_signal_2 : out std_logic_vector(7 downto 0)         -- new_signal_2
		);
	end component maoin;

	u0 : component maoin
		port map (
			btn0_i_export         => CONNECTED_TO_btn0_i_export,         --   btn0_i.export
			clk_clk               => CONNECTED_TO_clk_clk,               --      clk.clk
			reset_reset_n         => CONNECTED_TO_reset_reset_n,         --    reset.reset_n
			segm_con_new_signal   => CONNECTED_TO_segm_con_new_signal,   -- segm_con.new_signal
			segm_con_new_signal_1 => CONNECTED_TO_segm_con_new_signal_1, --         .new_signal_1
			segm_con_new_signal_2 => CONNECTED_TO_segm_con_new_signal_2  --         .new_signal_2
		);

