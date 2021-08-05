------------------------------------------------------------------------------------------------------------
-- File name   : processing_unit.vhd
--
-- Project     : 8-Bit MicroComputer
--
-- Description : VHDL model of a CPU "Processing Unit"
--
-- Author(s)   : Nash Reilly
--               Midhat Feidi
--               Montana State University
--
-- Note(s)     : This file contains the Entity and Architecture
--               
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity processing_unit is
  
  generic (ADD_XY    : STD_LOGIC_VECTOR (2 downto 0) := "000";   -- ALU Select for Adding X and Y
           SUB_XY    : STD_LOGIC_VECTOR (2 downto 0) := "001";   -- ALU Select for Subtracting X and Y
           AND_XY    : STD_LOGIC_VECTOR (2 downto 0) := "010";   -- ALU Select for "and"-ing X and Y
           OR_XY     : STD_LOGIC_VECTOR (2 downto 0) := "011";   -- ALU Select for "or"-ing X and Y
           INCX      : STD_LOGIC_VECTOR (2 downto 0) := "100";   -- ALU Select for incrementing X
           DECX      : STD_LOGIC_VECTOR (2 downto 0) := "101";   -- ALU Select for decrementing X
           INCY      : STD_LOGIC_VECTOR (2 downto 0) := "110";   -- ALU Select for incrementing Y
           DECY      : STD_LOGIC_VECTOR (2 downto 0) := "111");  -- ALU Select for decrementing Y
            
            
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
 signal Carry      : STD_LOGIC;  
 
 signal Z_ALU_in, Bus1_ALU_in : STD_LOGIC_VECTOR (8 downto 0);

 signal ALU_out    : STD_LOGIC_VECTOR (8 downto 0);
  
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
     MAR <= Bus2;
   end if;
 end process;
 
 Address <= MAR;
 
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
 
--------------------------------------------------
--  ARITHMETIC/LOGIC UNIT
-------------------------------------------------- 
 
 Z_ALU_in <= '0' & Z;                               -- Makes Z input to ALU a 9 bit string

 Bus1_ALU_in <= '0' & Bus1;                         -- Makes Bus1 input to ALU a 9 bit string
 
 Carry <= ALU_out(8);                               -- Sets Carry equal to highest bit of ALU_out
 
 ALU <= ALU_out(7 downto 0);                        -- Sets ALU output equal to non carry bits in ALU_out
 
 ARITHMETIC_LOGIC_UNIT : process (Z_ALU_in, Bus1_ALU_in, ALU_Sel)
 begin
   case (ALU_Sel) is
     when ADD_XY => ALU_out <= Z_ALU_in + Bus1_ALU_in;       -- ALU performs an add of X to Y with carry
     when SUB_XY => ALU_out <= Z_ALU_in - Bus1_ALU_in;       -- ALU subtracts X from Y
     when AND_XY => ALU_out <= Z_ALU_in AND Bus1_ALU_in;     -- ALU 'and's X and Y
     when OR_XY  => ALU_out <= Z_ALU_in OR Bus1_ALU_in;      -- ALU 'or's X and Y
     when INCX   => ALU_out <= Bus1_ALU_in + 1;              -- ALU increments X  
     when DECX   => ALU_out <= Bus1_ALU_in - 1;              -- ALU decrements X  
     when INCY   => ALU_out <= Bus1_ALU_in + 1;              -- ALU increments Y    
     when DECY   => ALU_out <= Bus1_ALU_in - 1;              -- ALU decrements Y 
     when others => ALU_out <= "ZZZZZZZZZ";
   end case;
 end process;

--------------------------------------------------
--  CONDITION CODE REGISTER
-------------------------------------------------- 
 
 CONDITION_CODE_REGISTER : process (Clock, Reset)
 begin
   if (Reset = '0') then
     CCR_Result <= x"00";
   elsif (Clock'event and Clock = '1' and CCR_Load = '1') then
     if (ALU = x"00") then
       CCR_Result <= "000000" & '1' & Carry;
     else 
       CCR_Result <= "000000" & '0' & Carry;
     end if;
   end if;
 end process;
   
end architecture rtl;
