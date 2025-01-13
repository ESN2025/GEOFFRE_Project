library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AV2SEGM is
	port (
		avalon_slave_address    : in  std_logic_vector(1 downto 0) := (others => '0'); -- avalon_slave.address
		avalon_slave_chipselect : in  std_logic                    := '0';             --             .chipselect
		avalon_slave_writedata  : in  std_logic_vector(7 downto 0) := (others => '0'); --             .writedata
		avalon_slave_write      : in  std_logic                    := '0';             --             .write
		clock_sink_clk          : in  std_logic                    := '0';             --   clock_sink.clk
		reset_sink_reset        : in  std_logic                    := '0';             --   reset_sink.reset
		segm_out                : out std_logic_vector(7 downto 0)                     --  conduit_end.segm
	);
end entity AV2SEGM;

architecture rtl of AV2SEGM is
signal dat : std_logic_vector(7 downto 0);

begin
	process(clock_sink_clk, reset_sink_reset)
	begin
		if reset_sink_reset = '0' then
			dat <= "01010101";
		elsif rising_edge(clock_sink_clk) then
				if (avalon_slave_chipselect = '1' AND avalon_slave_write = '1' AND avalon_slave_address = "00") then 
					dat <= avalon_slave_writedata(7 DOWNTO 0);
				end if;
		end if;
	end process;

    process(dat)
    begin
        case dat(3 downto 0) is
            when "0000" => segm_out <= "11000000"; -- 0
            when "0001" => segm_out <= "11111001"; -- 1
            when "0010" => segm_out <= "10100100"; -- 2
            when "0011" => segm_out <= "10110000"; -- 3
            when "0100" => segm_out <= "10011001"; -- 4
            when "0101" => segm_out <= "10010010"; -- 5
            when "0110" => segm_out <= "10000010"; -- 6
            when "0111" => segm_out <= "11111000"; -- 7
            when "1000" => segm_out <= "10000000"; -- 8
            when "1001" => segm_out <= "10010000"; -- 9
            when "1010" => segm_out <= "10001000"; -- A
            when "1011" => segm_out <= "10000011"; -- B
            when "1100" => segm_out <= "11000110"; -- C
            when "1101" => segm_out <= "10100001"; -- D
            when "1110" => segm_out <= "10000110"; -- E
            when "1111" => segm_out <= "10001110"; -- F
            when others => segm_out <= "11111111";
        end case;
    end process;

end architecture rtl;