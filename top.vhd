library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port (
          CLK_50M : in STD_LOGIC;
		  btn_a : in  std_logic;
		  btn_rst : in  std_logic;
		  sw_i : in std_logic_vector(3 downto 0);
		  segm_ones : out std_logic_vector(7 downto 0);
          segm_tens : out std_logic_vector(7 downto 0);
          segm_hundreds : out std_logic_vector(7 downto 0)
		  );
end top;

architecture Archon of top is
    component maoin is
        port (
            btn0_i_export         : in  std_logic                    := 'X'; -- export
            clk_clk               : in  std_logic                    := 'X'; -- clk
            reset_reset_n         : in  std_logic                    := 'X'; -- reset_n
            segm_con_new_signal   : out std_logic_vector(7 downto 0);        -- ones
            segm_con_new_signal_1 : out std_logic_vector(7 downto 0);        -- tens
            segm_con_new_signal_2 : out std_logic_vector(7 downto 0)         -- hundreds
        );
    end component maoin;

begin
    u0 : component maoin port map (not btn_a, CLK_50M, btn_rst, segm_ones, segm_tens, segm_hundreds);
end Archon;