------------------------------------------------------------------------------------------------------------
-- File name   : microcomputer.vhd
--
-- Project     : 8-Bit MicroComputer
--
-- Description : VHDL model of a CPU "Processing Unit"
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Note(s)     : This file contains the Entity and Architecture
--               
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity processing_unit is
  
  generic  ( ADD_XY    : STD_LOGIC_VECTOR (2 downto 0) := "000";  -- ALU code to initiate add sequence
             SUB_XY    : 
      port ( Clock     : in  STD_LOGIC;
             Reset     : in  STD_LOGIC;
             Memory_In : out STD_LOGIC_VECTOR (7 downto 0);
             Memory_Out: in  STD_LOGIC_VECTOR (7 downto 0);             
             Address   : out STD_LOGIC_VECTOR (7 downto 0);
             IR_Load   : in  STD_LOGIC;
             IR        : out STD_LOGIC_VECTOR (7 downto 0);
             MAR_Load  : in  STD_LOGIC;             
             PC_Load   : in  STD_LOGIC;
             PC_Inc    : in  STD_LOGIC;             
             X_Load    : in  STD_LOGIC;
             Y_Load    : in  STD_LOGIC;             
             Z_Load    : in  STD_LOGIC;
             ALU_Sel   : in  STD_LOGIC_VECTOR (2 downto 0);             
             CCR_Result: out STD_LOGIC_VECTOR (7 downto 0);
             CCR_Load  : in  STD_LOGIC;             
             Bus1_Sel  : in  STD_LOGIC_VECTOR (1 downto 0);                          
             Bus2_Sel  : in  STD_LOGIC_VECTOR (1 downto 0));                             
end entity processing_unit;

architecture rtl of processing_unit is

 signal Bus1, Bus2 : STD_LOGIC_VECTOR (7 downto 0);
 signal MAR, PC    : STD_LOGIC_VECTOR (7 downto 0); 
 signal X,Y,Z      : STD_LOGIC_VECTOR (7 downto 0); 
 signal ALU        : STD_LOGIC_VECTOR (7 downto 0);  
 

 begin

---------------------------------------------------
--  BUS1 to Memory_In 
---------------------------------------------------

  Memory_In <= Bus1;

---------------------------------------------------
--  MUX DECLARATIONS
---------------------------------------------------

 MUX_BUS_1_SEL : process(Bus1_Sel, PC, X, Y)      -- Multiplexer for selecting driver of Bus1
 begin
   case (Bus1_Sel) is
     when "00" => Bus1 <= PC;
     when "01" => Bus1 <= X;
     when "10" => Bus1 <= Y;
     when others => Bus1 <= "ZZZZZZZZ";
   end case;
 end process;

 MUX_BUS_2_SEL : process(Bus2_Sel, ALU, Bus1, Memory_Out)      -- Multiplexer for selecting driver of Bus2
 begin
   case (Bus2_Sel) is
     when "00" => Bus2 <= ALU;
     when "01" => Bus2 <= Bus1;
     when "10" => Bus2 <= Memory_Out;
     when others => Bus2 <= "ZZZZZZZZ";
   end case;
 end process;

--------------------------------------------------
--  OPERATION REGISTERS (IR, MAR, PC)
--------------------------------------------------

 INSTRUCTION_REGISTER : process(Clock, Reset)     -- Register containing opcode for current instruction
 begin
   if (Reset = '0') then
     IR <= "00000000";
   elsif (Clock'event and Clock = '1' and IR_Load = '1') then
     IR <= Bus2;
   end if;
 end process;
 
 MEMORY_ADDRESS_REGISTER : process(Clock, Reset)  -- Contains address for next memory access
 begin
   if (Reset = '0') then
     MAR <= "00000000";
   elsif (Clock'event and Clock = '1' and MAR_Load = '1') then
     Address <= Bus2;
   end if;
 end process;
 
 PROGRAM_COUNTER : process(Clock, Reset)          -- Contains location in memory for next instruction
 begin
   if (Reset = '0') then
     PC <= "00000000";
   elsif (Clock'event and Clock = '1' and PC_Inc = '1') then
     PC <= PC + 1;
   elsif (Clock'event and Clock = '1' and PC_Load = '1') then
     PC <= Bus2;
   end if;
 end process;

--------------------------------------------------
--  DATA REGISTERS (X, Y, Z)
--------------------------------------------------

 X_REGISTER : process(Clock, Reset)               -- holds 8 bits of data for manipulation
 begin
   if (Reset = '0') then
     X <= "00000000";
   elsif (Clock'event and Clock = '1' and X_Load = '1') then
     X <= Bus2;
   end if;
 end process;
 
 Y_REGISTER : process(Clock, Reset)               -- holds 8 bits of data for manipulation
 begin
   if (Reset = '0') then
     Y <= "00000000";
   elsif (Clock'event and Clock = '1' and Y_Load = '1') then
     Y <= Bus2;
   end if;
 end process;  

 Z_REGISTER : process(Clock, Reset)               -- holds 8 bits of data for manipulation
 begin
   if (Reset = '0') then
     Z <= "00000000";
   elsif (Clock'event and Clock = '1' and Z_Load = '1') then
     Z <= Bus2;
   end if;
 end process;
 
 
end architecture rtl;
