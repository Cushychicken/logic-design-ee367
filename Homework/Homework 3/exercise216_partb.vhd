-- File name   : exercise216_partb.vhd 
--
-- Project     : Basic Logic 
--
-- Description : VHDL code for a 3-Input Logic Expression
--
-- Author(s)   : Nash Reilly
--
-- Date        : February 4, 2011
--
-- Note(s)     : This file is a logical expression for Part B of the third homework assignment.
--
-----------------------------------------------------------------

library IEEE;                    -- this library adds additional capability for VHDL
use IEEE.STD_LOGIC_1164.ALL;     -- this package has "STD_LOGIC" data types

entity exercise216_partb is
    port(x, y, z   :in  STD_LOGIC;
         s         :out STD_LOGIC);
end entity exercise216_partb;

architecture exercise216_partb_arch of exercise216_partb is

    signal run :STD_LOGIC_VECTOR(2 downto 0);
         
    begin
      run<=x&y&z;                --Concatenate individual signals into a vector (run) so it doesn't have to do it within "with ... select"
      with run select
        s <= '1' when "000",
             '0' when others;

end architecture exercise216_partb_arch;

