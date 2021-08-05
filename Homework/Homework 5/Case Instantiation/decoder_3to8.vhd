-----------------------------------------------------------------
-- File name   : decoder_3to8.vhd
--
-- Project     : 3 to 8 Decoder
--
-- Description : VHDL 3 to 8 decoder
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--
-- Date        : January 25, 2011
--
-- Note(s)     : Case Statement instantiation
--
-----------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;  

entity decoder_3to8 is
      port  (X      : in  STD_LOGIC_VECTOR(2 downto 0); 
             Y      : out STD_LOGIC_VECTOR(7 downto 0)); 

end entity;

architecture decoder_3to8_arch of decoder_3to8 is
    begin
      decoder : process(X)
        begin
          case(X) is
          when "000"=>Y<="00000001";
          when "001"=>Y<="00000010";
          when "010"=>Y<="00000100";
          when "011"=>Y<="00001000";
          when "100"=>Y<="00010000";
          when "101"=>Y<="00100000";
          when "110"=>Y<="01000000";
          when "111"=>Y<="10000000";
          when others =>Y<="ZZZZZZZZ";
          end case;
        end process;
      end architecture decoder_3to8_arch;
            