----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2022 01:06:04 PM
-- Design Name: 
-- Module Name: clk1Hz - Behavioral
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

entity clk1Hz is
	port (
		clk_in  : in std_logic;
		reset   : in std_logic;
		clk_out : out std_logic);
end clk1Hz;

architecture Behavioral of clk1Hz is

	signal temporal : std_logic;
	signal counter  : integer range 0 to 62500000 := 0;

begin
	frequency_divider : process (reset, clk_in) begin
		if (reset = '1') then
			temporal <= '0';
			counter  <= 0;
		elsif rising_edge(clk_in) then
			if (counter = 62500000) then
				temporal <= not(temporal);
				counter  <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;
	clk_out <= temporal;

end Behavioral;