-----------------------------------------------------------------------------------
-- File name   : lab05.vhd
--
-- Project     : 4 bit adder
--
-- Description : Using full adder to make 4 bit adder circuit
--
-- Author(s)   : Nash Reilly
--               Montana State University
--
-- Due Date    : February 16, 2011
--
-- Note(s)     : This file contains the Entity and Architecture to create a 7 segment decoder for driving a 7 segment display
--               Concurrent Signal Assignments Statements and Logic Operator
--
------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity lab05 is
	port(SW	:in STD_LOGIC_VECTOR(8 downto 0);
		  LEDG :out STD_LOGIC_VECTOR(4 downto 0);
		  LEDR :out STD_LOGIC_VECTOR(8 downto 0));
end entity;

architecture lab05_arch of lab05 is
	
	signal c1, c2, c3 : STD_LOGIC;
	
	component adder_2bitfull
		port(A,B,Cin :in STD_LOGIC;
			  Cout,S  :out STD_LOGIC);	
	end component;

	begin
		U1: adder_2bitfull port map(A=>SW(0), B=>SW(4), Cin=>SW(8), Cout=>c1, S=>LEDG(1));
		U2: adder_2bitfull port map(A=>SW(1), B=>SW(5), Cin=>c1, Cout=>c2, S=>LEDG(2));
		U3: adder_2bitfull port map(A=>SW(2), B=>SW(6), Cin=>c2, Cout=>c3, S=>LEDG(3));
		U4: adder_2bitfull port map(A=>SW(3), B=>SW(7), Cin=>c3, Cout=>LEDG(0), S=>LEDG(4));
	
		LEDR <= SW;
		
	end architecture;
		