-- File name   : bcd_to_7seg.vhd 
--
-- Project     : BCD to 7 segment decoder 
--
-- Description : VHDL code for a decoder for a 7 segment display driver from a BCD code
--
-- Author(s)   : Nash Reilly
--
-- Date        : February 4, 2011
--
-- Note(s)     : This file is a logical expression for Part A of the third homework assignment.
--
-----------------------------------------------------------------

library IEEE;                    -- this library adds additional capability for VHDL
use IEEE.STD_LOGIC_1164.ALL;     -- this package has "STD_LOGIC" data types

entity bcd_to_7seg is 
  port(BCD : in STD_LOGIC_VECTOR(3 downto 0);
       DEC : out STD_LOGIC_VECTOR(6 downto 0));
  
end entity;

architecture bcd_to_7seg_arch of bcd_to_7seg is 
  begin
    encoder: process(BCD)
      begin
        case(BCD) is 
        when "0000"=> DEC <="1000000";
        when "0001"=> DEC <="1111001";
        when "0010"=> DEC <="0100100";
        when "0011"=> DEC <="0110000";
        when "0100"=> DEC <="0011001";
        when "0101"=> DEC <="0010010";
        when "0110"=> DEC <="0000010";
        when "0111"=> DEC <="1111000";
        when "1000"=> DEC <="0000000";
        when "1001"=> DEC <="0011000";
        when others => DEC <="1111111";
        end case;
      end process encoder;
    end architecture bcd_to_7seg_arch;
        
      