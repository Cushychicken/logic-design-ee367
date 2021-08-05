-----------------------------------------------------------------
-- File name   : test_logic_gates.vhd 
--
-- Project     : Basic Gates 
--
-- Description : VHDL testbench of all 1 or 2-input logic gate
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : January 25, 2011
--
-- Note(s)     : This file is a test bench
--
-----------------------------------------------------------------
library IEEE;                    -- this library adds additional capability for VHDL
use IEEE.STD_LOGIC_1164.ALL;     -- this package has "STD_LOGIC" data types

entity test_logic_gates is
end entity test_logic_gates;

architecture test_logic_gates_arch of test_logic_gates is
    
  component inv1  port  (In1:     in STD_LOGIC; Out1: out STD_LOGIC); end component;
  component buf1  port  (In1:     in STD_LOGIC; Out1: out STD_LOGIC); end component;
  component and2  port  (In1,In2: in STD_LOGIC; Out1: out STD_LOGIC); end component;
  component nand2 port  (In1,In2: in STD_LOGIC; Out1: out STD_LOGIC); end component;        
  component or2   port  (In1,In2: in STD_LOGIC; Out1: out STD_LOGIC); end component;                
  component nor2  port  (In1,In2: in STD_LOGIC; Out1: out STD_LOGIC); end component;                        
  component xor2  port  (In1,In2: in STD_LOGIC; Out1: out STD_LOGIC); end component;                              
  component xnor2 port  (In1,In2: in STD_LOGIC; Out1: out STD_LOGIC); end component;                              
        

  signal    In1,In2   : STD_LOGIC;                        -- setup internal "input" signals 
  signal    Out_inv1  : STD_LOGIC;                        -- setup internal "output" signals   
  signal    Out_buf1  : STD_LOGIC;                        -- setup internal "output" signals   
  signal    Out_and2  : STD_LOGIC;                        -- setup internal "output" signals 
  signal    Out_nand2 : STD_LOGIC;                        -- setup internal "output" signals 
  signal    Out_or2   : STD_LOGIC;                        -- setup internal "output" signals   
  signal    Out_nor2  : STD_LOGIC;                        -- setup internal "output" signals   
  signal    Out_xor2  : STD_LOGIC;                        -- setup internal "output" signals   
  signal    Out_xnor2 : STD_LOGIC;                        -- setup internal "output" signals   

  
  begin
      U1 :   inv1   port map (In1, Out_inv1);       --instantiate "inv1"
      U2 :   buf1   port map (In1, Out_buf1);       --instantiate "but1"
      U3 :   and2   port map (In1, In2, Out_and2);  --instantiate "and2"
      U4 :   nand2  port map (In1, In2, Out_nand2); --instantiate "nand2"      
      U5 :   or2    port map (In1, In2, Out_or2);   --instantiate "or2"      
      U6 :   nor2   port map (In1, In2, Out_nor2);  --instantiate "nor2"      
      U7 :   xor2   port map (In1, In2, Out_xor2);  --instantiate "xor2"      
      U8 :   xnor2  port map (In1, In2, Out_xnor2); --instantiate "xnor2"      


      stimulus : process
                  begin
                     In2 <= '0';   In1 <= '0';
                     wait for 10 ns;
                     In2 <= '0';   In1 <= '1';
                     wait for 10 ns;
                     In2 <= '1';   In1 <= '0';
                     wait for 10 ns;
                     In2 <= '1';   In1 <= '1';
                     wait for 10 ns;
                     
                     
      end process stimulus;
      
end architecture test_logic_gates_arch;
