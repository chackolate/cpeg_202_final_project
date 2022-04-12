----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2022 02:32:09 PM
-- Design Name: 
-- Module Name: pong_main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pong_main is
	port (
		clk     : in std_logic;
		reset   : in std_logic;
		player1 : in std_logic;
		player2 : in std_logic;
		sw      : in std_logic;
		led     : out std_logic_vector (7 downto 0);
		seg     : out std_logic_vector (6 downto 0);
		cat     : out std_logic);
end pong_main;

architecture Behavioral of pong_main is

	component clk_div is
		port (
			clk_in  : in std_logic; -- input clock
			reset   : in std_logic; -- asynchronous reset
			sw      : in std_logic; -- select signal to control multiplexer between 1hz and 2hz
			clk_out : out std_logic -- output clock
		);
	end component;
	signal game_clk : std_logic;

	component input_buffer is
		port (
			clk          : in std_logic;
			p1           : in std_logic;
			p2           : in std_logic;
			reset_in     : in std_logic;
			game_clk_in  : in std_logic;
			p1Buf        : out std_logic;
			p2Buf        : out std_logic;
			resetBuf_out : out std_logic);
	end component;
	signal p1Buf, p2Buf, resetBuf : std_logic;

	component pong_controller is
		port (
			clk              : in std_logic;
			reset            : in std_logic;
			p1Buf, p2Buf     : in std_logic;                      --player inputs
			-- sw               : in std_logic_vector(3 downto 0);
			state            : out std_logic_vector (3 downto 0); --state value for SSD
			p1Score, p2Score : out std_logic_vector (3 downto 0);
			led              : out std_logic_vector(2 downto 0)); --control for led module
	end component;
	signal state            : std_logic_vector(3 downto 0);
	signal led_array        : std_logic_vector(2 downto 0);
	signal p1Score, p2Score : std_logic_vector(3 downto 0);

	component clk60Hz is
		port (
			clk_in  : in std_logic;
			reset   : in std_logic;
			clk_out : out std_logic);
	end component;
	signal display_clk : std_logic;

	component mux2to1_4bit is
		port (
			I0  : in std_logic_vector(3 downto 0);
			I1  : in std_logic_vector(3 downto 0);
			sel : in std_logic;
			Y   : out std_logic_vector(3 downto 0)
		);
	end component;
	signal ssd_in : std_logic_vector(3 downto 0);

	component ssd is
		port (
			sw  : in std_logic_vector (3 downto 0);
			seg : out std_logic_vector (6 downto 0));
	end component;

	component leds is
		port (
			led_array : in std_logic_vector(2 downto 0);
			led       : out std_logic_vector(7 downto 0));
	end component;

begin

	CLKDIV0 : clk_div port map(
		clk_in  => clk,
		reset   => reset,
		sw      => sw,
		clk_out => game_clk
	);

	IBUF0 : input_buffer port map(
		clk          => clk,
		p1           => player1,
		p2           => player2,
		reset_in     => reset,
		game_clk_in  => game_clk,
		p1Buf        => p1Buf,
		p2Buf        => p2Buf,
		resetBuf_out => resetBuf
	);

	CTRL0 : pong_controller port map(
		clk     => game_clk,
		reset   => resetBuf,
		p1Buf   => '1',
		p2Buf   => '1',
		state   => state,
		p1Score => p1Score,
		p2Score => p2Score,
		led     => led_array
	);

	CLKDIV60 : clk60Hz port map(
		clk_in  => clk,
		reset   => reset,
		clk_out => display_clk
	);
	cat <= display_clk;

	MUX0 : mux2to1_4bit port map(
		I0  => state,
		I1  => "0000",
		sel => display_clk,
		Y   => ssd_in
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