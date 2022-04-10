library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity clk_div is
	port (
		clk_in  : in std_logic; -- input clock
		reset   : in std_logic; -- asynchronous reset
		sw      : in std_logic; -- select signal to control multiplexer between 1hz and 2hz
		clk_out : out std_logic -- output clock
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