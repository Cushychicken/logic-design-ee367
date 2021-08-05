------------------------------------------------------------------------------------------------------------
-- File name   : microcomputer.vhd
--
-- Project     : 8-Bit MicroComputer
--
-- Description : VHDL model of a CPU Control Unit
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

entity control_unit is
    
  generic  (LDX_IMM    : STD_LOGIC_VECTOR (7 downto 0) := x"86";   -- Load Register X with Immediate Addressing
            STX_DIR    : STD_LOGIC_VECTOR (7 downto 0) := x"96";   -- Store Register X to memory (RAM or IO)
            BRA        : STD_LOGIC_VECTOR (7 downto 0) := x"20";   -- Branch Always
            LDY_IMM    : STD_LOGIC_VECTOR (7 downto 0) := x"C6";   -- Load Register Y with Immediate Addressing
            STY_DIR    : STD_LOGIC_VECTOR (7 downto 0) := x"D6");   -- Store Register Y to memory (RAM or IO)                            
      
      port ( Clock     : in  STD_LOGIC;
             Reset     : in  STD_LOGIC;
             Write     : out STD_LOGIC;
             IR_Load   : out STD_LOGIC;
             IR        : in  STD_LOGIC_VECTOR (7 downto 0);
             MAR_Load  : out STD_LOGIC;             
             PC_Load   : out STD_LOGIC;
             PC_Inc    : out STD_LOGIC;             
             X_Load    : out STD_LOGIC;
             Y_Load    : out STD_LOGIC;             
             Z_Load    : out STD_LOGIC;
             ALU_Sel   : out STD_LOGIC_VECTOR (2 downto 0);             
             CCR_Result: in  STD_LOGIC_VECTOR (7 downto 0);
             CCR_Load  : out STD_LOGIC;             
             Bus1_Sel  : out STD_LOGIC_VECTOR (1 downto 0);                          
             Bus2_Sel  : out STD_LOGIC_VECTOR (1 downto 0));    
end entity control_unit;

architecture rtl of control_unit is

type state_type is (S_FETCH_0,              -- Opcode fetch states
                    S_FETCH_1,
                    S_FETCH_2,
                    S_DECODE_3,
                    
                    S_LDXIMM_4,             -- Load X (immediate) states
                    S_LDXIMM_5,
                    S_LDXIMM_6,
                    
                    S_STXDIR_4,             -- Store X (Direct) States
                    S_STXDIR_5,
                    S_STXDIR_6,
                    S_STXDIR_7,
                    
                    S_BRA_4,                -- Branch States
                    S_BRA_5,
                    S_BRA_6,
                    
                    S_LDYIMM_4,             -- Load Y (immediate) states
                    S_LDYIMM_5,
                    S_LDYIMM_6,
                    
                    S_STYDIR_4,             -- Store Y (Direct) States
                    S_STYDIR_5,
                    S_STYDIR_6,
                    S_STYDIR_7);

signal current_state, next_state : state_type;

