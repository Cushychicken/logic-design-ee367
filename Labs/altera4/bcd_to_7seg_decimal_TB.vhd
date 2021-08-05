-----------------------------------------------------------------
-- File name   : bcd_to_7seg_decimal_TB.vhd 
--
-- Project     : BCD to 7-Segment Decimal Display Decoder 
--
-- Description : VHDL testbench of BCD to 7-segment display decoder
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

entity bcd_to_7seg_decimal_TB is
end entity bcd_to_7seg_decimal_TB;

architecture bcd_to_7seg_decimal_TB_arch of bcd_to_7seg_decimal_TB is
    
  component bcd_to_7seg_decimal  port  (DEC: out STD_LOGIC_VECTOR(6 downto 0); BCD: in STD_LOGIC_VECTOR(3 downto 0) ); end component;
        
  signal    BCD_int   : STD_LOGIC_VECTOR(3 downto 0);           -- setup internal signals 
  signal    DEC_int   : STD_LOGIC_VECTOR(6 downto 0);           -- setup internal signals 

  begin
      U1 :   bcd_to_7seg_decimal   port map (DEC_int, BCD_int);       --instantiate component we are going to test

      stimulus : process
                  begin
                     BCD_int <= "0000"; wait for 10 ns;
                     BCD_int <= "0001"; wait for 10 ns;
                     BCD_int <= "0010"; wait for 10 ns;
                     BCD_int <= "0011"; wait for 10 ns;                                                               
                                  
                     BCD_int <= "0100"; wait for 10 ns;
                     BCD_int <= "0101"; wait for 10 ns;
                     BCD_int <= "0110"; wait for 10 ns;
                     BCD_int <= "0111"; wait for 10 ns;                                                               

                     BCD_int <= "1000"; wait for 10 ns;
                     BCD_int <= "1001"; wait for 10 ns;
                     BCD_int <= "1010"; wait for 10 ns;
                     BCD_int <= "1011"; wait for 10 ns;                                                               

                     BCD_int <= "1100"; wait for 10 ns;
                     BCD_int <= "1101"; wait for 10 ns;
                     BCD_int <= "1110"; wait for 10 ns;
                     BCD_int <= "1111"; wait for 10 ns;                                                               

      end process stimulus;
      
end architecture bcd_to_7seg_decimal_TB_arch;
