-----------------------------------------------------------------
-- File name   : exercise216_parta_TB.vhd 
--
-- Project     : Basic Logic 
--
-- Description : VHDL testbench a 3-Input Logic Expression
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : January 25, 2011
--
-- Note(s)     : This file is a test bench
--
-----------------------------------------------------------------
library IEEE;                    -- this library adds additional capability for VHDL
use IEEE.STD_LOGIC_1164.ALL;     -- this package has "STD_LOGIC" data types

entity exercise216_parta_TB is
end entity exercise216_parta_TB;

architecture exercise216_parta_TB_arch of exercise216_parta_TB is
    
  component exercise216_parta  port  (m: out STD_LOGIC; a: in STD_LOGIC; b: in STD_LOGIC; c: in STD_LOGIC); end component;
        
  signal    a_int   : STD_LOGIC;                  -- setup internal signals 
  signal    b_int   : STD_LOGIC;                  -- setup internal signals 
  signal    c_int   : STD_LOGIC;                  -- setup internal signals 
  signal    m_int   : STD_LOGIC;                  -- setup internal signals 

  begin
      U1 :   exercise216_parta   port map (m_int, a_int, b_int, c_int);       --instantiate component we are going to test

      stimulus : process
                  begin
                     a_int <= '0';   b_int <= '0';   c_int <= '0';   wait for 10 ns;
                     a_int <= '0';   b_int <= '0';   c_int <= '1';   wait for 10 ns;
                     a_int <= '0';   b_int <= '1';   c_int <= '0';   wait for 10 ns;
                     a_int <= '0';   b_int <= '1';   c_int <= '1';   wait for 10 ns;                                                               
                     a_int <= '1';   b_int <= '0';   c_int <= '0';   wait for 10 ns;
                     a_int <= '1';   b_int <= '0';   c_int <= '1';   wait for 10 ns;
                     a_int <= '1';   b_int <= '1';   c_int <= '0';   wait for 10 ns;
                     a_int <= '1';   b_int <= '1';   c_int <= '1';   wait for 10 ns;                                                               
                                  
      end process stimulus;
      
end architecture exercise216_parta_TB_arch;
