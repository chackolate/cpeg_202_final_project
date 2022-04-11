library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity state_machine_example is
	port (
		clk, reset : in std_logic;
		input1     : in std_logic;
		output1    : out std_logic_vector(1 downto 0)
	);
end state_machine_example;

architecture Behavioral of state_machine_example is

	signal current_state, next_state : std_logic_vector(1 downto 0);

begin

	state_machine : process (clk, reset) --this process ONLY controls current_state every clock cycle
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				current_state <= "00";
			else
				current_state <= next_state;
			end if;
		end if;
	end process;

	outputs : process (current_state, input1) --this process reads current_state and input1 to decide on the next state and output
	begin
		if (current_state = "00") then    --STATE 0
			output1    <= '0';                --no output
			next_state <= "01";               --load state 1
		elsif (current_state = "01") then --STATE 1
			if (input1 = '1') then
				output1    <= '1';  --if input is received in state 1, output 1
				next_state <= "10"; --load state 2
			else                --no input received
				output1    <= '0';
				next_state <= "01"; --loop state 1
			end if;
		elsif (current_state = "10") then --STATE 2
			output1    <= '1';                --always output
			next_state <= "00";               --load state 0
		end if;
	end process;

end Behavioral;