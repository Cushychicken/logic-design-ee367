-- File name   : exercise216_parta.vhd 
--
-- Project     : Basic Logic 
--
-- Description : VHDL code for a 3-Input Logic Expression
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

entity exercise216_parta is
    port(a,b,c    :in  STD_LOGIC;
         m        :out STD_LOGIC);
end entity exercise216_parta;

architecture exercise216_parta_arch of exercise216_parta is
    begin
      m <= (a and b) or (b and c) or (a and c);

end architecture exercise216_parta_arch;
