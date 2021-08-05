------------------------------------------------------------------------------------------------------------
-- File name   : rom_128x8_sync.vhd
--
-- Project     : 8-Bit Microcomputer
--               
-- Description : VHDL model of a 128 x 8-bit ROM memory system that has been initialized
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
--
-- Note(s)     : This ROM memory contains the program instructions for the microcomputer.
-- 
--              Address      Description
--              ----------------------------------
--               (x00)         
--                 :         Read Only Memory 
--               (x7F)        (128x8-bit)              
--
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rom_128x8_sync is

  -- we use generics to create mnemoics for our instruction set.  This allows us to program in "assembly code"
  
  generic  (LDX_IMM  : STD_LOGIC_VECTOR (7 downto 0) := x"86";   -- Load Register X with Immediate Addressing
            STX_DIR  : STD_LOGIC_VECTOR (7 downto 0) := x"96";   -- Store Register X to memory (RAM or IO)
            BRA      : STD_LOGIC_VECTOR (7 downto 0) := x"20";   -- Branch Always
            LDY_IMM  : STD_LOGIC_VECTOR (7 downto 0) := x"C6";   -- Load Register Y with Immediate Addressing                           
            STY_DIR  : STD_LOGIC_VECTOR (7 downto 0) := x"D6");  -- Store Register Y to memory (RAM or IO)
                                                                  -- More instructions mnemonics are defined here...
  port     (clock    : in  std_logic;
            address  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0));
          
end entity;


architecture rtl of rom_128x8_sync is

  type rom_type is array (0 to 127) of std_logic_vector(7 downto 0);

  constant ROM : rom_type := (0      => LDX_IMM,  -- testing Load X Imm
                              1      => x"AA",     
                              2      => STX_DIR,  -- testing store X to RAM 
                              3      => x"80",  
                              4      => STX_DIR,  -- testing store X to port_out_00  
                              5      => x"C0",  
                              
                              6      => LDX_IMM,  -- testing Load X Imm
                              7      => x"BB",     
                              8      => STX_DIR,  -- testing store X to RAM 
                              9      => x"81",  
                              10     => STX_DIR,  -- testing store X to port_out_00  
                              11     => x"C0",  
                              
                              12     => LDX_IMM,  -- testing Load X Imm
                              13     => x"CC",     
                              14     => STX_DIR,  -- testing store X to RAM 
                              15     => x"82",  
                              16     => STX_DIR,  -- testing store X to port_out_00  
                              17     => x"C0",  
                              
                              18     => LDY_IMM,  -- testing Load Y IMM
                              19     => x"DD",
                              20     => STY_DIR,  -- testing store Y to RAM
                              21     => x"83",
                              22     => STY_DIR,  -- testing store Y to port_out_00
                              23     => x"C0",    
                              
                              24     => BRA,  
                              25     => x"00",    -- branch to the beginning of ROM
                                              
                              others => x"00");

                                
   begin

   memory : process (clock) 
     begin
        if (clock'event and clock='1') then
          if (address >= 0 and address <= 127) then
            data_out <= ROM(conv_integer(address));   
          end if; 
      end if;
   end process;
 
end architecture;   