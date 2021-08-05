-----------------------------------------------------------------------------------
-- File name   : lab03.vhd
--
-- Project     : "Helo"
--
-- Description : Driving Seven Segment Display with 7 segment decoder
--
-- Author(s)   : Nash Reilly
--               Montana State University
--
-- Due Date    : February 2, 2011
--
-- Note(s)     : This file contains the Entity and Architecture to create a 7 segment decoder for driving a 7 segment display
--               Concurrent Signal Assignments Statements and Logic Operator
--
------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- 7 segment decoder
ENTITY lab03 IS
	PORT( SW      : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- switch bit vectors
			HEX0    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)); -- red LEDs bit vectors
END lab03;

ARCHITECTURE lab03_arch OF lab03 IS
	BEGIN
	with SW select
		HEX0 <= "0001001" when "000",
				  "0000110" when "001",
				  "1000111" when "010",
				  "1000000" when "011",
				  "1111111" when others;
END lab03_arch;