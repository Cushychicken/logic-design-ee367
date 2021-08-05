-- File name   : xor2.vhd 
--
-- Project     : Basic Logic
--
-- Description : VHDL code for a 2 input xor gate
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

entity xor2 is
    port(In1,In2     :in  STD_LOGIC;
         Out1        :out STD_LOGIC);
end entity xor2;

architecture xor2_arch of xor2 is
    begin
      Out1 <= (In1 xor In2);

end architecture xor2_arch;
