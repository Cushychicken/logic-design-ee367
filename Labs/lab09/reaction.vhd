-----------------------------------------------------------------------------------
-- File name   : reaction.vhd
--
-- Project     : Reaction Timer
--
-- Description : VHDL model of a reaction timer- counter segment
--
-- Author(s)   : Nash Reilly
--               Montana State University
--
-- Date        : March 23, 2011
--
-- Note(s)     : 
--
------------------------------------------------------------------------------------
LIBRARY ieee ;
USE IEEE.STD_LOGIC_1164.ALL ;
use IEEE.STD_LOGIC_ARITH.ALL;    --  
use IEEE.STD_LOGIC_UNSIGNED.ALL; --

entity reaction is
	port(Clock, Reset	:in	STD_LOGIC;
		  Go				:in	STD_LOGIC;
		  Stop			:in 	STD_LOGIC;
		  Count0_Out	:out 	STD_LOGIC_VECTOR(3 downto 0);
		  Count1_Out	:out 	STD_LOGIC_VECTOR(3 downto 0);
		  Count2_Out	:out 	STD_LOGIC_VECTOR(3 downto 0);
		  Count3_Out	:out 	STD_LOGIC_VECTOR(3 downto 0));
end entity;

architecture reaction_arch of reaction is 

begin

	Count0 : process (Clock, Reset, Go, Stop) 
        begin
    
            if (Reset = '0') then 
                 Count0_Out <= "0000";        
            elsif (Go = '0') then
					  Count0_Out <= Count0_Out;
				elsif (Stop'event and Stop = '1') then
					  Count0_Out <= Count0_Out;
				elsif (Clock='1' and Clock'event) then
                 if (EN1 = '1') then
							if (Count0_Out = "1001") then
								Count0_Out <= Count0_Out + 7;
							else 
								Count0_Out <= Count0_Out + 1;
							end if;
					  else
							Count0_Out <= Count0_Out;
					  end if;
            end if;

			end process;
	
	Count1 : process (Clock, Reset, Go, Stop) 
        begin
    
            if (Reset = '0') then 
                 Count1_Out <= "0000";
            elsif (Go = '0') then
					  Count1_Out <= Count1_Out;
				elsif (Stop'event and Stop = '1') then
					  Count1_Out <= Count1_Out;
            elsif (Clock='1' and Clock'event and Count0_Out = "1001") then
                 if (EN1 = '1') then
							if (Count1_Out = "1001") then
								Count1_Out <= Count1_Out + 7;
							else 
								Count1_Out <= Count1_Out + 1;
							end if;
					  else
							Count1_Out <= Count1_Out;
					  end if;
            end if;

			end process;
	
	Count2 : process (Clock, Reset, Go, Stop) 
        begin
    
            if (Reset = '0') then 
                 Count2_Out <= "0000";
            elsif (EN = '0') then
					  Count2_Out <= Count2_Out;
				elsif (Stop'event and Stop = '1') then
					  Count2_Out <= Count2_Out;
            elsif (Clock='1' and Clock'event and Count1_Out = "1001" and Count0_Out = "1001") then
                 if (EN1 = '1') then
							if (Count2_Out = "1001") then
								Count2_Out <= Count2_Out + 7;
							else 
								Count2_Out <= Count2_Out + 1;
							end if;
					  else
							Count2_Out <= Count2_Out;
					  end if;
            end if;

			end process;

	Count3 : process (Clock, Reset, Go, Stop) 
        begin
    
            if (Reset = '0') then 
                 Count3_Out <= "0000";
            elsif (Go = '0') then
					  Count3_Out <= Count3_Out;
				elsif (Stop'event and Stop = '1') then
					  Count3_Out <= Count3_Out;					  
            elsif (Clock='1' and Clock'event and Count2_Out = "1001" and Count1_Out = "1001" and Count0_Out = "1001") then
                 if (EN1 = '1') then
							if (Count3_Out = "1001") then
								Count3_Out <= Count3_Out + 7;
							else 
								Count3_Out <= Count3_Out + 1;
							end if;
					  else
							Count3_Out <= Count3_Out;
					  end if;
            end if;

			end process;
 	
END architecture;