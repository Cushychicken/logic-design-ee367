-----------------------------------------------------------------
-- File name   : test_decoder_3to8.vhd
--
-- Project     : 3to8 Decoders
--
-- Description : VHDL testbench of decoder
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : January 25, 2011
--
-- Note(s)     : This file is a test bench; has been edited to conform to user inputs
--
-----------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;  

entity test_decoder_3to8 is
end entity test_decoder_3to8;

architecture test_decoder_3to8_arch of test_decoder_3to8 is
    
  component decoder_3to8  
        port  (X      : in  STD_LOGIC_VECTOR(2 downto 0); 
               Y      : out STD_LOGIC_VECTOR(7 downto 0)); 
  end component;

  signal    In1,  In2,  In3        : STD_LOGIC;                        -- setup internal "input" signals 
  signal    Out1, Out2, Out3, Out4 : STD_LOGIC;                        -- setup internal "output" signals   
  signal    Out5, Out6, Out7, Out8 : STD_LOGIC;                        -- setup internal "output" signals   
  
  begin
      U1 :   decoder_3to8
         port map (X(2) => In3,
                   X(1) => In2,
                   X(0) => In1,
                   Y(7) => Out8,
                   Y(6) => Out7,
                   Y(5) => Out6,
                   Y(4) => Out5,
                   Y(3) => Out4,
                   Y(2) => Out3,
                   Y(1) => Out2,
                   Y(0) => Out1);

      stimulus : process
                  begin
                     In3 <= '0'; In2 <= '0';   In1 <= '0';
                     wait for 10 ns;
                     In3 <= '0'; In2 <= '0';   In1 <= '1';
                     wait for 10 ns;
                     In3 <= '0'; In2 <= '1';   In1 <= '0';
                     wait for 10 ns;
                     In3 <= '0'; In2 <= '1';   In1 <= '1';
                     wait for 10 ns;
                     In3 <= '1'; In2 <= '0';   In1 <= '0';
                     wait for 10 ns;
                     In3 <= '1'; In2 <= '0';   In1 <= '1';
                     wait for 10 ns;
                     In3 <= '1'; In2 <= '1';   In1 <= '0';
                     wait for 10 ns;
                     In3 <= '1'; In2 <= '1';   In1 <= '1';
                     wait for 10 ns;
      end process stimulus;
      
end architecture test_decoder_3to8_arch;
                 

