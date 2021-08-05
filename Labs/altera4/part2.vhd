library ieee;
use ieee.std_logic_1164.all;

-- eigth bit wide 2-to-1 1 multiplexer
entity part2 is
	port( SW : in std_logic_vector (17 downto 0);
			LEDR : out std_logic_vector (17 downto 0); -- red led
			LEDG : out std_logic_vector (7 downto 0)); -- green led
end part2;

architecture behavior of part2 is	
	signal s : std_logic_vector(7 downto 0);
	signal x : std_logic_vector(7 downto 0);
	signal y : std_logic_vector(7 downto 0);
begin 
	s <= SW(17)&SW(17)&SW(17)&SW(17)&SW(17)&SW(17)&SW(17)&SW(17);
	x <= SW(7 downto 0);
	y <= SW(15 downto 8); 
	LEDG <= (not s and x)or(s and y);
	LEDR <= SW(17 downto 0);
end behavior;

			