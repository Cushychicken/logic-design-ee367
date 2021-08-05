-- File name   : or2.vhd 
--
-- Project     : Basic Logic
--
-- Description : VHDL code for a 2 input or gate
--
-- Author(s)   : Nash Reilly
--
-- Date        : February 4, 2011
--
-- Note(s)     : This file is a component for part 3 of homework 3.
--
-----------------------------------------------------------------

library IEEE;                    -- this library adds additional capability for VHDL
use IEEE.STD_LOGIC_1164.ALL;     -- this package has "STD_LOGIC" data types

entity or2 is
    port(In1,In2     :in  STD_LOGIC;
         Out1        :out STD_LOGIC);
end entity or2;

architecture or2_arch of or2 is
    begin
      Out1 <= (In1 or In2);

end architecture or2_arch;

