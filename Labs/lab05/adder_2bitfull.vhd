-----------------------------------------------------------------------------------
-- File name   : adder_2bitfull.vhd
--
-- Project     : Lab 05 subcomponent
--
-- Description : Full adder vhdl file
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

entity adder_2bitfull is
  port(A,B,Cin :in STD_LOGIC;
      Cout,S  :out STD_LOGIC);
end entity;

architecture adder_2bitfull_arch of adder_2bitfull is
  begin
    S <= (A xor B) xor Cin;
    Cout <= (Cin and A) or (A and B) or (Cin and B);
  end architecture;
  