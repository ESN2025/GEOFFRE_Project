library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AV2SEGM3 is
	port (
		avalon_slave_address    : in  std_logic_vector(1 downto 0) := (others => '0'); -- avalon_slave.address
		avalon_slave_writedata  : in  std_logic_vector(7 downto 0) := (others => '0'); --             .writedata
		avalon_slave_write      : in  std_logic                    := '0';             --             .write
		clock_sink_clk          : in  std_logic                    := '0';             --   clock_sink.clk
		reset_sink_reset        : in  std_logic                    := '0';             --   reset_sink.reset
		segm_out_ones           : out std_logic_vector(7 downto 0);                     --  conduit_end.segm
        segm_out_tens           : out std_logic_vector(7 downto 0);                     --  conduit_end.segm
        segm_out_hundreds       : out std_logic_vector(7 downto 0)                     --  conduit_end.segm
	);
end entity AV2SEGM3;

architecture rtl of AV2SEGM3 is
signal ones : std_logic_vector(3 downto 0);
signal tens : std_logic_vector(3 downto 0);
signal hundreds : std_logic_vector(3 downto 0);
signal db1 : std_logic;

begin
	process(clock_sink_clk, reset_sink_reset)
	begin
		if reset_sink_reset = '0' then
			ones <= "0101";
            tens <= "0101";
            hundreds <= "0101";
            db1 <= '0';
		elsif rising_edge(clock_sink_clk) then
				if (avalon_slave_write = '1') then 
                    case avalon_slave_address is
                        when "00" => ones <= avalon_slave_writedata(3 DOWNTO 0);
                        when "01" => tens <= avalon_slave_writedata(3 DOWNTO 0);
                        when "10" => hundreds <= avalon_slave_writedata(3 DOWNTO 0);
                        when others => db1 <= '1';
                    end case;
				end if;
		end if;
	end process;

    process(clock_sink_clk)
    begin
        if falling_edge(clock_sink_clk) then
        case ones is
            when "0000" => segm_out_ones <= "11000000"; -- 0
            when "0001" => segm_out_ones <= "11111001"; -- 1
            when "0010" => segm_out_ones <= "10100100"; -- 2
            when "0011" => segm_out_ones <= "10110000"; -- 3
            when "0100" => segm_out_ones <= "10011001"; -- 4
            when "0101" => segm_out_ones <= "10010010"; -- 5
            when "0110" => segm_out_ones <= "10000010"; -- 6
            when "0111" => segm_out_ones <= "11111000"; -- 7
            when "1000" => segm_out_ones <= "10000000"; -- 8
            when "1001" => segm_out_ones <= "10010000"; -- 9
            when "1010" => segm_out_ones <= "10001000"; -- A
            when "1011" => segm_out_ones <= "10000011"; -- B
            when "1100" => segm_out_ones <= "11000110"; -- C
            when "1101" => segm_out_ones <= "10100001"; -- D
            when "1110" => segm_out_ones <= "10000110"; -- E
            when "1111" => segm_out_ones <= "10001110"; -- F
            when others => segm_out_ones <= "11111111";
        end case;
        case tens is
            when "0000" => segm_out_tens <= "11000000"; -- 0
            when "0001" => segm_out_tens <= "11111001"; -- 1
            when "0010" => segm_out_tens <= "10100100"; -- 2
            when "0011" => segm_out_tens <= "10110000"; -- 3
            when "0100" => segm_out_tens <= "10011001"; -- 4
            when "0101" => segm_out_tens <= "10010010"; -- 5
            when "0110" => segm_out_tens <= "10000010"; -- 6
            when "0111" => segm_out_tens <= "11111000"; -- 7
            when "1000" => segm_out_tens <= "10000000"; -- 8
            when "1001" => segm_out_tens <= "10010000"; -- 9
            when "1010" => segm_out_tens <= "10001000"; -- A
            when "1011" => segm_out_tens <= "10000011"; -- B
            when "1100" => segm_out_tens <= "11000110"; -- C
            when "1101" => segm_out_tens <= "10100001"; -- D
            when "1110" => segm_out_tens <= "10000110"; -- E
            when "1111" => segm_out_tens <= "10001110"; -- F
            when others => segm_out_tens <= "11111111";
        end case;
        case hundreds is
            when "0000" => segm_out_hundreds <= "11000000"; -- 0
            when "0001" => segm_out_hundreds <= "11111001"; -- 1
            when "0010" => segm_out_hundreds <= "10100100"; -- 2
            when "0011" => segm_out_hundreds <= "10110000"; -- 3
            when "0100" => segm_out_hundreds <= "10011001"; -- 4
            when "0101" => segm_out_hundreds <= "10010010"; -- 5
            when "0110" => segm_out_hundreds <= "10000010"; -- 6
            when "0111" => segm_out_hundreds <= "11111000"; -- 7
            when "1000" => segm_out_hundreds <= "10000000"; -- 8
            when "1001" => segm_out_hundreds <= "10010000"; -- 9
            when "1010" => segm_out_hundreds <= "10001000"; -- A
            when "1011" => segm_out_hundreds <= "10000011"; -- B
            when "1100" => segm_out_hundreds <= "11000110"; -- C
            when "1101" => segm_out_hundreds <= "10100001"; -- D
            when "1110" => segm_out_hundreds <= "10000110"; -- E
            when "1111" => segm_out_hundreds <= "10001110"; -- F
            when others => segm_out_hundreds <= "11111111";
        end case;
        end if;
    end process;

end architecture rtl;