library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity clk_div is
	port (
		clk_in           : in std_logic;  -- input clock
		reset            : in std_logic;  -- asynchronous reset
		sw               : in std_logic;  -- select signal to control multiplexer between 1hz and 2hz
		player1, player2 : in std_logic;  --button 1 & 2 for player inputs
		p1Buf, p2Buf     : out std_logic; --player input buffer for state machine to read
		clk_out          : out std_logic  -- output clock
	);
end clk_div;

architecture Behavioral of clk_div is

	component clk1Hz
		port (
			clk_in  : in std_logic; -- input clock
			reset   : in std_logic; -- asynchronous reset
			clk_out : out std_logic -- output clock
		);
	end component;

	component clk2Hz
		port (
			clk_in  : in std_logic; -- input clock
			reset   : in std_logic; -- asynchronous reset
			clk_out : out std_logic -- output clock
		);
	end component;

	-- multiplexer component
	component mux2to1 is
		port (
			I0  : in std_logic; -- input one
			I1  : in std_logic; -- input two
			sel : in std_logic; -- selector  
			Y   : out std_logic -- output
		);
	end component;

	signal clk_count_1Hz : std_logic;
	signal clk_count_2Hz : std_logic;

	signal clkOutSignal  : std_logic;

begin

	inputs : process (clk_in, clkOutSignal)
	begin
		if (rising_edge(clk_in)) then --125 MHz
			if (reset = '1') then
				p1Buf <= '0';
				p2Buf <= '0';
			elsif (clkOutSignal = '1') then --game clock cycle has ended, reset input buffers
				p1Buf <= '0';
				p2Buf <= '0';
			elsif (player1 = '1') then --fill p1 buffer
				p1Buf <= '1';
			elsif (player2 = '1') then --fill p2 buffer
				p2Buf <= '1';
			end if;
		end if;
	end process;

	-- 1mhz clock divider
	div_1 : clk1Hz port map(
		clk_in  => clk_in,
		reset   => reset,
		clk_out => clk_count_1Hz
	);

	-- 2mhz clock divider
	div_2 : clk2Hz port map(
		clk_in  => clk_in,
		reset   => reset,
		clk_out => clk_count_2Hz
	);

	-- multiplexer to choose between clock dividers
	muxl : mux2to1 port map(
		I0  => clk_count_1Hz,
		I1  => clk_count_2Hz,
		sel => sw,
		Y   => clkOutSignal
	);

	clk_out <= clkOutSignal;

end Behavioral;