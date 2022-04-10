library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pong_full is
	port (
		clk, reset       : in std_logic;
		player1, player2 : in std_logic;
		sw               : in std_logic_vector(3 downto 0);
		led              : out std_logic_vector (7 downto 0);
		seg              : out std_logic_vector (6 downto 0);
		cat              : out std_logic);
end pong_full;

architecture Behavioral of pong_full is

	component clk_div is
		port (
			clk_in           : in std_logic;  -- input clock
			reset            : in std_logic;  -- asynchronous reset
			sw               : in std_logic;  -- select signal to control multiplexer between 1hz and 2hz
			player1, player2 : in std_logic;  --button 1 & 2 for player inputs
			p1Buf, p2Buf     : out std_logic; --player input buffer for state machine to read
			clk_out          : out std_logic  -- output clock
		);
	end component;
	signal clk_out      : std_logic;
	signal p1Buf, p2Buf : std_logic;

	component pong_controller is
		port (
			clk              : in std_logic;
			reset            : in std_logic;
			-- sw               : in std_logic_vector(3 downto 0);
			player1, player2 : in std_logic;                      --player inputs
			state            : out std_logic_vector (3 downto 0); --state value for SSD
			p1Score, p2Score : out integer range 0 to 9 := 0;
			led              : out std_logic_vector(2 downto 0)); --output state value for SSD
	end component;
	signal state, notstate  : std_logic_vector(3 downto 0);
	signal led_array        : std_logic_vector(2 downto 0);
	signal p1Score, p2Score : integer range 0 to 9 := 0;
	signal score1, score2   : std_logic_vector(3 downto 0);

	component mux2to1_4bit is
		port (
			I0  : in std_logic_vector(3 downto 0); --player 1 score
			I1  : in std_logic_vector(3 downto 0); --player 2 score
			sel : in std_logic;
			Y   : out std_logic_vector(3 downto 0)
		);
	end component;

	component clk60Hz is
		port (
			clk_in  : in std_logic;
			reset   : in std_logic;
			clk_out : out std_logic);
	end component;
	signal clkOut60 : std_logic;

	component ssd is
		port (
			sw  : in std_logic_vector(3 downto 0);
			seg : out std_logic_vector (6 downto 0));
	end component;
	signal ssd_in : std_logic_vector(3 downto 0);

	component leds is
		port (
			led_array : in std_logic_vector(2 downto 0);
			led       : out std_logic_vector(7 downto 0));
	end component;

begin

	-- notstate <= not state;

	CLKDIV0 : clk_div
	port map(
		clk_in  => clk,     --system clock
		reset   => reset,   --system reset
		sw      => sw,      --switch port 1hz/2hz
		player1 => player1, --button1 port
		player2 => player2, --button2 port
		p1Buf   => p1Buf,   --player1 buffer output
		p2Buf   => p2Buf,   --player2 buffer output
		clk_out => clk_out  --1/2hz clock out
	);

	CTRL0 : pong_controller
	port map(
		clk     => clk_out,  --1/2hz clock in
		reset   => reset,    --system reset
		player1 => p1Buf,    --player1 buffer input from clk_div
		player2 => p2Buf,    --player2 buffer input from clk_div
		state   => state,    --4 bit state signal (internal)
		p1Score => p1Score,  --player 1 score output (integer)
		p2Score => p2Score,  --player 2 score output (integer)
		led     => led_array --led state output
	);

	CLK60 : clk60Hz port map(
		clk_in  => clk,     --system clock
		reset   => reset,   --system reset
		clk_out => clkOut60 --60hz clock out
	);
	cat <= clkOut60; --switch CAT digit in time with 60hz display refresh

	MUX0 : mux2to1_4bit port map(
		I0  => state,    --4 bit state signal
		I1  => "0000",   --empty digit
		sel => clkOut60, --60hz switching
		Y   => ssd_in    --output to SSD
	);

	SSD0 : ssd port map(
		sw  => ssd_in,
		seg => seg
	);

	LED0 : leds port map(
		led_array => led_array,
		led       => led
	);

end Behavioral;