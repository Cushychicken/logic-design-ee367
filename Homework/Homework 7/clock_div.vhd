------------------------------------------------------------------------------------------------------------
-- File name   : clock_div.vhd
--
-- Project     : Homework 7 - Logic Design
--
-- Description : Clock Divider
--
-- Author(s)   : Nash Reilly
--               lameres@ece.montana.edu
--
-- Date        : March 9, 2011
--
-- Note(s)     : Clock divider using D flip flops
--
------------------------------------------------------------------------------------------------------------

library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL; 

entity clock_div is
  port(clk_in   :in std_logic;
       clk_sel  :in std_logic_vector(1 downto 0);
       reset    :in std_logic;
  
       clk_out  :out std_logic);
     end entity;
     
architecture clock_div_arch of clock_div is

signal clkdiv2, clkdiv4, clkdiv8, clkdiv16 :std_logic;
signal fb1, fb2, fb3, fb4                  :std_logic;

component dflipflop
    port   (Clock           : in   STD_LOGIC;
            Reset           : in   STD_LOGIC;
            D               : in   STD_LOGIC;
            Q, Qn           : out  STD_LOGIC);
end component;

component mux_4to1
    port(a,b,c,d  :in std_logic;
         SEL      :in std_logic_vector(1 downto 0);
         q        :out std_logic);
end component;

begin
  U1: dflipflop port map(Clock=>clk_in, D=>fb1, Qn=>fb1, Q=>clkdiv2, Reset=>reset);
  U2: dflipflop port map(Clock=>fb1, D=>fb2, Qn=>fb2, Q=>clkdiv4, Reset=>reset);
  U3: dflipflop port map(Clock=>fb2, D=>fb3, Qn=>fb3, Q=>clkdiv8, Reset=>reset);
  U4: dflipflop port map(Clock=>fb3, D=>fb4, Qn=>fb4, Q=>clkdiv16, Reset=>reset);
  
  U5: mux_4to1 port map(a=>clkdiv2, b=>clkdiv4, c=>clkdiv8, d=>clkdiv16, SEL=>clk_sel, q=>clk_out);
  
end architecture;