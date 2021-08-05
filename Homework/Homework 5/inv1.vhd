-----------------------------------------------------------------------------------
-- File name   : inv1.vhd
--
-- Project     : Basic Gates
--
-- Description : VHDL model of a 1 input Buffer 
--
-- Author(s)   : Nash Reilly
--               Montana State University
--
-- Due Date    : January 28, 2011
--
-- Note(s)     : This file contains the Entity and Architecture
--               The logic function is described using
--               Concurrent Signal Assignments Statements and Logic Operator
--
------------------------------------------------------------------------------------
library IEEE;                    -- this library adds additional capability for VHDL
use IEEE.STD_LOGIC_1164.ALL;     -- this package has "STD_LOGIC" data types

entity inv1 is
    
    port   (In1       : in   STD_LOGIC;
            Out1      : out  STD_LOGIC);
            
end entity inv1;


architecture inv1_arch of inv1 is
begin

        Out1 <= not In1;

end architecture inv1_arch;
