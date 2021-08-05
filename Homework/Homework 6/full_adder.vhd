-----------------------------------------------------------------
-- File name   : Full adder.vhd
--
-- Project     : Full Adder
--
-- Description : VHDL Subcomponent for Ripple Carry Adder
--
-- Author(s)   : Nash Reilly
--               Montana State University
--
-- Date        : February 25, 2011
--
-- Note(s)     : 
--
-----------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;  

entity full_adder is
    port    (A, B, Cin         : in   STD_LOGIC;
             Sum, Cout         : out  STD_LOGIC);
end entity;

architecture full_adder_arch of full_adder is

    signal int_carry1, int_carry2 , int_sum : STD_LOGIC;
    
    component half_adder is
      port    (A, B              : in   STD_LOGIC;
               Sum, Cout         : out  STD_LOGIC);
    end component;
    
    begin
      U1: half_adder port map(A=>A, B=>B, Sum=>int_sum, Cout=>int_carry1);
      U2: half_adder port map(A=>int_sum, B=>Cin, Sum=>Sum, Cout=>int_carry2);
      
      Cout <= int_carry1 or int_carry2;
      
    end architecture;