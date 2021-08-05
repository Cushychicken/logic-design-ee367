-----------------------------------------------------------------------------------
-- File name   : delay.vhd
--
-- Project     : Delay Circuit for Reaction Timer
--
-- Description : VHDL model of a combinational circuit delay
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

entity delay is
	port(SW     : in std_logic_vector(7 downto 0);
		  Reset	: in std_logic;
		  Clock	: in std_logic;
		  
		  EN_out	: out std_logic);
end entity;
		  
architecture delay_arch of delay is

	signal counter : std_logic_vector(15 downto 0);

begin
	DELAY: process(Clock, Reset, SW)
		begin
			if (Reset = '0') then
				EN_out <= '0';
				counter <= "0000000000000000";
			elsif (Clock'event and Clock = '1') then
				counter <= counter + 1;
				if (SW = "00000001" and counter = 1000) then
					EN_out <= '1';
				elsif (SW = "00000010" and counter = 2000) then
					EN_out <= '1';
				elsif (SW = "00000100" and counter = 3000) then
					EN_out <= '1';
				elsif (SW = "00001000" and counter = 4000) then
					EN_out <= '1';
				elsif (SW = "00010000" and counter = 5000) then
					EN_out <= '1';
				elsif (SW = "00100000" and counter = 6000) then
					EN_out <= '1';
				elsif (SW = "01000000" and counter = 7000) then
					EN_out <= '1';
				elsif (SW = "10000000" and counter = 8000) then
					EN_out <= '1';
				end if;
			end if;
		end process;
								
end architecture;