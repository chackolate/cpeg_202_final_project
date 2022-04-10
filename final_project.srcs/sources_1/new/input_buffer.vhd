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

	signal buffOut : std_logic_vector(2 downto 0) := "000";

begin

	p1Buf        <= buffOut(0);
	p2Buf        <= buffOut(1);
	resetBuf_out <= buffOut(2);

	clocking : process (clk, game_clk_in, p1, p2, reset_in)
	begin
		if (rising_edge(clk)) then
			if (game_clk_in = '1') then --reset buffers when game clocks
				buffOut(0) <= '0';
				buffOut(1) <= '0';
				buffOut(2) <= '0';
			elsif (p1 = '1') then
				buffOut(0) <= '1';
			elsif (p2 = '1') then
				buffOut(1) <= '1';
			elsif (reset_in = '1') then
				buffOut(2) <= '1';
			end if;
		end if;
	end process;

end Behavioral;