begin

  STATE_MEMORY : process(Clock, Reset)      -- Holds current state
    begin
      if (Reset = '0') then
        current_state <= S_FETCH_0;
      elsif (clock'event and clock = '1') then
        current_state <= next_state;
      end if;
    end process;

  NEXT_STATE_LOGIC : process(current_state) --  Determines Next State (comb. logic)
    begin
      if (current_state = S_FETCH_0) then 
        next_state <= S_FETCH_1;
      elsif (current_state = S_FETCH_1) then 
        next_state <= S_FETCH_2;
      elsif (current_state = S_FETCH_2) then 
        next_state <= S_DECODE_3;
      elsif (current_state = S_DECODE_3) then 
        if (IR = LDX_IMM) then
          next_state <= S_LDXIMM_4;
        elsif (IR = STX_DIR) then
          next_state <= S_STXDIR_4;
        elsif (IR = BRA) then
          next_state <= S_BRA_4;
        elsif (IR = LDY_IMM) then
          next_state <= S_LDYIMM_4;
        elsif (IR = STY_DIR) then
          next_state <= S_STYDIR_4;
        end if;
      
      elsif (current_state = S_LDXIMM_4) then   -- State Tree for LDX_IMM instruction
        next_state <= S_LDXIMM_5;
      elsif (current_state = S_LDXIMM_5) then 
        next_state <= S_LDXIMM_6;
      elsif (current_state = S_LDXIMM_6) then 
        next_state <= S_FETCH_0;
      
      elsif (current_state = S_STXDIR_4) then   -- State tree for STX_DIR instruction
        next_state <= S_STXDIR_5;
      elsif (current_state = S_STXDIR_5) then 
        next_state <= S_STXDIR_6;
      elsif (current_state = S_STXDIR_6) then 
        next_state <= S_STXDIR_7;
      elsif (current_state = S_STXDIR_7) then 
        next_state <= S_FETCH_0;  
      
      elsif (current_state = S_BRA_4) then      -- State tree for BRA instruction
        next_state <= S_BRA_5;
      elsif (current_state = S_BRA_5) then 
        next_state <= S_BRA_6;
      elsif (current_state = S_BRA_6) then 
        next_state <= S_FETCH_0;
        
      elsif (current_state = S_LDYIMM_4) then   -- State Tree for LDY_IMM instruction
        next_state <= S_LDYIMM_5;
      elsif (current_state = S_LDYIMM_5) then 
        next_state <= S_LDYIMM_6;
      elsif (current_state = S_LDYIMM_6) then 
        next_state <= S_FETCH_0;
        
      elsif (current_state = S_STYDIR_4) then   -- State tree for STY_DIR instruction
        next_state <= S_STYDIR_5;
      elsif (current_state = S_STYDIR_5) then 
        next_state <= S_STYDIR_6;
      elsif (current_state = S_STYDIR_6) then 
        next_state <= S_STYDIR_7;
      elsif (current_state = S_STYDIR_7) then 
        next_state <= S_FETCH_0;  
      end if;
    end process;
  
  OUTPUT_LOGIC : process(current_state)     --  Determines outputs 
    begin
      case(current_state) is
        when S_FETCH_0 =>   -- First state - loads PC into MAR to send address to memory
          Write    <= '0';            
          IR_Load  <= '0';         
          MAR_Load <= '1';                       
          PC_Load  <= '0';         
          PC_Inc   <= '0';                     
          X_Load   <= '0';            
          Y_Load   <= '0';                 
          Z_Load   <= '0';            
          ALU_Sel  <= "000";                 
          CCR_Load <= '0';                      
          Bus1_Sel <= "00";                                      
          Bus2_Sel <= "01";            
        when S_FETCH_1 =>   -- Second state - changes Bus2 to receive opcode, increments PC
          Write    <= '0';          
          IR_Load  <= '0';            
          MAR_Load <= '0';                       
          PC_Load  <= '0';           
          PC_Inc   <= '1';                       
          X_Load   <= '0';            
          Y_Load   <= '0';                      
          Z_Load   <= '0';        
          ALU_Sel  <= "000";                       
          CCR_Load <= '0';                 
          Bus1_Sel <= "00";                                 
          Bus2_Sel <= "10";         
        when S_FETCH_2 =>   -- Third state - Loads instruction register with opcode 
          Write    <= '0';         
          IR_Load  <= '1';      
          MAR_Load <= '0';                   
          PC_Load  <= '0';        
          PC_Inc   <= '0';                  
          X_Load   <= '0';      
          Y_Load   <= '0';                      
          Z_Load   <= '0';      
          ALU_Sel  <= "000";                       
          CCR_Load <= '0';                 
          Bus1_Sel <= "00";                             
          Bus2_Sel <= "10";       
        when S_DECODE_3 =>  -- Fourth state - combinational logic hamsters determine next state for comp. 
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";   
        when S_LDXIMM_4 =>  -- Loads data from next memory location immediately after one read in S_FETCH_2
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '1';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "01";
        when S_LDXIMM_5 =>  -- Increments program counter, Sets Bus2 to memory out;
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '1';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_LDXIMM_6 =>  -- Triggers X Register to load
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '1';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_STXDIR_4 =>  -- Loads MAR with address to write to
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '1';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "01";
        when S_STXDIR_5 =>  -- Increment PC, Bus2 is set for Memory_out as driver
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '1';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_STXDIR_6 =>  -- Increment PC, Bus2 is set for Memory_out as driver
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '1';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_STXDIR_7 =>  -- Sets Bus1 to drive Register X, activates write
          Write    <= '1';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "01";                                
          Bus2_Sel <= "10";
        when S_BRA_4 =>     -- Sets PC to drive Bus1, Sets Bus1 to drive Bus2, loads MAR
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '1';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "01";
        when S_BRA_5 =>     -- Sets memory_out to drive Bus2
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_BRA_6 =>     -- Loads Program Counter with new value
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '1';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_LDYIMM_4 =>  -- Loads data from next memory location immediately after one read in S_FETCH_2
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '1';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "01";
        when S_LDYIMM_5 =>  -- Increments program counter, Sets Bus2 to memory out;
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '1';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_LDYIMM_6 =>  -- Triggers data load into Y Register;
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '1';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_STYDIR_4 =>  -- Loads MAR with memory address to write to
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '1';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "01";
        when S_STYDIR_5 =>  -- Increment PC, Bus2 is set for Memory_out as driver
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '1';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_STYDIR_6 =>  -- Increment PC, Bus2 is set for Memory_out as driver
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '1';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "10";
        when S_STYDIR_7 =>  -- Sets Bus1 to drive Register Y, activates write
          Write    <= '1';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "10";  
      end case;
    end process;

end architecture rtl;
