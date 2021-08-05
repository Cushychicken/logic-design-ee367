------------------------------------------------------------------------------------------------------------
-- File name   : test_clock_div.vhd
--
-- Project     : Clock Divider
--
-- Description : VHDL testbench of a Clock Divider
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : January 25, 2011
--
-- Note(s)     : This file is a test bench
--
------------------------------------------------------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;     
use IEEE.STD_LOGIC_ARITH.ALL;    
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity test_Clock_Div is
end entity test_Clock_Div;

architecture test_Clock_Div_arch of test_Clock_Div is
        
  constant t_clk_per : time := 10 ns;

  component clock_div 
    port(clk_in   :in std_logic;
         clk_sel  :in std_logic_vector(1 downto 0);
         reset    :in std_logic;  
         clk_out  :out std_logic);
  end component;
 
  signal    Clock_TB        : STD_LOGIC;
  signal    Reset_TB        : STD_LOGIC;
  signal    Sel_TB          : STD_LOGIC_VECTOR (1 downto 0);
  signal    Clock_Out_TB    : STD_LOGIC;

  begin
      UUT1 : Clock_Div
         port map (clk_in      => Clock_TB, 
                   reset       => Reset_TB, 
                   clk_sel     => Sel_TB,
                   clk_out     => Clock_Out_TB);

-----------------------------------------------
      HEADER : process
        begin
            report "EE 367 - Logic Design,  HW #5 Testbench" severity NOTE;
            wait;
        end process HEADER;
-----------------------------------------------
      CLOCK_STIM : process
       begin
          Clock_TB <= '0'; wait for 0.5*t_clk_per; 
          Clock_TB <= '1'; wait for 0.5*t_clk_per; 
       end process CLOCK_STIM;
-----------------------------------------------      
      RESET_STIM : process
       begin
          Reset_TB <= '0'; wait for 10*t_clk_per; 
          Reset_TB <= '1'; wait; 
       end process RESET_STIM;
-----------------------------------------------      
      SEL_STIM : process
       begin
          Sel_TB <= "00"; wait for 50*t_clk_per; 
          Sel_TB <= "01"; wait for 50*t_clk_per; 
          Sel_TB <= "10"; wait for 50*t_clk_per; 
          Sel_TB <= "11"; wait for 50*t_clk_per; 
       end process SEL_STIM;
-----------------------------------------------      



end architecture test_Clock_Div_arch;
