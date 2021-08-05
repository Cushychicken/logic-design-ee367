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
-- Note(s)     : If/then VHDL instantiation
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
  decoder:process(X)
    begin
      if (X="000") then
        Y<="00000001";
      elsif (X="001") then
        Y<="00000010";
      elsif (X="010") then
        Y<="00000100";
      elsif (X="011") then
        Y<="00001000";
      elsif (X="100") then
        Y<="00010000";
      elsif (X="101") then
        Y<="00100000";
      elsif (X="110") then
        Y<="01000000";
      elsif (X="111") then
        Y<="10000000"; 
      else Y<="ZZZZZZZZ";
      end if;
  end process;
end architecture;
