----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/10/2018 01:03:26 PM
-- Design Name: 
-- Module Name: ssd - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssd is
	port (
		-- sw             : in std_logic_vector (3 downto 0);
		clk            : std_logic;
		digit1, digit2 : in std_logic_vector(3 downto 0);
		cat            : out std_logic;
		seg            : out std_logic_vector (6 downto 0));
end ssd;

architecture Behavioral of ssd is

	signal sw       : std_logic_vector(3 downto 0);
	signal catBuf   : std_logic := '0';
	signal clkCount : natural range 0 to 500000;

begin

	cat <= catBuf;

	display : process (clk)
	begin
		if (rising_edge(clk)) then
			if (clkCount = 500000) then
				clkCount <= 0;
				if (catBuf = '1') then
					catBuf <= '0';
					sw     <= digit1;
				else
					catBuf <= '1';
					sw     <= digit2;
				end if;
			else
				clkCount <= clkCount + 1;
			end if;
		end if;
	end process;

	with sw select seg <=
		"1111110" when "0000",
		"0110000" when "0001",
		"1101101" when "0010",
		"1111001" when "0011",
		"0110011" when "0100",
		"1011011" when "0101",
		"1011111" when "0110",
		"1110000" when "0111",
		"1111111" when "1000",
		"1110011" when "1001",
		"1110111" when "1010",
		"0011111" when "1011",
		"1001110" when "1100",
		"0111101" when "1101",
		"1001111" when "1110",
		"1000111" when others;

end Behavioral;