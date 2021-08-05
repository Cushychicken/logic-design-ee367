-- File name   : and3.vhd 
--
-- Project     : Basic Logic
--
-- Description : VHDL code for a 2 input and gate
--
-- Author(s)   : Nash Reilly
--
-- Date        : February 4, 2011
--
-- Note(s)     : This file is a component for part C of homework 3.
--
-----------------------------------------------------------------

library IEEE;                    -- this library adds additional capability for VHDL
use IEEE.STD_LOGIC_1164.ALL;     -- this package has "STD_LOGIC" data types

entity and3 is
    port(In1,In2,In3     :in  STD_LOGIC;
         Out1            :out STD_LOGIC);
end entity and3;

architecture and3_arch of and3 is
    begin
      Out1 <= (In1 and In2 and In3);

end architecture and3_arch;

