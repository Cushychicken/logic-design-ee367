------------------------------------------------------------------------------------------------------------
-- File name   : test_microcomputer.vhd
--
-- Project     : EE367 - Logic Design (Spring 2007)
--               Lab #9 - MicroComputer 
--
-- Description : VHDL testbench of a 4-bit MicroComputer
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : April 11, 2007
--
-- Note(s)     : Test Bench
--
------------------------------------------------------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;    
use IEEE.STD_LOGIC_ARITH.ALL;    
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 

entity test_microcomputer is
end entity test_microcomputer;

architecture test_microcomputer_arch of test_microcomputer is
        
  constant t_clk_per : time := 20 ns;  -- Period of a 50MHZ Clock

-- Component Declaration

  component microcomputer
    port   ( clock          : in   std_logic;
             reset          : in   std_logic;
             port_out_00    : out  std_logic_vector (7 downto 0);
             port_out_01    : out  std_logic_vector (7 downto 0);
             port_out_02    : out  std_logic_vector (7 downto 0);
             port_out_03    : out  std_logic_vector (7 downto 0);
             port_out_04    : out  std_logic_vector (7 downto 0);
             port_out_05    : out  std_logic_vector (7 downto 0);
             port_out_06    : out  std_logic_vector (7 downto 0);
             port_out_07    : out  std_logic_vector (7 downto 0);
             port_out_08    : out  std_logic_vector (7 downto 0);
             port_out_09    : out  std_logic_vector (7 downto 0);
             port_out_10    : out  std_logic_vector (7 downto 0);
             port_out_11    : out  std_logic_vector (7 downto 0);
             port_out_12    : out  std_logic_vector (7 downto 0);
             port_out_13    : out  std_logic_vector (7 downto 0);
             port_out_14    : out  std_logic_vector (7 downto 0);
             port_out_15    : out  std_logic_vector (7 downto 0);
             port_out_16    : out  std_logic_vector (7 downto 0);
             port_out_17    : out  std_logic_vector (7 downto 0);
             port_in_00     : in   std_logic_vector (7 downto 0);
             port_in_01     : in   std_logic_vector (7 downto 0);
             port_in_02     : in   std_logic_vector (7 downto 0);
             port_in_03     : in   std_logic_vector (7 downto 0));
  end component;

 -- Signal Declaration
 
    signal  clock_TB       : std_logic;
    signal  reset_TB       : std_logic;
    signal  port_out_00_TB : std_logic_vector (7 downto 0);
    signal  port_out_01_TB : std_logic_vector (7 downto 0);
    signal  port_out_02_TB : std_logic_vector (7 downto 0);
    signal  port_out_03_TB : std_logic_vector (7 downto 0);
    signal  port_out_04_TB : std_logic_vector (7 downto 0);
    signal  port_out_05_TB : std_logic_vector (7 downto 0);
    signal  port_out_06_TB : std_logic_vector (7 downto 0);
    signal  port_out_07_TB : std_logic_vector (7 downto 0);
    signal  port_out_08_TB : std_logic_vector (7 downto 0);
    signal  port_out_09_TB : std_logic_vector (7 downto 0);
    signal  port_out_10_TB : std_logic_vector (7 downto 0);
    signal  port_out_11_TB : std_logic_vector (7 downto 0);
    signal  port_out_12_TB : std_logic_vector (7 downto 0);
    signal  port_out_13_TB : std_logic_vector (7 downto 0);
    signal  port_out_14_TB : std_logic_vector (7 downto 0);
    signal  port_out_15_TB : std_logic_vector (7 downto 0);
    signal  port_out_16_TB : std_logic_vector (7 downto 0);
    signal  port_out_17_TB : std_logic_vector (7 downto 0);
    signal  port_in_00_TB  : std_logic_vector (7 downto 0);
    signal  port_in_01_TB  : std_logic_vector (7 downto 0);
    signal  port_in_02_TB  : std_logic_vector (7 downto 0);
    signal  port_in_03_TB  : std_logic_vector (7 downto 0);


  begin
      DUT1 : microcomputer
         port map  (clock         => clock_TB,
                    reset         => reset_TB,
                    port_out_00   => port_out_00_TB,
                    port_out_01   => port_out_01_TB,
                    port_out_02   => port_out_02_TB,
                    port_out_03   => port_out_03_TB,
                    port_out_04   => port_out_04_TB,
                    port_out_05   => port_out_05_TB,
                    port_out_06   => port_out_06_TB,
                    port_out_07   => port_out_07_TB,
                    port_out_08   => port_out_08_TB,
                    port_out_09   => port_out_09_TB,
                    port_out_10   => port_out_10_TB,
                    port_out_11   => port_out_11_TB,
                    port_out_12   => port_out_12_TB,
                    port_out_13   => port_out_13_TB,
                    port_out_14   => port_out_14_TB,
                    port_out_15   => port_out_15_TB,
                    port_out_16   => port_out_16_TB,
                    port_out_17   => port_out_17_TB,
                    
                    port_in_00    => port_in_00_TB,
                    port_in_01    => port_in_01_TB,
                    port_in_02    => port_in_02_TB,
                    port_in_03    => port_in_03_TB);

-----------------------------------------------
      HEADER : process
        begin
            report "Microcomputer Testbench" severity NOTE;
            wait;
        end process HEADER;
-----------------------------------------------
      CLOCK_STIM : process
       begin
          clock_TB <= '0'; wait for 0.5*t_clk_per; 
          clock_TB <= '1'; wait for 0.5*t_clk_per; 
       end process CLOCK_STIM;
-----------------------------------------------      
      RESET_STIM : process
       begin
          reset_TB <= '0'; wait for 2*t_clk_per; 
          reset_TB <= '1'; wait; 
       end process RESET_STIM;
-----------------------------------------------     

      INPUT_STIM : process
       begin
          port_in_00_TB <= x"AA"; wait for t_clk_per;
          port_in_01_TB <= x"55"; wait for 200*t_clk_per;
          port_in_00_TB <= x"0A"; wait for t_clk_per;
          port_in_01_TB <= x"05"; wait for 200*t_clk_per;
       end process INPUT_STIM;


end architecture test_microcomputer_arch;
