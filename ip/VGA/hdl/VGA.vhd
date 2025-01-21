library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity VGA is
	port (
        clk : in std_logic;
        reset_n : in std_logic;

        r : out std_logic_vector(3 downto 0);
        g : out std_logic_vector(3 downto 0);
        b : out std_logic_vector(3 downto 0);
        hs: out std_logic;
        vs: out std_logic;

        avalon_slave_address    : in  std_logic_vector(1 downto 0) := (others => '0');
		avalon_slave_writedata  : in  std_logic_vector(31 downto 0) := (others => '0');
		avalon_slave_write      : in  std_logic                    := '0'
	);
end entity VGA;

architecture rtl of VGA is
constant line_sync_pulse : integer := 96; --during Hsync pulse, 96 pixels
constant line_back_porch : integer := 48; --before pixels
constant line_pixels     : integer := 640;
constant line_front_porch : integer := 16; --after pixels

constant frame_sync_pulse : integer := 2; -- during Vsync pulse, 2 lines worth
constant frame_back_porch : integer := 33; --before frame
constant frame_lines  : integer := 480;
constant frame_front_porch : integer := 10;--after frame

--type t_line is array (0 to 639) of std_logic_vector(11 downto 0);
--type t_frame is array (0 to 479) of t_line;
--constant framebuf : t_frame := (others => (others => ("111100001111")));

signal line_counter : integer range 0 to frame_lines;    --specifically to keep track of the line counts
signal pix_counter : integer range 0 to line_pixels;     --specifically to keep track of the pixel counts

signal next_pong_x : integer := 200;
signal next_pong_y : integer := 300;

signal pong_x : integer := 200;
signal pong_y : integer := 300; --unlimited 32 bits integer on purpose (for avalon), locked in for one frame

type state_frame_t is (   sync, --start of frame
                        back_porch,
                        lines,
                        front_porch
                    );

type state_line_t is (    sync, --start of line
                        back_porch,
                        pixels,
                        front_porch
                    );
signal frame_state : state_frame_t;
signal line_state : state_line_t;

signal clkdiv : std_logic := '0';
signal clkret : std_logic := '0';

signal db1 : std_logic := '0';

begin

    process(clk, reset_n)
	begin
		if reset_n = '0' then
            next_pong_x <= 300;
            next_pong_y <= 200; 
		elsif rising_edge(clk) then
				if (avalon_slave_write = '1') then 
                    case avalon_slave_address is
                        when "00" => next_pong_x <= to_integer(unsigned(avalon_slave_writedata)); 
                        when "01" => next_pong_y <= to_integer(unsigned(avalon_slave_writedata));
                        when others => db1 <= '1';
                    end case;
				end if;
		end if;
	end process;


	process(clk, reset_n)
	begin
	if reset_n = '0' then
		clkret <= '0';
	elsif(falling_edge(clk)) then
		clkret <= not clkret;
        if(clkret = '1') then
            clkdiv <= not clkdiv;
        end if;
	end if;
	end process;

	process(clkret, reset_n)
	begin
		if reset_n = '0' then
            frame_state <= sync;
            line_state <= sync;
            line_counter <= frame_sync_pulse;
            pix_counter <= line_sync_pulse;
            
		elsif falling_edge(clkret) then
            if(pix_counter > 1) then
                pix_counter <= pix_counter - 1;
            else
                case line_state is --current line state has finished
                    when sync => line_state <= back_porch; pix_counter <= line_back_porch;
                    when back_porch => line_state <= pixels; pix_counter <= line_pixels;
                    when pixels => line_state <= front_porch; pix_counter <= line_front_porch;
                    when front_porch =>
                        if(line_counter > 1) then
                            line_counter <= line_counter - 1;
                            line_state <= sync; --next line
                            pix_counter <= line_sync_pulse;
                        else
                            case frame_state is
                                when sync => frame_state <= back_porch; line_counter <= frame_back_porch; pong_x <= next_pong_x; pong_y <= next_pong_y;
                                when back_porch => frame_state <= lines; line_counter <= frame_lines;
                                when lines => frame_state <= front_porch; line_counter <= frame_front_porch;
                                when front_porch => frame_state <= sync; line_counter <= frame_sync_pulse;
                            end case;
                        end if;
                end case;
            end if;
		end if;
	end process;

	with line_state select hs <= 
											'1' when sync, 
											'0' when others;

	with frame_state select vs <= 
											'1' when sync, 
											'0' when others;

    r <=  "1111" when (((line_counter < 10 or line_counter > (frame_lines - 10) or pix_counter < 10 or pix_counter > (line_pixels - 10)) 
                        or (line_counter > (pong_y - 10) and line_counter < (pong_y + 10))
                        or (pix_counter > (pong_x - 10) and pix_counter < (pong_x + 10))
                        ) and (line_state = pixels))  --blank outside of pixel color out
                        else "0000";

    g <=  "1111" when ((line_counter < 10 
                        or line_counter > (frame_lines - 10) 
                        or pix_counter < 10 
                        or pix_counter > (line_pixels - 10)) and (line_state = pixels))
                        else "0000";


    b <=  "1111" when ((line_counter < 10 
                        or line_counter > (frame_lines - 10) 
                        or pix_counter < 10 
                        or pix_counter > (line_pixels - 10)) and (line_state = pixels))
                        else "0000";
end architecture rtl;