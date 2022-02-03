library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pong_full is
	port (
		clk, reset       : in std_logic;
		player1, player2 : in std_logic;
		led              : out std_logic_vector (7 downto 0);
		seg              : out std_logic_vector (6 downto 0);
		cat              : out std_logic);
end pong_full;

architecture Behavioral of pong_full is

	component pong_controller is
		port (
			clk              : in std_logic;
			reset            : in std_logic;
			player1, player2 : in std_logic;                      --player inputs
			state            : out std_logic_vector (3 downto 0); --state value for SSD
			led              : out std_logic_vector(2 downto 0)); --output state value for SSD
	end component;
	signal state, notstate : std_logic_vector(3 downto 0);
	signal led_array       : std_logic_vector(2 downto 0);

	component ssd is
		port (
			clk            : std_logic;
			digit1, digit2 : in std_logic_vector(3 downto 0);
			cat            : out std_logic;
			seg            : out std_logic_vector (6 downto 0));
	end component;

	component leds is
		port (
			led_array : in std_logic_vector(2 downto 0);
			led       : out std_logic_vector(7 downto 0));
	end component;

begin

	notstate <= not state;

	CTRL0 : pong_controller port map(
		clk     => clk,
		reset   => reset,
		player1 => player1,
		player2 => player2,
		state   => state,
		led     => led_array
	);

	SSD0 : ssd port map(
		clk    => clk,
		digit1 => state,
		digit2 => notstate,
		cat    => cat,
		seg    => seg
	);

	LED0 : leds port map(
		led_array => led_array,
		led       => led
	);

end Behavioral;