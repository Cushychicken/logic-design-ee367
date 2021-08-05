-----------------------------------------------------------------
-- File name   : half adder.vhd
--
-- Project     : Half Adder
--
-- Description : VHDL Subcomponent for Ripple Carry Adder
--
-- Author(s)   : Nash Reilly
--               Montana State University
--
-- Date        : February 25, 2011
--
-- Note(s)     : Case Statement instantiation
--
-----------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;  

entity half_adder is
    port    (A, B              : in   STD_LOGIC;
             Sum, Cout         : out  STD_LOGIC);
end entity;

architecture half_adder_arch of half_adder is
    begin
      Cout <= A and B;
      Sum  <= A xor B;
    end architecture;
  