-----------------------------------------------------------------------------------
-- File name   : lab02.vhd
--
-- Project     : Switches
--
-- Description : Connecting Red LEDs to Switches
--
-- Author(s)   : Nash Reilly
--               Montana State University
--
-- Due Date    : January 28, 2011
--
-- Note(s)     : This file contains the Entity and Architecture for connecting the Red LEDs on the Quartus 2 board to the toggle switches
--               The logic function is described using
--               Concurrent Signal Assignments Statements and Logic Operator
--
------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Simple module that connects the SW switches to the LEDR lights
ENTITY lab02 IS
	PORT( SW   : IN  STD_LOGIC_VECTOR(17 DOWNTO 0);  -- switch bit vectors
			LEDR : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)); -- red LEDs bit vectors
END lab02;

ARCHITECTURE lab02_arch OF lab02 IS
	BEGIN
		LEDR <= SW;
END lab02_arch;