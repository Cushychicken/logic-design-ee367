------------------------------------------------------------------------------------------------------------
-- File name   : rom_32x8_sync.vhd
--
-- Project     : EELE367 - Logic Design
--               
-- Description : VHDL model of a 16 x 8-bit ROM memory system that has been initialized
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
--              $F            (16x8-bit)              
--
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rom_16x8_sync is
    port (clock   : in  std_logic;
          enable  : in  std_logic;
          address : in  std_logic_vector(3 downto 0);
          data    : out std_logic_vector(7 downto 0));
end rom_16x8_sync;


architecture rom_16x8_sync_arch of rom_16x8_sync is

  type rom_type is array (0 to 15) of std_logic_vector(7 downto 0);

  constant ROM : rom_type := (0  => x"00", 
                              1  => x"11",  
                              2  => x"22",                                
                              3  => x"33",                               
                              4  => x"44",    
                              5  => x"55",  
                              6  => x"66",  
                              7  => x"77",  
                              8  => x"88",                                
                              9  => x"99",                               
                              10 => x"AA",     
                              11 => x"BB",  
                              12 => x"CC",  
                              13 => x"DD",    
                              14 => x"EE",  
                              15 => x"FF");                                
                                
   begin
   
   memory : process (clock) 
     begin
        if (clock'event and clock='1') then
          if (enable = '1') then
            data <= ROM(conv_integer(address));    
          end if;
        end if;
     end process;
 
end architecture;   