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

entity ram_16x4_sync is
    port (clock  	 	  : in  std_logic;
          en      	  : in  std_logic;
          write_ram    : in  std_logic;
          address  	  : in  std_logic_vector(3 downto 0);
          data_out 	  : out std_logic_vector(3 downto 0);
          data_in  	  : in  std_logic_vector(3 downto 0));
end ram_16x4_sync;


architecture ram_16x4_sync_arch of ram_16x4_sync is

  type ram_type is array (0 to 15) of std_logic_vector(3 downto 0);

  signal RAM : ram_type;                          
                                
  begin
   
    memory : process (clock) 
      begin
        if (clock'event and clock='1') then
          if (en = '1') then
            if (write_ram = '1') then
              RAM(conv_integer(address)) <= data_in;
            else
              data_out <= RAM(conv_integer(address));
            end if;
          end if;
        end if;
      end process;
 
end architecture;   