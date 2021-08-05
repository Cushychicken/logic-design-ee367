------------------------------------------------------------------------------------------------------------
-- File name   : dff.vhd
--
-- Project     : EE367 - Logic Design
--
-- Description : VHDL model of a D-Flip-Flop with asynchronous reset
--
-- Author(s)   : Nash Reilly
--               lameres@ece.montana.edu
--
-- Date        : March 9, 2011
--
-- Note(s)     : 
--
------------------------------------------------------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;     

entity dflipflop is
    port   (Clock           : in   STD_LOGIC;
            Reset           : in   STD_LOGIC;
            D               : in   STD_LOGIC;
            Q, Qn           : out  STD_LOGIC);
end entity dflipflop;


architecture dff_arch of dflipflop is

  begin

    dff : process (Clock, Reset)
       begin
		    if (Reset = '0') then
		             Q <= '0'; Qn <= '1';
          elsif (Clock'event and Clock='1') then
                   Q <= D;   Qn <= not D;
          end if;
          
       end process dff;
       
end architecture dff_arch;