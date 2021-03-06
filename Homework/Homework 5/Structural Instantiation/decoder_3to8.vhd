-----------------------------------------------------------------
-- File name   : decoder_3to8.vhd
--
-- Project     : 3 to 8 Decoder
--
-- Description : VHDL 3 to 8 decoder
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--
-- Date        : January 25, 2011
--
-- Note(s)     : Structural VHDL instantiation
--
-----------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;  

entity decoder_3to8 is
      port  (X      : in  STD_LOGIC_VECTOR(2 downto 0); 
             Y      : out STD_LOGIC_VECTOR(7 downto 0)); 
end entity;

architecture decoder_3to8_arch of decoder_3to8 is 
  
  signal X_n: STD_LOGIC_VECTOR(2 downto 0);
  
  component and3
    port(In1,In2,In3     :in  STD_LOGIC;
         Out1            :out STD_LOGIC);
  end component;
  
  component inv1
    port(In1       : in   STD_LOGIC;
         Out1      : out  STD_LOGIC);
  end component;

begin
  U1: inv1 port map(X(0),X_n(0));
  U2: inv1 port map(X(1),X_n(1));
  U3: inv1 port map(X(2),X_n(2));

  U4: and3 port map(In1=>X_n(0), In2=>X_n(1), In3=>X_n(2), Out1=>Y(0));
  U5: and3 port map(In1=>X(0), In2=>X_n(1), In3=>X_n(2), Out1=>Y(1));
  U6: and3 port map(In1=>X_n(0), In2=>X(1), In3=>X_n(2), Out1=>Y(2));
  U7: and3 port map(In1=>X(0), In2=>X(1), In3=>X_n(2), Out1=>Y(3));
  U8: and3 port map(In1=>X_n(0), In2=>X_n(1), In3=>X(2), Out1=>Y(4));
  U9: and3 port map(In1=>X(0), In2=>X_n(1), In3=>X(2), Out1=>Y(5));
  U10: and3 port map(In1=>X_n(0), In2=>X(1), In3=>X(2), Out1=>Y(6));
  U11: and3 port map(In1=>X(0), In2=>X(1), In3=>X(2), Out1=>Y(7));
  
end architecture;
