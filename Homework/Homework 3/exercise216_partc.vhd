-- File name   : exercise216_partc.vhd 
--
-- Project     : Basic Logic 
--
-- Description : VHDL code for a 3-Input Logic Expression
--
-- Author(s)   : Nash Reilly
--
-- Date        : February 4, 2011
--
-- Note(s)     : This file is a logical expression for Part C of the third homework assignment.
--
-----------------------------------------------------------------

library IEEE;                    -- this library adds additional capability for VHDL
use IEEE.STD_LOGIC_1164.ALL;     -- this package has "STD_LOGIC" data types

entity exercise216_partc is
    port(a,b,c         :in  STD_LOGIC;
         y             :out STD_LOGIC);
end entity exercise216_partc;

architecture exercise216_partc_arch of exercise216_partc is
    
    signal int1, int2  :STD_LOGIC;
    
    component xor2
      port(In1,In2     :in  STD_LOGIC;
           Out1        :out STD_LOGIC);
    end component xor2;
    
    component or2
      port(In1,In2     :in  STD_LOGIC;
           Out1        :out STD_LOGIC);
    end component or2;
    
    component and2 is
      port(In1,In2     :in  STD_LOGIC;
           Out1        :out STD_LOGIC);
    end component and2;
    
    begin
      U1: xor2 port map(In1=>a, In2=>b, Out1=>int1);
      U2: or2  port map(In1=>a, In2=>c, Out1=>int2);
      U3: and2 port map(In1=>int1, In2=>int2, Out1=>y);
      
end architecture exercise216_partc_arch;

