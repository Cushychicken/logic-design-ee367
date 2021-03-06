------------------------------------------------------------------------------------------------------------
-- File name   : clock_div.vhd
--
-- Project     : EE367 - Logic Design
--               
-- Description : VHDL model of a clock divider using D-Flip-Flops
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Date        : February 22, 2011
--
-- Note(s)     : The input clock is "Clock_In" which is an on board 50MHz clock.
--					  This clock is ran through a clock divider circuit that will produce
--					  16 versions of the clock, each divided down by different amounts.
--               SW(3:0) are used to select the clock version that will used as
--					  the system clock "Clock_Out" as follows:
--
-- 						SW(4:0) = "00000" => (Div 1)      Clock_Out = 50      MHz => (T=20    ns)
-- 						SW(4:0) = "00001" => (Div 2)      Clock_Out = 25      MHz => (T=40    ns)
-- 						SW(4:0) = "00010" => (Div 4)      Clock_Out = 12.5    MHz => (T=80    ns)
-- 						SW(4:0) = "00011" => (Div 8)      Clock_Out = 6.25    MHz => (T=160   ns)
--
-- 						SW(4:0) = "00100" => (Div 16)     Clock_Out = 3.125   MHz => (T=320   ns)
-- 						SW(4:0) = "00101" => (Div 32)     Clock_Out = 1.5625  MHz => (T=640   ns)
-- 						SW(4:0) = "00110" => (Div 64)     Clock_Out = 781.250 kHz => (T=1.28  us)
-- 						SW(4:0) = "00111" => (Div 128)    Clock_Out = 390.625 kHz => (T=2.56  us)
--
-- 						SW(4:0) = "01000" => (Div 256)    Clock_Out = 195.312 kHz => (T=5.12  us)
-- 						SW(4:0) = "01001" => (Div 512)    Clock_Out = 97.656  kHz => (T=10.24 us)
-- 						SW(4:0) = "01010" => (Div 1024)   Clock_Out = 48.828  kHz => (T=20.48 us)
-- 						SW(4:0) = "01011" => (Div 2048)   Clock_Out = 24,414  kHz => (T=40.96 us)
--
-- 						SW(4:0) = "01100" => (Div 4096)   Clock_Out = 12.207  kHz => (T=81.92 us)
-- 						SW(4:0) = "01101" => (Div 8192)   Clock_Out = 6.104   kHz => (T=163.8 us)
-- 						SW(4:0) = "01110" => (Div 16,384) Clock_Out = 3.052   kHz => (T=327.7 us)
-- 						SW(4:0) = "01111" => (Div 32,768) Clock_Out = 1.526   kHz => (T=655.4 us)
--
--                                               :
--
--                   SW(4:0) = "11111" => (Div 32,768) Clock_Out = 1.526   kHz => (T=655.4 us)
------------------------------------------------------------------------------------------------------------
library IEEE;              
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_div is
    port   (Clock_In     : in   STD_LOGIC;
            Reset        : in   STD_LOGIC;
            Sel          : in   STD_LOGIC_VECTOR(4 downto 0);
            Clock_Out    : out  STD_LOGIC);
end entity clock_div;

