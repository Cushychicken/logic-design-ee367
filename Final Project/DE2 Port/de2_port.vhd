------------------------------------------------------------------------------------------------------------
-- File name   : de2_port.vhd
--
-- Project     : 8-Bit MicroComputer instantiation on Cyclone II FPGA
--
-- Description : VHDL instantiation on FPGA
--
-- Author(s)   : Nash Reilly
--               Montana State University
--               
--
-- Note(s)     : This file contains the Entity and Architecture
--               
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity de2_port is 
	PORT ( SW       : IN  STD_LOGIC_VECTOR(17 downto 0) ;
	       KEY      : IN  STD_LOGIC_VECTOR(3  downto 0) ;
			 CLOCK_50 : IN  STD_LOGIC;
			 
          LEDR     : OUT STD_LOGIC_VECTOR(17 downto 0) ;
			 LEDG     : OUT STD_LOGIC_VECTOR(8  downto 0) ;
			 GPIO_0   : OUT STD_LOGIC_VECTOR(35 downto 0) ;
			 HEX0     : OUT STD_LOGIC_VECTOR(6  downto 0) ;
			 HEX1     : OUT STD_LOGIC_VECTOR(6  downto 0) ;
			 HEX2     : OUT STD_LOGIC_VECTOR(6  downto 0) ;
			 HEX3     : OUT STD_LOGIC_VECTOR(6  downto 0) ;
			 HEX4     : OUT STD_LOGIC_VECTOR(6  downto 0) ;
			 HEX5     : OUT STD_LOGIC_VECTOR(6  downto 0) ;
			 HEX6     : OUT STD_LOGIC_VECTOR(6  downto 0) ;
			 HEX7     : OUT STD_LOGIC_VECTOR(6  downto 0) );
			 
end entity;

architecture de2_port_arch of de2_port is

  component microcomputer
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
  end component;

  signal  Clock, Reset        : STD_LOGIC;
  signal  Logic_Analyzer_Port : STD_LOGIC_VECTOR(16 downto 0);
  signal  Memory_In_0			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_In_1			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_In_2			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_In_3			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_0			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_1			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_2			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_3			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_4			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_5			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_6			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_7			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_8			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_9			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_10			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_11			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_12			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_13			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_14			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_15			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_16			: STD_LOGIC_VECTOR(7  downto 0);
  signal  Memory_Out_17			: STD_LOGIC_VECTOR(7  downto 0);
  
  begin

  ---------------------------------------------------------------------
  -- Signal Assignments
  ---------------------------------------------------------------------
  
  --INPUTS
  
  Clock 		  <= CLOCK_50;
  Reset       <= KEY(0);
  Memory_In_0 <= SW( 7 downto  0);
  Memory_In_1 <= SW(15 downto  8);
  Memory_In_2 <= "000000" & SW(17 downto 16);
  Memory_In_3 <= "00000"  & KEY(3 downto 1);
  
  --OUTPUTS
  
  LEDR( 7 downto  0)   					<= Memory_Out_0( 7 downto 0);
  LEDR(15 downto  8)   					<= Memory_Out_1( 7 downto 0);
  LEDR(17 downto 16)   					<= Memory_Out_2( 1 downto 0);
  LEDG(7  downto  0)   					<= Memory_Out_3;
  LEDG(8) 				  					<= Memory_Out_4(0);
  HEX0       		     					<= Memory_Out_5( 6 downto 0);
  HEX1        			  					<= Memory_Out_6( 6 downto 0);
  HEX2        			  					<= Memory_Out_7( 6 downto 0);
  HEX3        			  					<= Memory_Out_8( 6 downto 0);
  HEX4        			 				   <= Memory_Out_9( 6 downto 0);
  HEX5        			  					<= Memory_Out_10(6 downto 0);
  HEX6        			  					<= Memory_Out_11(6 downto 0);
  HEX7        			  					<= Memory_Out_12(6 downto 0);
  Logic_Analyzer_Port( 7 downto  0) <= Memory_Out_13(7 downto 0);
  Logic_Analyzer_Port(15 downto  8) <= Memory_Out_14(7 downto 0);
  Logic_Analyzer_Port(16) 				<= Memory_Out_15(0);
 
   -- Connecting the internal signal "Logic_Analyzer_Port" to the GPIO_0 connector 
	-- per the probe setup.
		
  GPIO_0(0)  <= '0';
  GPIO_0(1)  <= Logic_Analyzer_Port(0);
  GPIO_0(2)  <= '0';
  GPIO_0(3)  <= Logic_Analyzer_Port(1);
  GPIO_0(4)  <= '0';
  GPIO_0(5)  <= Logic_Analyzer_Port(2);
  GPIO_0(6)  <= '0';
  GPIO_0(7)  <= Logic_Analyzer_Port(3);
  GPIO_0(8)  <= '0';
  GPIO_0(9)  <= Logic_Analyzer_Port(4);
  GPIO_0(10) <= '0';
  GPIO_0(11) <= Logic_Analyzer_Port(5);
  GPIO_0(12) <= '0';
  GPIO_0(13) <= Logic_Analyzer_Port(6);
  GPIO_0(14) <= '0';
  GPIO_0(15) <= Logic_Analyzer_Port(7);
  GPIO_0(16) <= '0';
  GPIO_0(17) <= Logic_Analyzer_Port(8);
  GPIO_0(18) <= '0';
  GPIO_0(19) <= Logic_Analyzer_Port(9);
  GPIO_0(20) <= '0';
  GPIO_0(21) <= Logic_Analyzer_Port(10);
  GPIO_0(22) <= '0';
  GPIO_0(23) <= Logic_Analyzer_Port(11);
  GPIO_0(24) <= '0';
  GPIO_0(25) <= Logic_Analyzer_Port(12);
  GPIO_0(26) <= '0';
  GPIO_0(27) <= Logic_Analyzer_Port(13);
  GPIO_0(28) <= '0';
  GPIO_0(29) <= Logic_Analyzer_Port(14);
  GPIO_0(30) <= '0';
  GPIO_0(31) <= Logic_Analyzer_Port(15);
  GPIO_0(32) <= '0';
  GPIO_0(33) <= Logic_Analyzer_Port(16);
  GPIO_0(34) <= '0';
  GPIO_0(35) <= '0';
		
 
  ---------------------------------------------------------------------
  -- Microcontroller Instantiation
  ---------------------------------------------------------------------
    
  U1 : microcomputer port map  (clock         => Clock,
										  reset         => Reset,
										  port_out_00   => Memory_Out_0,
										  port_out_01   => Memory_Out_1,
										  port_out_02   => Memory_Out_2,
										  port_out_03   => Memory_Out_3,
										  port_out_04   => Memory_Out_4,
										  port_out_05   => Memory_Out_5,
										  port_out_06   => Memory_Out_6,
										  port_out_07   => Memory_Out_7,
										  port_out_08   => Memory_Out_8,
										  port_out_09   => Memory_Out_9,
										  port_out_10   => Memory_Out_10,
										  port_out_11   => Memory_Out_11,
										  port_out_12   => Memory_Out_12,
										  port_out_13   => Memory_Out_13,
										  port_out_14   => Memory_Out_14,
										  port_out_15   => Memory_Out_15,
										  port_out_16   => Memory_Out_16,
										  port_out_17   => Memory_Out_17,
										  port_in_00    => Memory_In_0,
										  port_in_01    => Memory_In_1,
										  port_in_02    => Memory_In_2,
										  port_in_03    => Memory_In_3);
									
										 
end architecture;
										 

		
		