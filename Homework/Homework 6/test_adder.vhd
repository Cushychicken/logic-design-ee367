-----------------------------------------------------------------
-- File name   : test_adder.vhd
--
-- Project     : Adders
--
-- Description : VHDL testbench
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
library IEEE;              
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;    
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity test_adder is
end entity test_adder;

architecture test_adder_arch of test_adder is

 -- Constant Declaration
  constant t_wait : time := 10 ns; 


 -- Component Declaration   
  component rca -- Ripple Carry Adder
    port    (A, B        : in   STD_LOGIC_VECTOR (3 downto 0);
             Sum         : out  STD_LOGIC_VECTOR (3 downto 0);
             Cout        : out  STD_LOGIC);
  end component;

  component cla -- Carry Look-Ahead Adder
    port    (A, B        : in   STD_LOGIC_VECTOR (3 downto 0);
             Sum         : out  STD_LOGIC_VECTOR (3 downto 0);
             Cout        : out  STD_LOGIC);
  end component;


 -- Signal Declaration
  signal   A_tb, B_tb       : STD_LOGIC_VECTOR (3 downto 0);
  signal   Srca_tb, Scla_tb : STD_LOGIC_VECTOR (3 downto 0);
  signal   Crca_tb, Ccla_tb : STD_LOGIC;

  begin

 -- Component Instantiation
  RCA1 :   rca port map (A    => A_tb,
                         B    => B_tb,
                         Sum  => Srca_tb,
                         Cout => Crca_tb);
                         
  CLA1 :   cla port map (A    => A_tb,
                         B    => B_tb,
                         Sum  => Scla_tb,
                         Cout => Ccla_tb);



 -- Stimulus Generation & Output Checking
  STIMULUS : process
  
                  variable A_var_tb      : STD_LOGIC_VECTOR (3 downto 0);
                  variable B_var_tb      : STD_LOGIC_VECTOR (3 downto 0);                  
                  variable Sum_Check_TB  : STD_LOGIC_VECTOR (4 downto 0);              
  
                  begin
                     report "EE 367 - Testbench for Adders" severity NOTE;       
  
                     for i in 0 to 15 loop               
                 
                          A_var_tb := conv_std_logic_vector (i, 4);
            
                          for j in 0 to 15 loop
                      
                                B_var_tb := conv_std_logic_vector (j, 4);  
                
                                -- automated verification
                                A_tb <= A_var_tb;
                                B_tb <= B_var_tb;
    
                                wait for t_wait; -- suspend the process so signal assignments take place

                                Sum_Check_TB := ('0' & A_var_tb) + ('0' & B_var_tb);
                            
                                report "Testing Adder" severity NOTE;

                                assert (Sum_Check_TB = (Crca_tb & Srca_tb)) report "RCA Failure" severity FAILURE;
                                assert (Sum_Check_TB = (Ccla_tb & Scla_tb)) report "CLA Failure" severity FAILURE;                                
       
                          end loop;
                                                  
                     end loop;
                    
      end process STIMULUS;
      
end architecture test_adder_arch;
                 

