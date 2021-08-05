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
            STY_DIR  : STD_LOGIC_VECTOR (7 downto 0) := x"D6";   -- Store Register Y to memory (RAM or IO)
            LDX_DIR  : STD_LOGIC_VECTOR (7 downto 0) := x"CD";   -- Load X with direct addressing
            LDY_DIR  : STD_LOGIC_VECTOR (7 downto 0) := x"DC";   -- Load Y with direct addressing  
            
            ADD_XY   : STD_LOGIC_VECTOR (7 downto 0) := x"60";  -- Adds X and Y registers
            SUB_XY   : STD_LOGIC_VECTOR (7 downto 0) := x"70";   -- Subtract X from Y, store into X
            AND_XY   : STD_LOGIC_VECTOR (7 downto 0) := x"50";   -- And X to Y, store in X
            OR_XY    : STD_LOGIC_VECTOR (7 downto 0) := x"D3";   -- Or X to Y, store in X
            INC_X    : STD_LOGIC_VECTOR (7 downto 0) := x"C1";   -- Increment X, store in X
            INC_Y    : STD_LOGIC_VECTOR (7 downto 0) := x"E2";   -- Increment Y, store in Y
            DEC_X    : STD_LOGIC_VECTOR (7 downto 0) := x"40";   -- decrement X, store in X
            DEC_Y    : STD_LOGIC_VECTOR (7 downto 0) := x"A2");   -- decrement Y, store in Y);                                                                 
            
                -- More instructions mnemonics are defined here...
  port     (clock    : in  std_logic;
            address  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0));
          
end entity;


architecture rtl of rom_128x8_sync is

  type rom_type is array (0 to 127) of std_logic_vector(7 downto 0);

  constant ROM : rom_type := (0      => LDX_IMM,  -- testing Load X Imm
                              1      => x"02",     
                              2      => LDY_IMM,  -- testing Load Y imm
                              3      => x"01",  
                              4      => ADD_XY,   -- testing ADD_XY  
                              5      => STX_DIR,  -- testing STOREX to port_out_00
                              
                              6      => x"C0",  
                              7      => SUB_XY,   -- testing SUB_XY
                              8      => AND_XY,   --testing AND_XY
                              9      => OR_XY,    -- testing OR_XY
                                     
                              10     => INC_X,    -- testing Increment X  
                              11     => INC_Y,    -- testing Increment Y
                              12     => DEC_X,    -- testing decrement X 
                              13     => DEC_Y,    -- testing decrement Y 
                              14     => LDX_DIR,  -- testing Load X Direct
                              15     => x"42", 
                              16     => LDY_DIR,  -- testing Load Y Direct
                              17     => x"43",
      
                              18     => STX_DIR,  -- testing store X to RAM    
                              19     => x"82", 
                              20     => STX_DIR,  -- testing store X to port_out_00   
                              21     => x"C0",
                              22     => LDX_DIR,  -- testing loading from port_in_00
                              23     => x"E0",
                              24     => LDY_DIR,  -- testing loading from port_in_01
                              25     => x"E1",
                              26     => LDX_DIR,  -- testing loading from port_in_02
                              27     => x"E2",
                              28     => LDY_DIR,  -- testing loading from port_in_03
                              29     => x"E3",
                              30     => STX_DIR,  -- testing store to port_out_00
                              
                              31     => x"C0",    
                              32     => STX_DIR,  -- testing store to port_out_01
                              33     => x"C1",
                              34     => STX_DIR,  -- testing store to port_out_02
                              35     => x"C2",
                              36     => STX_DIR,  -- testing store to port_out_03
                              37     => x"C3",
                              38     => STX_DIR,  -- testing store to port_out_04
                              39     => x"C4",
                              40     => STY_DIR,  -- testing store to port_out_05
                              41     => x"C5",
                              42     => STX_DIR,  -- testing store to port_out_06
                              43     => x"C6",
                              44     => STY_DIR,  -- testing store to port_out_07
                              45     => x"C7",
                              46     => STX_DIR,  -- testing store to port_out_08
                              47     => x"C8",
                              48     => STY_DIR,  -- testing store to port_out_09
                              49     => x"C9",
                              50     => STX_DIR,  -- testing store to port_out_10
                              51     => x"CA",
                              52     => STY_DIR,  -- testing store to port_out_11
                              53     => x"CB",
                              54     => STX_DIR,  -- testing store to port_out_12
                              55     => x"CC",
                              56     => STY_DIR,  -- testing store to port_out_13
                              57     => x"CD",
                              58     => STX_DIR,  -- testing store to port_out_14
                              59     => x"CE",
                              60     => STY_DIR,  -- testing store to port_out_15
                              61     => x"CF",
                              62     => STX_DIR,  -- testing store to port_out_16
                              63     => x"D0",
                              64     => STY_DIR,  -- testing store to port_out_17
                              65     => x"D1",
										          66     => x"AA",
                              67     => x"55",

--            Commented-out code for Adder on DE2 Board
--										  0		=> LDX_DIR,
--    									    1		=> x"E0",
--										  
--										  2		=> LDY_DIR,
--										  3		=> x"E1",
--										  4		=> STX_DIR,
--										  5		=> x"CD",
--										  6		=> STY_DIR,
--										  7  => x"CE",
--										  8	 => ADD_XY,
--										  9		=> STX_DIR,
--										  10	   => x"C0",
--										  11     => STX_DIR,
--										  12     => x"80",
--										  13		=> BRA,
--										  14		=> x"00",
										
                            

                              
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