------------------------------------------------------------------------------------------------------------
-- File name   : rom_16x4_sync.vhd
--
-- Project     : EELE367 - Logic Design
--               
-- Description : VHDL model of a 16 x 4-bit ROM memory system that has been initialized
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : April 11, 2011
--
-- Note(s)     : The Memory Map for this system is as follows:
-- 
--              Address      Description
--              ----------------------------------
--              $0           
--               :           Read Only Memory 
--              $F            (16x4-bit)              
--
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rom_16x4_sync is
    port (clock    : in  std_logic;
          en       : in  std_logic;
          address  : in  std_logic_vector(3 downto 0);
          data_out : out std_logic_vector(3 downto 0));
end rom_16x4_sync;


architecture rom_16x4_sync_arch of rom_16x4_sync is

  type rom_type is array (0 to 15) of std_logic_vector(3 downto 0);

  constant ROM : rom_type := (0  => x"F", 
                              1  => x"E",  
                              2  => x"D",                                
                              3  => x"C",                               
                              4  => x"B",    
                              5  => x"A",  
                              6  => x"9",  
                              7  => x"8",  
                              8  => x"7",                                
                              9  => x"6",                               
                              10 => x"5",     
                              11 => x"4",  
                              12 => x"3",  
                              13 => x"2",    
                              14 => x"1",  
                              15 => x"0");                                
                                
   begin
   
   memory : process (clock) 
     begin
        if (clock'event and clock='1') then
          if (en = '1') then
            data_out <= ROM(conv_integer(address));    
        end if;
      end if;
   end process;
 
end architecture;   