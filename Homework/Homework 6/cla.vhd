-----------------------------------------------------------------
-- File name   : cla.vhd
--
-- Project     : Carry Look Ahead Adder
--
-- Description : Top level VHDL for CLA Adder
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

entity cla is
    port    (A, B        : in   STD_LOGIC_VECTOR (3 downto 0);
             Sum         : out  STD_LOGIC_VECTOR (3 downto 0);
             Cout        : out  STD_LOGIC);
end entity;

architecture cla_arch of cla is 

signal G,P,C          : STD_LOGIC_VECTOR(3 downto 0);
signal c_out1, c_out2 : STD_LOGIC;

  component full_adder is
      port    (A, B, Cin         : in   STD_LOGIC;
               Sum, Cout         : out  STD_LOGIC);
  end component;

begin
G(0) <= A(0) and B(0);
G(1) <= A(1) and B(1);
G(2) <= A(2) and B(2);
G(3) <= A(3) and B(3);

P(0) <= A(0) xor B(0);
P(1) <= A(1) xor B(1);
P(2) <= A(2) xor B(2);
P(3) <= A(3) xor B(3);

C(0) <= '0';
C(1) <= G(0) or (P(0) and C(0));
C(2) <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and C(0)); 
C(3) <= G(2) or (P(2) and P(1) and G(0)) or (P(2) and P(1) and P(0) and C(0));
c_out1 <= G(3) or (P(3) and P(2) and G(1)) or (P(3) and P(2) and P(1) and G(0)) or (P(3) and P(2) and P(1) and P(0) and C(0));

U1: full_adder port map(A=>A(0), B=>B(0), Cin=>C(0), Sum=>Sum(0));
U2: full_adder port map(A=>A(1), B=>B(1), Cin=>C(1), Sum=>Sum(1));
U3: full_adder port map(A=>A(2), B=>B(2), Cin=>C(2), Sum=>Sum(2));
U4: full_adder port map(A=>A(3), B=>B(3), Cin=>C(3), Sum=>Sum(3), Cout=>c_out2);

Cout <= (c_out1 or c_out2); 
    
end architecture;