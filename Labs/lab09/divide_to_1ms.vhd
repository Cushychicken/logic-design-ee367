-----------------------------------------------------------------------------------
-- File name   : divide_to_1ms.vhd
--
-- Project     : Reaction Timer
--
-- Description : VHDL model of a reaction timer
--
-- Author(s)   : Nash Reilly
--               Montana State University
--
-- Date        : March 23, 2011
--
-- Note(s)     : 
--
------------------------------------------------------------------------------------
LIBRARY ieee ;
USE IEEE.STD_LOGIC_1164.ALL ;
use IEEE.STD_LOGIC_ARITH.ALL;    --  
use IEEE.STD_LOGIC_UNSIGNED.ALL; --

entity divide_to_1ms is
	port(clk_in : in std_logic;
		  Reset	: in std_logic;
		  clk_out: out std_logic);
end entity;

architecture divide_to_1ms_arch of divide_to_1ms is

signal counter  : std_logic_vector(15 downto 0);
signal clk_hold : std_logic;

	begin

	clk_out <= clk_hold;
	
	DIVIDE : process (clk_in, Reset)
		begin
			if (Reset = '0') then
				counter <= "0000000000000000";
				clk_hold <= '0';
			elsif(clk_in'event and clk_in='1') then
				if(counter = 25000) then
					clk_hold <= not clk_hold;
					counter  <= "0000000000000000";
				else 
					counter <= counter + 1;
				end if;
			end if;
		end process;
end architecture;