------------------------------------------------------------------------------------------------------------
-- File name   : test_memory_interface.vhd
--
-- Project     : EE367 - Logic Design 
--               Memory Interface
--
-- Description : VHDL testbench of a Memory Interface
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : April 11, 2011
--
-- Note(s)     : Test Bench
--
------------------------------------------------------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;    
use IEEE.STD_LOGIC_ARITH.ALL;    
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 

entity test_memory_interface is
end entity test_memory_interface;

architecture test_memory_interface_arch of test_memory_interface is
        
  constant t_clk_per : time := 20 ns;  -- Period of a 50MHZ Clock

-- Component Declaration

  component memory_interface
    port   ( clock     : in   STD_LOGIC;
             reset     : in   STD_LOGIC);
  end component;

 -- Signal Declaration
 
    signal  Clock_TB     : STD_LOGIC;
    signal  Reset_TB     : STD_LOGIC;

  begin
      DUT1 : memory_interface
         port map  (clock         => Clock_TB,
                    reset         => Reset_TB);

-----------------------------------------------
      HEADER : process
        begin
            report "EE 367 - Logic Design,  Testbench" severity NOTE;
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
          Reset_TB <= '0'; wait for 2*t_clk_per; 
          Reset_TB <= '1'; wait; 
       end process RESET_STIM;
-----------------------------------------------      

end architecture test_memory_interface_arch;
