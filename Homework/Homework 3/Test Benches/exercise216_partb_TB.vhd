-----------------------------------------------------------------
-- File name   : exercise216_partb_TB.vhd 
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

entity exercise216_partb_TB is
end entity exercise216_partb_TB;

architecture exercise216_partb_TB_arch of exercise216_partb_TB is
    
  component exercise216_partb  port  (s: out STD_LOGIC; x: in STD_LOGIC; y: in STD_LOGIC; z: in STD_LOGIC); end component;
        
  signal    x_int   : STD_LOGIC;                  -- setup internal signals 
  signal    y_int   : STD_LOGIC;                  -- setup internal signals 
  signal    z_int   : STD_LOGIC;                  -- setup internal signals 
  signal    s_int   : STD_LOGIC;                  -- setup internal signals 

  begin
      U1 :   exercise216_partb   port map (s_int, x_int, y_int, z_int);       --instantiate component we are going to test

      stimulus : process
                  begin
                     x_int <= '0';   y_int <= '0';   z_int <= '0';   wait for 10 ns;
                     x_int <= '0';   y_int <= '0';   z_int <= '1';   wait for 10 ns;
                     x_int <= '0';   y_int <= '1';   z_int <= '0';   wait for 10 ns;
                     x_int <= '0';   y_int <= '1';   z_int <= '1';   wait for 10 ns;                                                               
                     x_int <= '1';   y_int <= '0';   z_int <= '0';   wait for 10 ns;
                     x_int <= '1';   y_int <= '0';   z_int <= '1';   wait for 10 ns;
                     x_int <= '1';   y_int <= '1';   z_int <= '0';   wait for 10 ns;
                     x_int <= '1';   y_int <= '1';   z_int <= '1';   wait for 10 ns;                                                               
                                  
      end process stimulus;
      
end architecture exercise216_partb_TB_arch;
