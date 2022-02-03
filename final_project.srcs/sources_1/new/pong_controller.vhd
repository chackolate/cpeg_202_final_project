library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity pong_controller is
	port (
		clk              : in std_logic;
		reset            : in std_logic;
		player1, player2 : in std_logic;                      --player inputs
		state            : out std_logic_vector (3 downto 0); --state value for SSD
		led              : out std_logic_vector(2 downto 0)); --output state value for SSD
end pong_controller;

architecture Behavioral of pong_controller is

	signal current_state, next_state : std_logic_vector(2 downto 0);
	signal counter                   : integer := 0;
	constant maximum                 : integer := 125000000;
	signal current_leds, next_leds   : std_logic_vector(2 downto 0);

begin

	state <= '0' & current_state;
	led   <= current_leds;

	clocking : process (clk, reset) begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				current_state <= "000";
				counter       <= 0;
			else
				counter <= counter + 1;
				if (counter = maximum) then --every second, switch to next state
					counter       <= 0;
					current_state <= next_state;
					current_leds  <= next_leds;
				end if;
			end if;
		end if;
	end process;

	states : process (current_state) begin
		if (current_state = "000") then --base reset state
			next_state <= "001";
			next_leds  <= "000";

		elsif (current_state = "001") then --scrolling left to right
			if (current_leds = "110") then
				next_state <= "010";
				next_leds  <= "111"; --move on
			else
				next_leds  <= std_logic_vector(unsigned(current_leds) + 1); --scroll LEDs
				next_state <= "001";
			end if;

		elsif (current_state = "010") then --check for player input on right side
			next_state <= "011";
			next_leds  <= "110";

		elsif (current_state = "011") then --scrolling right to left
			if (current_leds = "001") then
				next_state <= "100";
				next_leds  <= "000"; --move on
			else
				next_leds  <= std_logic_vector(unsigned(current_leds) - 1); --scroll LEDs
				next_state <= "011";
			end if;

		elsif (current_state = "100") then --check for player input on left side
			next_leds  <= "001";
			next_state <= "001";

		end if;

	end process;

end Behavioral;