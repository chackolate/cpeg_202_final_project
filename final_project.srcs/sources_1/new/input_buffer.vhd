----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2022 02:17:02 PM
-- Design Name: 
-- Module Name: input_buffer - Behavioral
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

entity input_buffer is
	port (
		clk          : in std_logic;
		p1           : in std_logic;
		p2           : in std_logic;
		reset_in     : in std_logic;
		game_clk_in  : in std_logic;
		p1Buf        : out std_logic;
		p2Buf        : out std_logic;
		resetBuf_out : out std_logic);
end input_buffer;

architecture Behavioral of input_buffer is

	signal game_clk_d : std_logic;

begin

	clocking : process (clk, game_clk_in, p1, p2, reset_in)
	begin
		if (rising_edge(clk)) then
			game_clk_d <= game_clk_in;
			if ((game_clk_d /= game_clk_in) and game_clk_in = '1') then --fake rising edge detection (cannot use two rising edge statements in one process)
				--reset buffers when game clocks
				p1Buf        <= '0';
				p2Buf        <= '0';
				resetBuf_out <= '0';
			elsif (p1 = '1') then
				p1Buf <= '1';
			elsif (p2 = '1') then
				p2Buf <= '1';
			elsif (reset_in = '1') then
				resetBuf_out <= '1';
			end if;
		end if;
	end process;

end Behavioral;