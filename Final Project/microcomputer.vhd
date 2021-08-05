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
             port_out_01    : out  std_logic_vector (7 downto 0);
             port_out_02    : out  std_logic_vector (7 downto 0);
             port_out_03    : out  std_logic_vector (7 downto 0);
             port_out_04    : out  std_logic_vector (7 downto 0);
             port_out_05    : out  std_logic_vector (7 downto 0);
             port_out_06    : out  std_logic_vector (7 downto 0);
             port_out_07    : out  std_logic_vector (7 downto 0);
             port_out_08    : out  std_logic_vector (7 downto 0);
             port_out_09    : out  std_logic_vector (7 downto 0);
             port_out_10    : out  std_logic_vector (7 downto 0);
             port_out_11    : out  std_logic_vector (7 downto 0);
             port_out_12    : out  std_logic_vector (7 downto 0);
             port_out_13    : out  std_logic_vector (7 downto 0);
             port_out_14    : out  std_logic_vector (7 downto 0);
             port_out_15    : out  std_logic_vector (7 downto 0);
             port_out_16    : out  std_logic_vector (7 downto 0);
             port_out_17    : out  std_logic_vector (7 downto 0);
             port_in_00     : in   std_logic_vector (7 downto 0);
             port_in_01     : in   std_logic_vector (7 downto 0);
             port_in_02     : in   std_logic_vector (7 downto 0);
             port_in_03     : in   std_logic_vector (7 downto 0));
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
      port ( clock           : in  std_logic;
             reset           : in  std_logic;
             address         : in  std_logic_vector (7 downto 0);
             write           : in  std_logic;
             data_in         : in  std_logic_vector (7 downto 0);
             data_out        : out std_logic_vector (7 downto 0);
             port_out_00     : out std_logic_vector (7 downto 0);
             port_out_01     : out std_logic_vector (7 downto 0);
             port_out_02     : out std_logic_vector (7 downto 0);
             port_out_03     : out std_logic_vector (7 downto 0);
             port_out_04     : out std_logic_vector (7 downto 0);
             port_out_05     : out std_logic_vector (7 downto 0);
             port_out_06     : out std_logic_vector (7 downto 0);
             port_out_07     : out std_logic_vector (7 downto 0);
             port_out_08     : out std_logic_vector (7 downto 0);
             port_out_09     : out std_logic_vector (7 downto 0);
             port_out_10     : out std_logic_vector (7 downto 0);
             port_out_11     : out std_logic_vector (7 downto 0);
             port_out_12     : out std_logic_vector (7 downto 0);
             port_out_13     : out std_logic_vector (7 downto 0);
             port_out_14     : out std_logic_vector (7 downto 0);
             port_out_15     : out std_logic_vector (7 downto 0);
             port_out_16     : out std_logic_vector (7 downto 0);
             port_out_17     : out std_logic_vector (7 downto 0);
             port_in_00      : in  std_logic_vector (7 downto 0);
             port_in_01      : in  std_logic_vector (7 downto 0);
             port_in_02      : in  std_logic_vector (7 downto 0);
             port_in_03      : in  std_logic_vector (7 downto 0));
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
					       port_out_01 => port_out_01,
					       port_out_02 => port_out_02,
					       port_out_03 => port_out_03,
					       port_out_04 => port_out_04,
					       port_out_05 => port_out_05,
					       port_out_06 => port_out_06,
					       port_out_07 => port_out_07,
					       port_out_08 => port_out_08,
					       port_out_09 => port_out_09,
					       port_out_10 => port_out_10,
					       port_out_11 => port_out_11,
					       port_out_12 => port_out_12,
					       port_out_13 => port_out_13,
					       port_out_14 => port_out_14,
					       port_out_15 => port_out_15,
					       port_out_16 => port_out_16,
					       port_out_17 => port_out_17,
                 port_in_00  => port_in_00,
                 port_in_01  => port_in_01,
                 port_in_02  => port_in_02,
                 port_in_03  => port_in_03 );
          
                
       
end architecture;