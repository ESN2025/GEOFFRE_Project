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
            segm_hundreds : out std_logic_vector(7 downto 0);
			segm_thousands : out std_logic_vector(7 downto 0);
            segm_tens_thousands : out std_logic_vector(7 downto 0);
            segm_sign : out std_logic_vector(7 downto 0);
			i2c_scl : inout std_logic;
			i2c_sda : inout std_logic;
			vga_CLK : out   std_logic;                           -- CLK
            vga_HS  : out   std_logic;                           -- HS
            vga_VS  : out   std_logic;                           -- VS
            vga_BLANK   : out   std_logic;                           -- BLANK
            vga_SYNC    : out   std_logic;                           -- SYNC
            vga_R       : out   std_logic_vector(3 downto 0);        -- R
            vga_G       : out   std_logic_vector(3 downto 0);        -- G
            vga_B       : out   std_logic_vector(3 downto 0)        -- B
		  );
end top;

architecture Archon of top is
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
            segm_con2_new_signal_2              : out   std_logic_vector(7 downto 0);        -- new_signal_2
            vga_0_vga_g                         : out   std_logic_vector(3 downto 0);        -- g
            vga_0_vga_b                         : out   std_logic_vector(3 downto 0);        -- b
            vga_0_vga_hsync                     : out   std_logic;                           -- hsync
            vga_0_vga_vsync                     : out   std_logic;                           -- vsync
            vga_0_vga_r                         : out   std_logic_vector(3 downto 0)         -- r
        );
    end component maoin;
    
begin
    u0 : component maoin
        port map (
			btn0_export                         => btn_a,
            clk_clk                             => CLK_50M,                --                      clk.clk
            reset_reset_n                       => btn_rst,                --                    reset.reset_n
            segm_con_new_signal                 => segm_ones,              --                 segm_con.new_signal
            segm_con_new_signal_1               => segm_tens,              --                         .new_signal_1
            segm_con_new_signal_2               => segm_hundreds,          --                         .new_signal_2
            segm_con2_new_signal                => segm_thousands,         --                segm_con2.new_signal
            segm_con2_new_signal_1              => segm_tens_thousands,    --                         .new_signal_1
            segm_con2_new_signal_2              => segm_sign,              --                         .new_signal_2
            opencores_i2c_0_export_0_scl_pad_io => i2c_scl, 					-- opencores_i2c_0_export_0.scl_pad_io
            opencores_i2c_0_export_0_sda_pad_io => i2c_sda,  					--                         .sda_pad_io
            vga_0_vga_hsync                              => vga_HS,                              --                             .HS
            vga_0_vga_vsync                              => vga_VS,                              --                             .VS
            vga_0_vga_r                               => vga_R,                               --                             .R
            vga_0_vga_g                               => vga_G,                               --                             .G
            vga_0_vga_b                               => vga_B
        );
end Archon;