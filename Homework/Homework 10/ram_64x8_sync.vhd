-- File name   : ram_64x8_sync.vhd
--
-- Project     : 8-Bit Microcomputer
--               
-- Description : VHDL model of a 64 x 8-bit RAM memory system array
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
--
-- Note(s)     : This RAM memory contains is used for program data.
-- 
--              Address      Description
--              ----------------------------------
--               (x80)         
--                 :         Random Access Memory 
--               (xBF)        (64x8-bit)              
--
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ram_64x8_sync is
    port (clock    : in  std_logic;
          data_in  : in  std_logic_vector(7 downto 0);    
          write    : in  std_logic;
          address  : in  std_logic_vector(7 downto 0);
          data_out : out std_logic_vector(7 downto 0));
end entity;


architecture rtl of ram_64x8_sync is

  type ram_type is array (128 to 191) of std_logic_vector(7 downto 0);
  signal RAM : ram_type;
                               
  begin
    
-- Syncronous Read/Write of RAM
       
   memory : process (clock) 
     begin
        if (clock'event and clock='1') then
          
            if ((address >= 128 and address <= 191) and (write = '1')) then                      
              RAM(conv_integer(address)) <= data_in;    -- this handles the synchronous write mode (en=1, write = 1)
            elsif (address >= 128 and address <= 191) then
              data_out <= RAM(conv_integer(address));   -- this handles the synchronous read mode (en=0, write = 0) 
            end if;
            
      end if;
   end process;
 
end architecture;   