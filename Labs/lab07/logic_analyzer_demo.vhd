-----------------------------------------------------------------------------------
-- File name   : logic_analyzer_demo.vhd
--
-- Project     : Logic Analyzer Demo in the MSU Digital Lab
--
-- Description : VHDL model of a 16-bit counter with selectable clock frequency
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : February 22, 2011
--
-- Note(s)     : The input clock is "CLOCK_50" which is an on board 50MHz clock.
--					  This clock is ran through a clock divider circuit that will produce
--					  16 versions of the clock, each divided down by different amounts.
--               The frequencies are selected using SW(3:0).
--
--					  The clock is used to drive a 16-bit binary counter.  The counter 
--               is output to the Green LEDs in addition to the 
--
------------------------------------------------------------------------------------

LIBRARY ieee ;
USE IEEE.STD_LOGIC_1164.ALL ;
use IEEE.STD_LOGIC_ARITH.ALL;    --  
use IEEE.STD_LOGIC_UNSIGNED.ALL; --


ENTITY logic_analyzer_demo IS
	PORT ( SW       : IN  STD_LOGIC_VECTOR(17 downto 0) ;
	       KEY      : IN  STD_LOGIC_VECTOR(3 downto 0) ;
			 CLOCK_50 : IN  STD_LOGIC;
			 
          LEDR     : OUT STD_LOGIC_VECTOR(17 downto 0) ;
			 LEDG     : OUT STD_LOGIC_VECTOR(7 downto 0) ;
			 GPIO_0   : OUT STD_LOGIC_VECTOR(35 downto 0) );
			 
END logic_analyzer_demo ;

ARCHITECTURE logic_analyzer_demo_arch OF logic_analyzer_demo IS

  component clock_div 
    port   (Clock_In     : in   STD_LOGIC;
            Reset        : in   STD_LOGIC;
            Sel          : in   STD_LOGIC_VECTOR(4 downto 0);
            Clock_Out    : out  STD_LOGIC);
  end component;
  
  signal  Clock, Reset        : STD_LOGIC;
  signal  Counter_Out         : STD_LOGIC_VECTOR(15 downto 0);
  signal  Logic_Analyzer_Port : STD_LOGIC_VECTOR(16 downto 0);
  signal  Freq_Sel            : STD_LOGIC_VECTOR(4 downto 0);  
  

	BEGIN

   -- Mapping Internal Signal names to DE2 IO 

	   Reset                            <= KEY(0);
	   Freq_Sel                         <= SW(4 downto 0);
		LEDR(15 downto 0)                <= Counter_Out(15 downto 0);
		LEDG(4 downto 0)                 <= SW(4 downto 0);

	   Logic_Analyzer_Port(15 downto 0) <= Counter_Out(15 downto 0);
	   Logic_Analyzer_Port(16)          <= Clock;


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
	-- Clock Divider Section
	---------------------------------------------------------------------

   U1 : clock_div port map  (Clock_In  => CLOCK_50,
                             Reset     => Reset,
                             Sel       => Freq_Sel,
                             Clock_Out => Clock);
  
  
	---------------------------------------------------------------------
	-- Counter Section
	---------------------------------------------------------------------	

	COUNTER : process (Clock, Reset) 
        begin
    
            if (Reset = '0') then 
                 Counter_Out <= "0000000000000000";
         
            elsif (Clock='1' and Clock'event and SW(17)='0') then
                 Counter_Out <= Counter_Out + 1;
			   elsif (Clock='1' and Clock'event and SW(17)='1') then
                 Counter_Out <= Counter_Out - 1;
            end if;

			end process;
 

 	
END logic_analyzer_demo_arch ;