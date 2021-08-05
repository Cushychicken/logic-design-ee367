------------------------------------------------------------------------------------------------------------
-- File name   : control_unit.vhd
--
-- Project     : 8-Bit MicroComputer
--
-- Description : VHDL model of a CPU Control Unit
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

entity control_unit is
    
  generic  (LDX_IMM    : STD_LOGIC_VECTOR (7 downto 0) := x"86";   -- Load Register X with Immediate Addressing
            STX_DIR    : STD_LOGIC_VECTOR (7 downto 0) := x"96";   -- Store Register X to memory (RAM or IO)
            BRA        : STD_LOGIC_VECTOR (7 downto 0) := x"20";   -- Branch Always
            LDY_IMM    : STD_LOGIC_VECTOR (7 downto 0) := x"C6";   -- Load Register Y with Immediate Addressing
            STY_DIR    : STD_LOGIC_VECTOR (7 downto 0) := x"D6";   -- Store Register Y to memory (RAM or IO)
            LDX_DIR    : STD_LOGIC_VECTOR (7 downto 0) := x"CD";   -- Load X with direct addressing
            LDY_DIR    : STD_LOGIC_VECTOR (7 downto 0) := x"DC";   -- Load Y with direct addressing            
            ADD_XY     : STD_LOGIC_VECTOR (7 downto 0) := x"60";   -- Add X to Y, store into X
            SUB_XY     : STD_LOGIC_VECTOR (7 downto 0) := x"70";   -- Subtract X from Y, store into X
            AND_XY     : STD_LOGIC_VECTOR (7 downto 0) := x"50";   -- And X to Y, store in X
            OR_XY      : STD_LOGIC_VECTOR (7 downto 0) := x"D3";   -- Or X to Y, store in X
            INC_X      : STD_LOGIC_VECTOR (7 downto 0) := x"C1";   -- Increment X, store in X
            INC_Y      : STD_LOGIC_VECTOR (7 downto 0) := x"E2";   -- Increment Y, store in Y
            DEC_X      : STD_LOGIC_VECTOR (7 downto 0) := x"40";   -- decrement X, store in X
            DEC_Y      : STD_LOGIC_VECTOR (7 downto 0) := x"A2";   -- decrement Y, store in Y
            
            ADDXY      : STD_LOGIC_VECTOR (2 downto 0) := "000";   -- ALU Select for Adding X and Y
            SUBXY      : STD_LOGIC_VECTOR (2 downto 0) := "001";   -- ALU Select for Subtracting X and Y
            ANDXY      : STD_LOGIC_VECTOR (2 downto 0) := "010";   -- ALU Select for "and"-ing X and Y
            ORXY       : STD_LOGIC_VECTOR (2 downto 0) := "011";   -- ALU Select for "or"-ing X and Y
            INCX       : STD_LOGIC_VECTOR (2 downto 0) := "100";   -- ALU Select for incrementing X
            DECX       : STD_LOGIC_VECTOR (2 downto 0) := "101";   -- ALU Select for decrementing X
            INCY       : STD_LOGIC_VECTOR (2 downto 0) := "110";   -- ALU Select for incrementing Y
            DECY       : STD_LOGIC_VECTOR (2 downto 0) := "111");  -- ALU Select for decrementing Y                        
      
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
                    S_STYDIR_7,
                    
                    S_LDXDIR_4,             -- Load X with direct addressing
                    S_LDXDIR_5,
                    S_LDXDIR_6,
                    S_LDXDIR_7,
                    S_LDXDIR_8,
                    
                    S_LDYDIR_4,             -- Load Y with direct addressing
                    S_LDYDIR_5,
                    S_LDYDIR_6,
                    S_LDYDIR_7,
                    S_LDYDIR_8,
                    
                    S_ADDXY_4,              -- X <= X + Y states
                    S_ADDXY_5,
                    S_ADDXY_6,
                    S_ADDXY_7,
                    
                    S_SUBXY_4,              -- X <= X - Y states
                    S_SUBXY_5,
                    S_SUBXY_6,
                    
                    S_ANDXY_4,              -- X <= X AND Y states
                    S_ANDXY_5,
                    S_ANDXY_6,
                    
                    S_ORXY_4,              -- X <= X OR Y states
                    S_ORXY_5,
                    S_ORXY_6,
                    
                    S_INCX_4,              -- X <= X + 1 states
                    S_INCX_5,
                    S_INCX_6,
                    
                    S_INCY_4,              -- X <= Y + 1 states
                    S_INCY_5,
                    S_INCY_6,
                    
                    S_DECX_4,              -- X <= X - 1 states
                    S_DECX_5,
                    S_DECX_6,
                    
                    S_DECY_4,              -- X <= Y - 1 states
                    S_DECY_5,
                    S_DECY_6);

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

  NEXT_STATE_LOGIC : process(current_state, IR) --  Determines Next State (comb. logic)
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
        elsif (IR = LDX_DIR) then
          next_state <= S_LDXDIR_4;
        elsif (IR = LDY_DIR) then
          next_state <= S_LDYDIR_4;  
        elsif (IR = ADD_XY) then
          next_state <= S_ADDXY_4;
        elsif (IR = SUB_XY) then
          next_state <= S_SUBXY_4;
        elsif (IR = AND_XY) then
          next_state <= S_ANDXY_4;
        elsif (IR = OR_XY) then
          next_state <= S_ORXY_4;
        elsif (IR = INC_X) then
          next_state <= S_INCX_4;
        elsif (IR = INC_Y) then
          next_state <= S_INCY_4;
        elsif (IR = DEC_X) then
          next_state <= S_DECX_4;
        elsif (IR = DEC_Y) then
          next_state <= S_DECY_4;
		  else next_state <= S_FETCH_0; 
          
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
        
     elsif (current_state = S_LDXDIR_4) then   -- State tree for LDX_DIR instruction
        next_state <= S_LDXDIR_5;
      elsif (current_state = S_LDXDIR_5) then 
        next_state <= S_LDXDIR_6;
      elsif (current_state = S_LDXDIR_6) then 
        next_state <= S_LDXDIR_7;
      elsif (current_state = S_LDXDIR_7) then 
        next_state <= S_LDXDIR_8;
      elsif (current_state = S_LDXDIR_8) then 
        next_state <= S_FETCH_0;
      
      elsif (current_state = S_LDYDIR_4) then   -- State tree for LDY_DIR instruction
        next_state <= S_LDYDIR_5;
      elsif (current_state = S_LDYDIR_5) then 
        next_state <= S_LDYDIR_6;
      elsif (current_state = S_LDYDIR_6) then 
        next_state <= S_LDYDIR_7;
      elsif (current_state = S_LDYDIR_7) then 
        next_state <= S_LDYDIR_8;
      elsif (current_state = S_LDYDIR_8) then 
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
        
      elsif (current_state = S_ADDXY_4) then    -- State tree for ADD_XY instruction
        next_state <= S_ADDXY_5; 
      elsif (current_state = S_ADDXY_5) then    
        next_state <= S_ADDXY_6; 
      elsif (current_state = S_ADDXY_6) then    
        next_state <= S_FETCH_0; 
        
      elsif (current_state = S_SUBXY_4) then    -- State tree for SUB_XY instruction
        next_state <= S_SUBXY_5; 
      elsif (current_state = S_SUBXY_5) then    
        next_state <= S_SUBXY_6; 
      elsif (current_state = S_SUBXY_6) then    
        next_state <= S_FETCH_0;
        
      elsif (current_state = S_ANDXY_4) then    -- State tree for AND_XY instruction
        next_state <= S_ANDXY_5; 
      elsif (current_state = S_ANDXY_5) then    
        next_state <= S_ANDXY_6; 
      elsif (current_state = S_ANDXY_6) then    
        next_state <= S_FETCH_0;
        
      elsif (current_state = S_ORXY_4) then    -- State tree for OR_XY instruction
        next_state <= S_ORXY_5; 
      elsif (current_state = S_ORXY_5) then    
        next_state <= S_ORXY_6; 
      elsif (current_state = S_ORXY_6) then    
        next_state <= S_FETCH_0;
        
      elsif (current_state = S_INCX_4) then    -- State tree for INCX instruction
        next_state <= S_INCX_5; 
      elsif (current_state = S_INCX_5) then    
        next_state <= S_INCX_6; 
      elsif (current_state = S_INCX_6) then    
        next_state <= S_FETCH_0;
        
      elsif (current_state = S_INCY_4) then    -- State tree for INCY instruction
        next_state <= S_INCY_5; 
      elsif (current_state = S_INCY_5) then    
        next_state <= S_INCY_6; 
      elsif (current_state = S_INCY_6) then    
        next_state <= S_FETCH_0;
        
       elsif (current_state = S_DECX_4) then    -- State tree for DECX instruction
        next_state <= S_DECX_5; 
      elsif (current_state = S_DECX_5) then    
        next_state <= S_DECX_6; 
      elsif (current_state = S_DECX_6) then    
        next_state <= S_FETCH_0;
        
       elsif (current_state = S_DECY_4) then    -- State tree for DECY instruction
        next_state <= S_DECY_5; 
      elsif (current_state = S_DECY_5) then    
        next_state <= S_DECY_6; 
      elsif (current_state = S_DECY_6) then    
        next_state <= S_FETCH_0;
        
      else next_state <= S_FETCH_0;   
       
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
          
        when S_LDXDIR_4 =>  -- PC drives Bus1, Bus1 drives Bus2, Set MAR to load
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
          
        when S_LDXDIR_5 =>  -- Increment PC, Memory out drives Bus2, Set MAR to loads
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
          
        when S_LDXDIR_6 =>  -- Loads MAR with new address
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
          
        when S_LDXDIR_7 =>  -- Delay State to load the address
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
          
        when S_LDXDIR_8 =>  -- Set X to load
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
          
        when S_LDYDIR_4 =>  -- PC drives Bus1, Bus1 drives Bus2, Set MAR to load
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
          
        when S_LDYDIR_5 =>  -- Increment PC, Memory out drives Bus2, Set MAR to loads
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
          
        when S_LDYDIR_6 =>  -- Loads MAR with new address
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
          
        when S_LDYDIR_7 =>  -- Delay State to load the address
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
          
        when S_LDYDIR_8 =>  -- Set Y to load
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
          
        when S_ADDXY_4 =>   -- Sets X to drive Bus1, Sets Bus1 to drive Bus2, load Z
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '1';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "01";                                
          Bus2_Sel <= "01"; 
        
        when S_ADDXY_5 =>   -- Set CCR load, Get Y on Bus1, Add in ALU 
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= ADDXY;                    
          CCR_Load <= '1';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
          
        when S_ADDXY_6 =>   -- Load X with answer
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '1';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= ADDXY;                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
          
          when S_SUBXY_4 =>   -- Sets X to drive Bus1, Sets Bus1 to drive Bus2, load Z
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '1';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "01";                                
          Bus2_Sel <= "01"; 
        
        when S_SUBXY_5 =>   -- Set CCR load, Get Y on Bus1, Sub in ALU 
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= SUBXY;                    
          CCR_Load <= '1';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
          
        when S_SUBXY_6 =>   -- Load X with answer
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '1';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= SUBXY;                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
          
          when S_ANDXY_4 =>   -- Sets X to drive Bus1, Sets Bus1 to drive Bus2, load Z
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '1';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "01";                                
          Bus2_Sel <= "01"; 
        
        when S_ANDXY_5 =>   -- Set CCR load, Get Y on Bus1, AND in ALU 
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= ANDXY;                    
          CCR_Load <= '1';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
          
        when S_ANDXY_6 =>   -- Load X with answer
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '1';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= ANDXY;                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
          
          when S_ORXY_4 =>   -- Sets X to drive Bus1, Sets Bus1 to drive Bus2, load Z
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '1';         
          ALU_Sel  <= "000";                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "01";                                
          Bus2_Sel <= "01"; 
        
        when S_ORXY_5 =>   -- Set CCR load, Get Y on Bus1, OR in ALU 
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= ORXY;                    
          CCR_Load <= '1';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
          
        when S_ORXY_6 =>   -- Load X with answer
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '1';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= ORXY;                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
        
        when S_INCX_4 =>   -- Sets X to drive Bus1, Sets Bus1 to drive Bus2
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
          Bus1_Sel <= "01";                                
          Bus2_Sel <= "01"; 
        
        when S_INCX_5 =>   -- Set CCR load, INCX in ALU 
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= INCX;                    
          CCR_Load <= '1';                     
          Bus1_Sel <= "01";                                
          Bus2_Sel <= "00";
          
        when S_INCX_6 =>   -- Load X with answer
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '1';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= INCX;                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "00";
          
          when S_INCY_4 =>   -- Sets Y to drive Bus1
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
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00"; 
        
        when S_INCY_5 =>   -- Set CCR load, INCY in ALU 
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= INCY;                    
          CCR_Load <= '1';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
          
        when S_INCY_6 =>   -- Load Y with answer
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '1';                   
          Z_Load   <= '0';         
          ALU_Sel  <= INCY;                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "00";
          
          when S_DECX_4 =>   -- Sets X to drive Bus1, Sets Bus1 to drive Bus2, 
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
          Bus1_Sel <= "01";                                
          Bus2_Sel <= "01";
        
        when S_DECX_5 =>   -- Set CCR load,  DECX in ALU 
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= DECX;                    
          CCR_Load <= '1';                     
          Bus1_Sel <= "01";                                
          Bus2_Sel <= "00";
          
        when S_DECX_6 =>   -- Load X with answer
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '1';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= DECX;                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "00";
          
          when S_DECY_4 =>   -- Sets Y to drive Bus1, Sets Bus1 to drive Bus2, 
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
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00"; 
        
        when S_DECY_5 =>   -- Set CCR load, Get Y on Bus1, DECY in ALU 
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '0';                   
          Z_Load   <= '0';         
          ALU_Sel  <= DECY;                    
          CCR_Load <= '1';                     
          Bus1_Sel <= "10";                                
          Bus2_Sel <= "00";
          
        when S_DECY_6 =>   -- Load Y with answer
          Write    <= '0';        
          IR_Load  <= '0';            
          MAR_Load <= '0';                    
          PC_Load  <= '0';    
          PC_Inc   <= '0';                       
          X_Load   <= '0';   
          Y_Load   <= '1';                   
          Z_Load   <= '0';         
          ALU_Sel  <= DECY;                    
          CCR_Load <= '0';                     
          Bus1_Sel <= "00";                                
          Bus2_Sel <= "00";
          
        when others => 
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
          Bus2_Sel <= "00";
          
      end case;
    end process;

end architecture rtl;
