-- maoin_mm_interconnect_0_avalon_st_adapter_002.vhd

-- This file was auto-generated from altera_avalon_st_adapter_hw.tcl.  If you edit it your changes
-- will probably be lost.
-- 
-- Generated using ACDS version 18.1 646

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity maoin_mm_interconnect_0_avalon_st_adapter_002 is
	generic (
		inBitsPerSymbol : integer := 10;
		inUsePackets    : integer := 0;
		inDataWidth     : integer := 10;
		inChannelWidth  : integer := 0;
		inErrorWidth    : integer := 0;
		inUseEmptyPort  : integer := 0;
		inUseValid      : integer := 1;
		inUseReady      : integer := 1;
		inReadyLatency  : integer := 0;
		outDataWidth    : integer := 10;
		outChannelWidth : integer := 0;
		outErrorWidth   : integer := 1;
		outUseEmptyPort : integer := 0;
		outUseValid     : integer := 1;
		outUseReady     : integer := 1;
		outReadyLatency : integer := 0
	);
	port (
		in_clk_0_clk   : in  std_logic                    := '0';             -- in_clk_0.clk
		in_rst_0_reset : in  std_logic                    := '0';             -- in_rst_0.reset
		in_0_data      : in  std_logic_vector(9 downto 0) := (others => '0'); --     in_0.data
		in_0_valid     : in  std_logic                    := '0';             --         .valid
		in_0_ready     : out std_logic;                                       --         .ready
		out_0_data     : out std_logic_vector(9 downto 0);                    --    out_0.data
		out_0_valid    : out std_logic;                                       --         .valid
		out_0_ready    : in  std_logic                    := '0';             --         .ready
		out_0_error    : out std_logic_vector(0 downto 0)                     --         .error
	);
end entity maoin_mm_interconnect_0_avalon_st_adapter_002;

architecture rtl of maoin_mm_interconnect_0_avalon_st_adapter_002 is
	component maoin_mm_interconnect_0_avalon_st_adapter_002_error_adapter_0 is
		port (
			clk       : in  std_logic                    := 'X';             -- clk
			reset_n   : in  std_logic                    := 'X';             -- reset_n
			in_data   : in  std_logic_vector(9 downto 0) := (others => 'X'); -- data
			in_valid  : in  std_logic                    := 'X';             -- valid
			in_ready  : out std_logic;                                       -- ready
			out_data  : out std_logic_vector(9 downto 0);                    -- data
			out_valid : out std_logic;                                       -- valid
			out_ready : in  std_logic                    := 'X';             -- ready
			out_error : out std_logic_vector(0 downto 0)                     -- error
		);
	end component maoin_mm_interconnect_0_avalon_st_adapter_002_error_adapter_0;

	signal in_rst_0_reset_ports_inv : std_logic; -- in_rst_0_reset:inv -> error_adapter_0:reset_n

begin

	inbitspersymbol_check : if inBitsPerSymbol /= 10 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	inusepackets_check : if inUsePackets /= 0 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	indatawidth_check : if inDataWidth /= 10 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	inchannelwidth_check : if inChannelWidth /= 0 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	inerrorwidth_check : if inErrorWidth /= 0 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	inuseemptyport_check : if inUseEmptyPort /= 0 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	inusevalid_check : if inUseValid /= 1 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	inuseready_check : if inUseReady /= 1 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	inreadylatency_check : if inReadyLatency /= 0 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	outdatawidth_check : if outDataWidth /= 10 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	outchannelwidth_check : if outChannelWidth /= 0 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	outerrorwidth_check : if outErrorWidth /= 1 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	outuseemptyport_check : if outUseEmptyPort /= 0 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	outusevalid_check : if outUseValid /= 1 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	outuseready_check : if outUseReady /= 1 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	outreadylatency_check : if outReadyLatency /= 0 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	error_adapter_0 : component maoin_mm_interconnect_0_avalon_st_adapter_002_error_adapter_0
		port map (
			clk       => in_clk_0_clk,             --   clk.clk
			reset_n   => in_rst_0_reset_ports_inv, -- reset.reset_n
			in_data   => in_0_data,                --    in.data
			in_valid  => in_0_valid,               --      .valid
			in_ready  => in_0_ready,               --      .ready
			out_data  => out_0_data,               --   out.data
			out_valid => out_0_valid,              --      .valid
			out_ready => out_0_ready,              --      .ready
			out_error => out_0_error               --      .error
		);

	in_rst_0_reset_ports_inv <= not in_rst_0_reset;

end architecture rtl; -- of maoin_mm_interconnect_0_avalon_st_adapter_002
