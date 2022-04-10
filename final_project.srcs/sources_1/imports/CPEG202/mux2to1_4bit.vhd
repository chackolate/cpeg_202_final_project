----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2022 11:16:00 AM
-- Design Name: 
-- Module Name: mux2to1_4bit - Behavioral
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

entity mux2to1_4bit is
	port (
		I0  : in std_logic_vector(3 downto 0);
		I1  : in std_logic_vector(3 downto 0);
		sel : in std_logic;
		Y   : out std_logic_vector(3 downto 0)
	);
end mux2to1_4bit;

architecture Behavioral of mux2to1_4bit is

begin

	with sel select
		Y <= I0 when '0',
		I1 when '1',
		"0000" when others;
end Behavioral;