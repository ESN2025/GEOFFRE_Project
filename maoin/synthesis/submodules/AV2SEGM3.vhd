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
signal ones : std_logic_vector(4 downto 0);
signal tens : std_logic_vector(4 downto 0);
signal hundreds : std_logic_vector(4 downto 0);
signal db1 : std_logic;

begin
	process(clock_sink_clk, reset_sink_reset)
	begin
		if reset_sink_reset = '0' then
			ones <= "00101";
            tens <= "00101";
            hundreds <= "00101";
            db1 <= '0';
		elsif rising_edge(clock_sink_clk) then
				if (avalon_slave_write = '1') then 
                    case avalon_slave_address is
                        when "00" => ones <= (not avalon_slave_writedata(4)) & avalon_slave_writedata(3 DOWNTO 0); 
                        when "01" => tens <= (not avalon_slave_writedata(4)) & avalon_slave_writedata(3 DOWNTO 0);
                        when "10" => hundreds <= (not avalon_slave_writedata(4)) & avalon_slave_writedata(3 DOWNTO 0);
                        when others => db1 <= '1';
                    end case;
				end if;
		end if;
	end process;

    process(clock_sink_clk)
    begin
        if falling_edge(clock_sink_clk) then
        case ones(3 downto 0) is
            when "0000" => segm_out_ones <= ones(4)&"1000000"; -- 0 or 0.
            when "0001" => segm_out_ones <= ones(4)&"1111001"; -- 1 or 1.
            when "0010" => segm_out_ones <= ones(4)&"0100100"; -- 2 or 2.
            when "0011" => segm_out_ones <= ones(4)&"0110000"; -- 3 or 3.
            when "0100" => segm_out_ones <= ones(4)&"0011001"; -- 4 or 4.
            when "0101" => segm_out_ones <= ones(4)&"0010010"; -- 5 or 5.
            when "0110" => segm_out_ones <= ones(4)&"0000010"; -- 6 or 6.
            when "0111" => segm_out_ones <= ones(4)&"1111000"; -- 7 or 7.
            when "1000" => segm_out_ones <= ones(4)&"0000000"; -- 8 or 8.
            when "1001" => segm_out_ones <= ones(4)&"0010000"; -- 9 or 9.
            when "1010" => segm_out_ones <= ones(4)&"0111111"; -- - or -.
            when "1011" => segm_out_ones <= ones(4)&"0000011"; -- B
            when "1100" => segm_out_ones <= ones(4)&"1000110"; -- C
            when "1101" => segm_out_ones <= ones(4)&"0100001"; -- D
            when "1110" => segm_out_ones <= ones(4)&"0000110"; -- E
            when "1111" => segm_out_ones <= ones(4)&"0001110"; -- F
            when others => segm_out_ones <= ones(4)&"1111111";
        end case;
        case tens(3 downto 0) is
            when "0000" => segm_out_tens <= tens(4)&"1000000"; -- 0 or 0.
            when "0001" => segm_out_tens <= tens(4)&"1111001"; -- 1 or 1.
            when "0010" => segm_out_tens <= tens(4)&"0100100"; -- 2 or 2.
            when "0011" => segm_out_tens <= tens(4)&"0110000"; -- 3 or 3.
            when "0100" => segm_out_tens <= tens(4)&"0011001"; -- 4 or 4.
            when "0101" => segm_out_tens <= tens(4)&"0010010"; -- 5 or 5.
            when "0110" => segm_out_tens <= tens(4)&"0000010"; -- 6 or 6.
            when "0111" => segm_out_tens <= tens(4)&"1111000"; -- 4 or 4.
            when "1000" => segm_out_tens <= tens(4)&"0000000"; -- 8 or 8.
            when "1001" => segm_out_tens <= tens(4)&"0010000"; -- 9 or 9.
            when "1010" => segm_out_tens <= tens(4)&"0111111"; -- - or -.
            when "1011" => segm_out_tens <= tens(4)&"0000011"; -- B
            when "1100" => segm_out_tens <= tens(4)&"1000110"; -- C
            when "1101" => segm_out_tens <= tens(4)&"0100001"; -- D
            when "1110" => segm_out_tens <= tens(4)&"0000110"; -- E
            when "1111" => segm_out_tens <= tens(4)&"0001110"; -- F
            when others => segm_out_tens <= tens(4)&"1111111";
        end case;
        case hundreds(3 downto 0) is
            when "0000" => segm_out_hundreds <= hundreds(4)&"1000000"; -- 0 or 0.
            when "0001" => segm_out_hundreds <= hundreds(4)&"1111001"; -- 1 or 1.
            when "0010" => segm_out_hundreds <= hundreds(4)&"0100100"; -- 2 or 2.
            when "0011" => segm_out_hundreds <= hundreds(4)&"0110000"; -- 3 or 3.
            when "0100" => segm_out_hundreds <= hundreds(4)&"0011001"; -- 4 or 4.
            when "0101" => segm_out_hundreds <= hundreds(4)&"0010010"; -- 5 or 5.
            when "0110" => segm_out_hundreds <= hundreds(4)&"0000010"; -- 6 or 6.
            when "0111" => segm_out_hundreds <= hundreds(4)&"1111000"; -- 4 or 4.
            when "1000" => segm_out_hundreds <= hundreds(4)&"0000000"; -- 8 or 8.
            when "1001" => segm_out_hundreds <= hundreds(4)&"0010000"; -- 9 or 9.
            when "1010" => segm_out_hundreds <= hundreds(4)&"0111111"; -- - or -.
            when "1011" => segm_out_hundreds <= hundreds(4)&"0000011"; -- B
            when "1100" => segm_out_hundreds <= hundreds(4)&"1000110"; -- C
            when "1101" => segm_out_hundreds <= hundreds(4)&"0100001"; -- D
            when "1110" => segm_out_hundreds <= hundreds(4)&"0000110"; -- E
            when "1111" => segm_out_hundreds <= hundreds(4)&"0001110"; -- F
            when others => segm_out_hundreds <= hundreds(4)&"1111111";
        end case;
        end if;
    end process;

end architecture rtl;