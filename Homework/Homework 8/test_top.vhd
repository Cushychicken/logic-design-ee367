------------------------------------------------------------------------------------------------------------
-- File name   : test_top.vhd
--
-- Project     : EE367 - Logic Design (Spring 2007)
--               Testing the Serial Sequence Detector
--
-- Description : VHDL testbench for a Serial Sequence Detector
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : March 22, 2011
--
-- Note(s)     : This file is a test bench
--
------------------------------------------------------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;     
use IEEE.STD_LOGIC_ARITH.ALL;    
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity test_TOP is
end entity test_TOP;

architecture test_TOP_arch of test_TOP is
        
  constant t_clk_per : time := 10 ns;
  constant t_reset   : time := t_clk_per * 2;

  component sequence 
    port   (Clock         : in   STD_LOGIC;
            Reset         : in   STD_LOGIC;
            Data_In       : in   STD_LOGIC;
            Found         : out  STD_LOGIC);
  end component;
 
  signal    Clock_TB        : STD_LOGIC;
  signal    Reset_TB        : STD_LOGIC;
  signal    Data_In_TB      : STD_LOGIC;

  signal    Found_TB        : STD_LOGIC;

  begin
      DUT1 : sequence
         port map (Clock         => Clock_TB, 
                   Reset         => Reset_TB, 
                   Data_In       => Data_In_TB,
                   Found         => Found_TB);

-----------------------------------------------
      HEADER : process
        begin
            report "EE 367 - Logic Design,  Serial Sequence Testbench" severity NOTE;
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
          Reset_TB <= '0'; wait for t_reset; 
          Reset_TB <= '1'; wait; 
       end process RESET_STIM;
-----------------------------------------------      
      DATA_IN_STIM : process
       begin
          Data_In_TB <= 'Z'; wait for (t_reset + t_clk_per); 
-- Good Pattern           
          Data_In_TB <= '0'; wait for t_clk_per; 
          Data_In_TB <= '1'; wait for t_clk_per;           
          Data_In_TB <= '1'; wait for t_clk_per; 
          Data_In_TB <= '0'; wait for t_clk_per;           
          Data_In_TB <= '0'; wait for t_clk_per; 
          Data_In_TB <= '1'; wait for t_clk_per;           
          Data_In_TB <= '1'; wait for t_clk_per; 
          Data_In_TB <= '0'; wait for t_clk_per;

          assert (Found_TB = '0') report "PASS: Sequence Found" severity NOTE;          --Print if FOUND=1
          assert (Found_TB = '1') report "FAIL: Did Not Detect Sequence" severity NOTE; --Print if FOUND=0
          
          wait for t_clk_per;
-- Good Pattern           
          Data_In_TB <= '0'; wait for t_clk_per; 
          Data_In_TB <= '1'; wait for t_clk_per;           
          Data_In_TB <= '1'; wait for t_clk_per; 
          Data_In_TB <= '0'; wait for t_clk_per;           
          Data_In_TB <= '0'; wait for t_clk_per; 
          Data_In_TB <= '1'; wait for t_clk_per;           
          Data_In_TB <= '1'; wait for t_clk_per; 
          Data_In_TB <= '0'; wait for t_clk_per;

          assert (Found_TB = '0') report "PASS: Sequence Found" severity NOTE;          --Print if FOUND=1
          assert (Found_TB = '1') report "FAIL: Did Not Detect Sequence" severity NOTE; --Print if FOUND=0

          wait for t_clk_per;
-- Bad Pattern           
          Data_In_TB <= '0'; wait for t_clk_per; 
          Data_In_TB <= '1'; wait for t_clk_per;           
          Data_In_TB <= '1'; wait for t_clk_per; 
          Data_In_TB <= '0'; wait for t_clk_per;           
          Data_In_TB <= '0'; wait for t_clk_per;         
          Data_In_TB <= '0'; wait for t_clk_per;           
          Data_In_TB <= '1'; wait for t_clk_per; 
          Data_In_TB <= '0'; wait for t_clk_per;
          
          assert (Found_TB = '0') report "FAIL: False Detection" severity NOTE;         --Print if FOUND=1
          assert (Found_TB = '1') report "PASS: Did Not False Detect" severity NOTE;    --Print if FOUND=0
          
          wait;

       end process DATA_IN_STIM;
-----------------------------------------------      


end architecture test_TOP_arch;
