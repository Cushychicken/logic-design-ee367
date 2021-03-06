-----------------------------------------------------------------
-- File name   : rca.vhd
--
-- Project     : Ripple Carry Adder
--
-- Description : Top level VHDL for Ripple Carry Adder
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

entity rca is
    port    (A, B        : in   STD_LOGIC_VECTOR (3 downto 0);
             Sum         : out  STD_LOGIC_VECTOR (3 downto 0);
             Cout        : out  STD_LOGIC);
end entity;

architecture rca_arch of rca is

  signal c1, c2, c3 : STD_LOGIC;

  component full_adder is
      port    (A, B, Cin         : in   STD_LOGIC;
               Sum, Cout         : out  STD_LOGIC);
  end component;

  begin
    U1: full_adder port map(A=>A(0), B=>B(0), Cin=>'0', Sum=>Sum(0), Cout=>c1);
    U2: full_adder port map(A=>A(1), B=>B(1), Cin=>c1, Sum=>Sum(1), Cout=>c2);
    U3: full_adder port map(A=>A(2), B=>B(2), Cin=>c2, Sum=>Sum(2), Cout=>c3);
    U4: full_adder port map(A=>A(3), B=>B(3), Cin=>c3, Sum=>Sum(3), Cout=>Cout);
    
end architecture;