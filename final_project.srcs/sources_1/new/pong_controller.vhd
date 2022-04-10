library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity pong_controller is
	port (
		clk              : in std_logic;
		reset            : in std_logic;
		p1Buf, p2Buf     : in std_logic;                      --player inputs
		-- sw               : in std_logic_vector(3 downto 0);
		state            : out std_logic_vector (3 downto 0); --state value for SSD
		p1Score, p2Score : out integer range 0 to 10;
		led              : out std_logic_vector(2 downto 0)); --control for led module
end pong_controller;

architecture Behavioral of pong_controller is

	signal current_state, next_state : std_logic_vector(2 downto 0);
	signal current_leds, next_leds   : std_logic_vector(2 downto 0);
	signal scoreOut1, scoreOut2      : integer range 0 to 10 := 0;
	signal flags                     : std_logic_vector(1 downto 0); --bits to indicate if either side scored
	-- signal swBuf                              : std_logic_vector(3 downto 0);

begin

	-- swBuf        <= sw;
	-- clock_counts <= 125000000 / (2 * to_integer(unsigned(sw)));

	state   <= '0' & current_state;
	led     <= current_leds;
	p1Score <= scoreOut1;
	p2Score <= scoreOut2;

	--process to control OUTPUTS
	--every case MUST update current_state,current_leds, and both scoreOut signals.
	--consistently including these signals in each if statement will make debugging much easier, as you know exactly what is happening in each state
	clocking : process (clk, reset)
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				current_state <= "000";
				current_leds  <= "000";
				scoreOut1     <= 0;
				scoreOut2     <= 0;
			else
				if (scoreOut1 > 9 or scoreOut2 > 9) then
					current_state <= "000";
					current_leds  <= "000";
					scoreOut1     <= 0;
					scoreOut2     <= 0;
				else
					current_state <= next_state;
					current_leds  <= next_leds;
					if (flags = "01") then
						scoreOut1 <= scoreOut1 + 1;
						scoreOut2 <= scoreOut2;
					elsif (flags = "10") then
						scoreOut1 <= scoreOut1;
						scoreOut2 <= scoreOut2 + 1;
					else
						scoreOut1 <= scoreOut1;
						scoreOut2 <= scoreOut2;
					end if;
				end if;
			end if;
		end if;
	end process;

	states : process (current_state, current_leds, p1Buf, p2Buf) begin --based on current state, this process must update next_state, next_leds and scoring flags every clock cycle
		if (current_state = "000") then                                    --base reset state
			next_state <= "001";
			next_leds  <= "000";
			flags      <= "00";

		elsif (current_state = "001") then --scrolling left to right
			if (current_leds = "110") then
				next_state <= "010";
				next_leds  <= "111"; --move on
			else
				next_leds  <= std_logic_vector(unsigned(current_leds) + 1); --scroll LEDs
				next_state <= "001";                                        --cycle in state 1 to scroll
			end if;
			flags <= "00";

		elsif (current_state = "010") then --check for player input on right side
			-- if (p1Buf = '1') then              --buffered input
			next_state <= "011";               --move to state 3 if player 1 hit the button in time
			next_leds  <= "110";               --start leds at 1 less than max so that the animation is smoother
			-- else
			-- 	next_state <= "101"; --move to state 5 if player 1 missed the button
			-- 	next_leds  <= "000"; --no leds
			-- end if;
			flags      <= "00";

		elsif (current_state = "011") then --scrolling right to left
			if (current_leds = "001") then
				next_state <= "100";
				next_leds  <= "000"; --move on
			else
				next_state <= "011";
				next_leds  <= std_logic_vector(unsigned(current_leds) - 1); --scroll LEDs
			end if;
			flags <= "00";

		elsif (current_state = "100") then --check for player input on left side
			-- if (p2Buf = '1') then
			next_state <= "001";
			next_leds  <= "001";
			-- else
			-- 	next_state <= "110"; --move to state 6
			-- 	next_leds  <= "111";
			-- end if;
			flags      <= "00";

		elsif (current_state = "101") then --player 2 score
			next_state <= "001";
			next_leds  <= "000";
			flags      <= "10";

		elsif (current_state = "110") then --player 1 score
			next_state <= "011";
			next_leds  <= "111";
			flags      <= "01";

		end if;

	end process;

end Behavioral;