architecture clock_div_arch of clock_div is

  signal   Q, Qn         : STD_LOGIC_VECTOR(31 downto 1);

  component dflipflop 
    port   (Clock           : in   STD_LOGIC;
            Reset           : in   STD_LOGIC;
            D               : in   STD_LOGIC;
            Q, Qn           : out  STD_LOGIC);
  end component;
  
  begin
      
    D1  : dflipflop port map (Clock => Clock_In, Reset => Reset, D => Qn(1),  Q => Q(1),  Qn => Qn(1)   );
	 D2  : dflipflop port map (Clock => Q(1),     Reset => Reset, D => Qn(2),  Q => Q(2),  Qn => Qn(2)   );
	 D3  : dflipflop port map (Clock => Q(2),     Reset => Reset, D => Qn(3),  Q => Q(3),  Qn => Qn(3)   );
	 D4  : dflipflop port map (Clock => Q(3),     Reset => Reset, D => Qn(4),  Q => Q(4),  Qn => Qn(4)   );
	 
	 D5  : dflipflop port map (Clock => Q(4),     Reset => Reset, D => Qn(5),  Q => Q(5),  Qn => Qn(5)   );
	 D6  : dflipflop port map (Clock => Q(5),     Reset => Reset, D => Qn(6),  Q => Q(6),  Qn => Qn(6)   );
	 D7  : dflipflop port map (Clock => Q(6),     Reset => Reset, D => Qn(7),  Q => Q(7),  Qn => Qn(7)   );
	 D8  : dflipflop port map (Clock => Q(7),     Reset => Reset, D => Qn(8),  Q => Q(8),  Qn => Qn(8)   );
	 
	 D9  : dflipflop port map (Clock => Q(8),     Reset => Reset, D => Qn(9),  Q => Q(9),  Qn => Qn(9)   );
	 D10 : dflipflop port map (Clock => Q(9),     Reset => Reset, D => Qn(10), Q => Q(10), Qn => Qn(10)  );
	 D11 : dflipflop port map (Clock => Q(10),    Reset => Reset, D => Qn(11), Q => Q(11), Qn => Qn(11)  );
	 D12 : dflipflop port map (Clock => Q(11),    Reset => Reset, D => Qn(12), Q => Q(12), Qn => Qn(12)  );
	 
	 D13 : dflipflop port map (Clock => Q(12),    Reset => Reset, D => Qn(13), Q => Q(13), Qn => Qn(13)  );
	 D14 : dflipflop port map (Clock => Q(13),    Reset => Reset, D => Qn(14), Q => Q(14), Qn => Qn(14)  );
	 D15 : dflipflop port map (Clock => Q(14),    Reset => Reset, D => Qn(15), Q => Q(15), Qn => Qn(15) );
	 D16 : dflipflop port map (Clock => Q(15),    Reset => Reset, D => Qn(16), Q => Q(16), Qn => Qn(16) );
	 
	 D17 : dflipflop port map (Clock => Q(16),    Reset => Reset, D => Qn(17), Q => Q(17), Qn => Qn(17) );
	 D18 : dflipflop port map (Clock => Q(17),    Reset => Reset, D => Qn(18), Q => Q(18), Qn => Qn(18) );
	 D19 : dflipflop port map (Clock => Q(18),    Reset => Reset, D => Qn(19), Q => Q(19), Qn => Qn(19) );
	 D20 : dflipflop port map (Clock => Q(19),    Reset => Reset, D => Qn(20), Q => Q(20), Qn => Qn(20) );

	 D21 : dflipflop port map (Clock => Q(20),    Reset => Reset, D => Qn(21), Q => Q(21), Qn => Qn(21) );
	 D22 : dflipflop port map (Clock => Q(21),    Reset => Reset, D => Qn(22), Q => Q(22), Qn => Qn(22) );
	 D23 : dflipflop port map (Clock => Q(22),    Reset => Reset, D => Qn(23), Q => Q(23), Qn => Qn(23) );
	 D24 : dflipflop port map (Clock => Q(23),    Reset => Reset, D => Qn(24), Q => Q(24), Qn => Qn(24) );

	 D25 : dflipflop port map (Clock => Q(24),    Reset => Reset, D => Qn(25), Q => Q(25), Qn => Qn(25) );
	 D26 : dflipflop port map (Clock => Q(25),    Reset => Reset, D => Qn(26), Q => Q(26), Qn => Qn(26) );
	 D27 : dflipflop port map (Clock => Q(26),    Reset => Reset, D => Qn(27), Q => Q(27), Qn => Qn(27) );
	 D28 : dflipflop port map (Clock => Q(27),    Reset => Reset, D => Qn(28), Q => Q(28), Qn => Qn(28) );

	 D29 : dflipflop port map (Clock => Q(28),    Reset => Reset, D => Qn(29), Q => Q(29), Qn => Qn(29) );
	 D30 : dflipflop port map (Clock => Q(29),    Reset => Reset, D => Qn(30), Q => Q(30), Qn => Qn(30) );
	 D31 : dflipflop port map (Clock => Q(30),    Reset => Reset, D => Qn(31), Q => Q(31), Qn => Qn(31) );
	 
    
    MUX32to1 : process (Clock_In, Q, Sel)
       begin
          case (Sel) is
            when "00000"   => Clock_Out <= Clock_In;    -- Div 1
            when "00001"   => Clock_Out <= Q(1);        -- Div 2
            when "00010"   => Clock_Out <= Q(2);        -- Div 4
            when "00011"   => Clock_Out <= Q(3);        -- Div 8
				
            when "00100"   => Clock_Out <= Q(4);        -- Div 16
            when "00101"   => Clock_Out <= Q(5);        -- Div 32                
            when "00110"   => Clock_Out <= Q(6);        -- Div 64
            when "00111"   => Clock_Out <= Q(7);        -- Div 128

            when "01000"   => Clock_Out <= Q(8);        -- Div 256
            when "01001"   => Clock_Out <= Q(9);        -- Div 512                
            when "01010"   => Clock_Out <= Q(10);       -- Div 1028
            when "01011"   => Clock_Out <= Q(11);       -- Div 2048

            when "01100"   => Clock_Out <= Q(12);       -- Div 2096
            when "01101"   => Clock_Out <= Q(13);       -- Div 8,192                
            when "01110"   => Clock_Out <= Q(14);       -- Div 16,384
            when "01111"   => Clock_Out <= Q(15);       -- Div 32,768
				
            when "10000"   => Clock_Out <= Q(16);       -- Div 65k
            when "10001"   => Clock_Out <= Q(17);       -- Div 131k
            when "10010"   => Clock_Out <= Q(18);       -- Div 262k
            when "10011"   => Clock_Out <= Q(19);       -- Div 524k
				
            when "10100"   => Clock_Out <= Q(20);       -- Div 1M
            when "10101"   => Clock_Out <= Q(21);       -- Div 2M                
            when "10110"   => Clock_Out <= Q(22);       -- Div 4M
            when "10111"   => Clock_Out <= Q(23);       -- Div 8M

            when "11000"   => Clock_Out <= Q(24);       -- Div 16M
            when "11001"   => Clock_Out <= Q(25);       -- Div 33M                
            when "11010"   => Clock_Out <= Q(26);       -- Div 67M
            when "11011"   => Clock_Out <= Q(27);       -- Div 134M

            when "11100"   => Clock_Out <= Q(28);       -- Div 268M
            when "11101"   => Clock_Out <= Q(29);       -- Div 534M                
            when "11110"   => Clock_Out <= Q(30);       -- Div 1B
            when "11111"   => Clock_Out <= Q(31);       -- Div 2B
				
            when others => Clock_Out <= Clock_In;

			end case;
			
       end process MUX32to1;
  
  
end architecture clock_div_arch;
