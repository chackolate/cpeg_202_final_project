----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2022 02:32:24 PM
-- Design Name: 
-- Module Name: pong - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pong is
	port (
		clk, reset           : in std_logic;
		sw, player1, player2 : in std_logic;
		led                  : out std_logic_vector (7 downto 0);
		seg                  : out std_logic_vector (6 downto 0);
		cat                  : out std_logic);
end pong;

architecture Structural of pong is

	component ssd is
		port (
			sw  : in std_logic_vector (3 downto 0);
			seg : out std_logic_vector (6 downto 0));
	end component;

	component leds is
		port (
			led_array : in std_logic_vector (2 downto 0);
			led       : out std_logic_vector (7 downto 0));
	end component;

	signal clk_count       : integer := 0;
	signal maximum         : integer := 125000000;
	signal ssd_count       : std_logic_vector(3 downto 0);
	signal state           : integer := 0;
	signal led_array       : std_logic_vector (2 downto 0);
	signal current_led     : std_logic_vector (2 downto 0);
	signal p1Count         : std_logic_vector(3 downto 0)  := "0000";
	signal p2Count         : std_logic_vector (3 downto 0) := "0000";
	signal digitClockCount : natural range 0 to 500000;
	signal digit           : std_logic;

begin

	ssd1  : ssd port map(sw => ssd_count, seg => seg);
	leds1 : leds port map(led_array => led_array, led => led);

	process (clk, reset) begin
		current_led <= led_array;
		if (reset = '1') then
			state     <= 0;
			p1Count   <= "0000";
			p2Count   <= "0000";
			led_array <= "000";
		end if;

		if (clk'event and clk = '1') then
			clk_count <= clk_count + 1;
			if (clk_count = maximum) then
				clk_count <= 0;
				if (state = 0) then
					-- LEDs scrolling left to right
					led_array <= std_logic_vector(unsigned(led_array) + 1);
					if (current_led = "111" and state = 0) then
						if (player1 = '1') then
							state     <= 1;
							led_array <= "110";
						else
							p2Count <= std_logic_vector(unsigned(p2Count) + 1);
						end if;
					end if;
				else
					-- LEDs scrolling right to left
					led_array <= std_logic_vector(unsigned(led_array) - 1);
					if (current_led = "000" and state = 1) then
						if (player2 = '1') then
							state     <= 0;
							led_array <= "001";
						else
							p1Count <= std_logic_vector(unsigned(p1Count) + 1);
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	process (clk)
	begin
		if (rising_edge(clk)) then
			if (digitClockCount = 500000) then
				digitClockCount <= 0; --reset digit count
				if (digit = '1') then
					digit     <= '0';
					ssd_count <= p1Count;
				else
					digit     <= '1';
					ssd_count <= p2Count;
				end if;
			else
				digitClockCount <= digitClockCount + 1;
			end if;
		end if;
	end process;

	cat <= digit;

end Structural;