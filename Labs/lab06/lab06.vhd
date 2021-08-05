-----------------------------------------------------------------------------------
-- File name   : lab06.vhd
--
-- Project     : Lab 06 top file
--
-- Description : bcd adder with displays
--
-- Author(s)   : Nash Reilly
--					  Midhat Feidi
--               Montana State University
--
-- Due Date    : February 23, 2011
--
-- Note(s)     : This file contains the Entity and Architecture to create a 7 segment decoder for driving a 7 segment display
--               Concurrent Signal Assignments Statements and Logic Operator
--
------------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity lab06 is
	port(SW	:in STD_LOGIC_VECTOR(8 downto 0);
		  LEDG :out STD_LOGIC_VECTOR(4 downto 0);
		  LEDR :out STD_LOGIC_VECTOR(8 downto 0);
		  HEX6, HEX4, HEX1, HEX0 : out std_logic_vector(6 downto 0));
end entity;

architecture lab06_arch of lab06 is
	
	signal c1, c2, c3 : STD_LOGIC;
	signal SUM			: STD_LOGIC_VECTOR(4 downto 0);
	
	component adder_2bitfull is
		port(A,B,Cin :in STD_LOGIC;
			  Cout,S  :out STD_LOGIC);	
	end component;

	component bcd_to_7seg is 
		port(BCD : in STD_LOGIC_VECTOR(3 downto 0);
			  DEC : out STD_LOGIC_VECTOR(6 downto 0));
	end component;
		 	 
	
	begin
		U1: adder_2bitfull port map(A=>SW(0), B=>SW(4), Cin=>SW(8), Cout=>c1, S=>SUM(0));
		U2: adder_2bitfull port map(A=>SW(1), B=>SW(5), Cin=>c1, Cout=>c2, S=>SUM(1));
		U3: adder_2bitfull port map(A=>SW(2), B=>SW(6), Cin=>c2, Cout=>c3, S=>SUM(2));
		U4: adder_2bitfull port map(A=>SW(3), B=>SW(7), Cin=>c3, Cout=>SUM(4), S=>SUM(3));
	   U5: bcd_to_7seg 	 port map(BCD=>SW(3 downto 0),DEC=>HEX6);
		U6: bcd_to_7seg 	 port map(BCD=>SW(7 downto 4),DEC=>HEX4);
		
		LEDR <= SW;
		LEDG <= SUM;
		
		declsb: process(SUM)
			begin
				case(SUM) is
				when "00000" => HEX0 <="1000000";
				when "00001" => HEX0 <="1111001";
				when "00010" => HEX0 <="0100100";
				when "00011" => HEX0 <="0110000";
				when "00100" => HEX0 <="0011001";
				when "00101" => HEX0 <="0010010";
				when "00110" => HEX0 <="0000010";
				when "00111" => HEX0 <="1111000";
				when "01000" => HEX0 <="0000000";
				when "01001" => HEX0 <="0011000";
				when "01010" => HEX0 <="1000000";
				when "01011" => HEX0 <="1111001";
				when "01100" => HEX0 <="0100100";
				when "01101" => HEX0 <="0110000";
				when "01110" => HEX0 <="0011001";
				when "01111" => HEX0 <="0010010";
				when "10000" => HEX0 <="0000010";
				when "10001" => HEX0 <="1111000";
				when "10010" => HEX0 <="0000000";
				when "10011" => HEX0 <="0011000";
				when others => HEX0  <="1111111";
			end case;
			
		end process;
	
		decmsb: process(SUM)
			begin
				case(SUM) is
				when "00000" => HEX1 <="1000000";
				when "00001" => HEX1 <="1000000";
				when "00010" => HEX1 <="1000000";
				when "00011" => HEX1 <="1000000";
				when "00100" => HEX1 <="1000000";
				when "00101" => HEX1 <="1000000";
				when "00110" => HEX1 <="1000000";
				when "00111" => HEX1 <="1000000";
				when "01000" => HEX1 <="1000000";
				when "01001" => HEX1 <="1000000";
				when "01010" => HEX1 <="1111001";
				when "01011" => HEX1 <="1111001";
				when "01100" => HEX1 <="1111001";
				when "01101" => HEX1 <="1111001";
				when "01110" => HEX1 <="1111001";
				when "01111" => HEX1 <="1111001";
				when "10000" => HEX1 <="1111001";
				when "10001" => HEX1 <="1111001";
				when "10010" => HEX1 <="1111001";
				when "10011" => HEX1 <="1111001";
				when others => HEX1  <="1111111";
			end case;
			
		end process;	
				
		
	end architecture;
