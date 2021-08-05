------------------------------------------------------------------------------------------------------------
-- File name   : microcomputer.vhd
--
-- Project     : 8-Bit Microcomputer
--
-- Description : VHDL model of an 8-bit MicroComputer
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Note(s)     : 
--               
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
  
entity microcomputer is
    port   ( clock          : in   std_logic;
             reset          : in   std_logic;
             port_out_00    : out  std_logic_vector (7 downto 0);
             port_in_00     : in   std_logic_vector (7 downto 0));
end entity;

architecture rtl of microcomputer is

 -- Component Declaration

    component cpu
      port ( clock           : in  std_logic;
             reset           : in  std_logic;
             memory_in       : out std_logic_vector (7 downto 0);
             memory_out      : in  std_logic_vector (7 downto 0);             
             address         : out std_logic_vector (7 downto 0);
             write           : out std_logic);    
    end component;

    component memory
      port  (clock           : in  std_logic;
             reset           : in  std_logic;
             address         : in  std_logic_vector (7 downto 0);
             write           : in  std_logic;
             data_in         : in  std_logic_vector (7 downto 0);
             data_out        : out std_logic_vector (7 downto 0);            
             port_out_00     : out std_logic_vector (7 downto 0);
             port_in_00      : in  std_logic_vector (7 downto 0));
    end component;


 -- Signal Declaration
 
    signal   memory_data_in  : STD_LOGIC_VECTOR (7 downto 0);
    signal   memory_data_out : STD_LOGIC_VECTOR (7 downto 0);    
    signal   memory_address  : STD_LOGIC_VECTOR (7 downto 0);
    signal   memory_write    : STD_LOGIC;
 
    begin

 -- Component Instantiations
    CPU_1 : cpu
      port map ( clock       => clock,
                 reset       => reset,
                 memory_in   => memory_data_in,
                 memory_out  => memory_data_out,
                 address     => memory_address,
                 write       => memory_write);    

    MEMORY_1 : memory
      port map ( clock       => clock,
                 reset       => reset,        
                 address     => memory_address,
                 write       => memory_write,
                 data_in     => memory_data_in,
                 data_out    => memory_data_out,
                 port_out_00 => port_out_00,
                 port_in_00  => port_in_00 );
                
       
end architecture;