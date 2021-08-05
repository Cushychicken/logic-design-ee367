-----------------------------------------------------------------------------------
-- File name   : nor2.vhd
--
-- Project     : Basic Gates
--
-- Description : VHDL model of a 2 input NOR gate 
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

entity nor2 is
    
    port   (In1, In2       : in   STD_LOGIC;
            Out1           : out  STD_LOGIC);
            
end entity nor2;


architecture nor2_arch of nor2 is
begin

        Out1 <= In1 nor In2;

end architecture nor2_arch;

--  component nor2  port  (In1,In2: in STD_LOGIC; Out1: out STD_LOGIC); end component;  
