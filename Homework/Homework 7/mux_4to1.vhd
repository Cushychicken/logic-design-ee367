------------------------------------------------------------------------------------------------------------
-- File name   : mux_4to1.vhd
--
-- Project     : EE367 - Logic Design
--
-- Description : VHDL model of a 4 to one multiplexer
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

entity mux_4to1 is
  port(a,b,c,d  :in std_logic;
       SEL      :in std_logic_vector(1 downto 0);
       q        :out std_logic);
end entity;
       
architecture mux_4to1_arch of mux_4to1 is

  begin
    mux: process (SEL, a, b, c, d)
    begin
      case(SEL) is
      when "00"=> q<=a;
      when "01"=> q<=b;
      when "10"=> q<=c;
      when "11"=> q<=d;
      when others => q<='Z';
      end case;
    end process;
  end architecture;