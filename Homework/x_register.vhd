------------------------------------------------------------------------------------------------------------
-- File name   : x_register.vhd
--
-- Project     : EELE367 - Logic Design
--               
-- Description : VHDL model of a 16 x 8-bit ROM memory system that has been initialized
--
-- Author(s)   : Nash Reilly
--
-- Date        : April 11, 2011
--
-- Note(s)     : Data load register
-- 
--              Address      Description
--              ----------------------------------
--              $0           
--               :           Read Only Memory 
--              $F            (16x8-bit)              
--
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity x_register is
    port(D                        : in std_logic_vector(7 downto 0);
         x_reg_load, clock, reset : in std_logic;
         x_reg                    : out std_logic_vector(7 downto 0));
         
end entity;

architecture x_register_arch of x_register is

  component dflipflop
    port   (Clock           : in   STD_LOGIC;
            Reset           : in   STD_LOGIC;
            D               : in   STD_LOGIC;
            Q, Qn           : out  STD_LOGIC);
  end component;
  
  begin
    
    gen1 : for i in 0 to 7 generate
    
    U1   : dflipflop port map (Clock=>clock, Reset=>reset, D=>D(i), Q=>x_reg(i));
    
    end generate;
end architecture;    
