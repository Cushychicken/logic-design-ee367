------------------------------------------------------------------------------------------------------------
-- File name   : test_processing_unit.vhd
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
 

entity test_processing_unit is
end entity test_processing_unit;

architecture test_processing_unit_arch of test_processing_unit is
        
  constant t_clk_per : time := 20 ns;  -- Period of a 50MHZ Clock

-- Component Declaration

  component microcomputer
    port   ( clock         : in   std_logic;
             reset         : in   std_logic;
             port_out_00   : out  std_logic_vector (7 downto 0);
             port_in_00    : in   std_logic_vector (7 downto 0));
  end component;

 -- Signal Declaration
 
    signal  clock_TB       : std_logic;
    signal  reset_TB       : std_logic;
    signal  port_out_00_TB : std_logic_vector (7 downto 0);
    signal  port_in_00_TB  : std_logic_vector (7 downto 0);


  begin
      DUT1 : microcomputer
         port map  (clock         => clock_TB,
                    reset         => reset_TB,
                    port_out_00   => port_out_00_TB,
                    port_in_00    => port_in_00_TB);

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

end architecture test_microcomputer_arch;

