library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity pong_controller is
	port (
		clk              : in std_logic;
		reset            : in std_logic;
		player1, player2 : in std_logic;                      --player inputs
		-- sw               : in std_logic_vector(3 downto 0);
		state            : out std_logic_vector (3 downto 0); --state value for SSD
		p1Score, p2Score : out integer range 0 to 9;
		led              : out std_logic_vector(2 downto 0)); --control for led module
end pong_controller;

architecture Behavioral of pong_controller is

	signal current_state, next_state : std_logic_vector(2 downto 0);
	signal counter                   : integer := 0;
	-- constant maximum                 : integer := 125000000;
	signal current_leds, next_leds   : std_logic_vector(2 downto 0);
	signal p1Buf, p2Buf              : std_logic;
	signal clock_counts              : integer;
	signal scoreOut1, scoreOut2      : integer range 0 to 20 := 0;
	signal flags                     : std_logic_vector(1 downto 0);
	-- signal swBuf                              : std_logic_vector(3 downto 0);

begin

	-- swBuf        <= sw;
	-- clock_counts <= 125000000 / (2 * to_integer(unsigned(sw)));

	state   <= '0' & current_state;
	led     <= current_leds;
	p1Score <= scoreOut1;
	p2Score <= scoreOut2;

	clocking : process (clk, reset) begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				current_state <= "000";
				-- counter       <= 0;
			else
				p1Buf        <= '0';
				p2Buf        <= '0';
				current_leds <= next_leds;
				if (scoreOut1 > 9 or scoreOut2 > 9) then
					current_state <= "000";
					scoreOut1     <= 0;
					scoreOut2     <= 0;
				else
					current_state <= next_state;
				end if;
				-- counter <= counter + 1;
				if (player1 = '1') then
					p1Buf <= '1';
				end if;
				if (player2 = '1') then
					p2Buf <= '1';
				end if;

				if (counter >= clock_counts) then --every second, switch to next state
					counter      <= 0;
					p1Buf        <= '0';
					p2Buf        <= '0';
					current_leds <= next_leds;
					if (scoreOut1 > 9 or scoreOut2 > 9) then
						current_state <= "000";
						scoreOut1     <= 0;
						scoreOut2     <= 0;
					else
						current_state <= next_state;
						if (flags(0) = '1') then
							scoreOut1 <= scoreOut1 + 1;
							scoreOut2 <= scoreOut2;
						elsif (flags(1) = '1') then
							scoreOut1 <= scoreOut1;
							scoreOut2 <= scoreOut2 + 1;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	states : process (current_state, scoreOut1, scoreOut2) begin
		if (current_state = "000") then --base reset state
			next_state <= "001";
			next_leds  <= "000";
			flags      <= "00";

		elsif (current_state = "001") then --scrolling left to right
			flags <= "00";
			if (current_leds = "110") then
				next_state <= "010";
				next_leds  <= "111"; --move on
			else
				next_leds  <= std_logic_vector(unsigned(current_leds) + 1); --scroll LEDs
				next_state <= "001";
			end if;

		elsif (current_state = "010") then --check for player input on right side
			flags <= "00";
			if (p1Buf = '1') then
				flags      <= "00";
				next_state <= "011";
				next_leds  <= "110";
			else
				next_state <= "101"; --move to state 5, increment p2 score
				next_leds  <= "000";
				-- flags <= "10";
			end if;

		elsif (current_state = "011") then --scrolling right to left
			flags <= "00";
			if (current_leds = "001") then
				next_state <= "100";
				next_leds  <= "000"; --move on
			else
				next_state <= "011";
				next_leds  <= std_logic_vector(unsigned(current_leds) - 1); --scroll LEDs
			end if;

		elsif (current_state = "100") then --check for player input on left side
			flags <= "00";
			if (p2Buf = '1') then
				next_state <= "001";
				next_leds  <= "001";
			else
				next_state <= "111"; --move to state 6
				next_leds  <= "111";

			end if;

		elsif (current_state = "101") then --player 2 score
			flags      <= "10";
			next_state <= "001";
			next_leds  <= "000";

		elsif (current_state = "111") then --player 1 score
			flags      <= "01";
			next_state <= "011";
			next_leds  <= "111";

		end if;

	end process;

end Behavioral;