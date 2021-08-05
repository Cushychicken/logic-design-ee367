------------------------------------------------------------------------------------------------------------
-- File name   : sequence.vhd
--
-- Project     : EE367 - Logic Design (Spring 2007)
--               Serial Sequence Detector
--
-- Description : VHDL code for a Serial Sequence Detector
--
-- Author(s)   : Nash Reilly
--               Montana State University
--
-- Date        : April 1, 2011
--
-- Note(s)     : Top level design for sequence detector
--
------------------------------------------------------------------------------------------------------------
library IEEE;                    
use IEEE.STD_LOGIC_1164.ALL;     
use IEEE.STD_LOGIC_ARITH.ALL;    
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity sequence is
    port   (Clock         : in   STD_LOGIC;
            Reset         : in   STD_LOGIC;
            Data_In       : in   STD_LOGIC;
            Found         : out  STD_LOGIC);
end entity;

architecture sequence_arch of sequence is
  
  type state_type is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
    
  signal current_state, next_state : state_type;
  
  begin
  
    STATE_MEMORY : process(Clock, Reset)
      begin
        if (Reset = '0') then
            current_state <= S0;
        elsif (Clock'event and Clock = '1') then
            current_state <= next_state;
        end if;
      end process;
      
    NEXT_STATE_LOGIC : process(current_state, Data_In)
      begin
        case (current_state) is
          when  S0 =>
            if (Data_In = '0') then
              next_state <= S1;
              Found <= '0';
            else next_state <= S0;
            end if;
          when  S1 =>
            if (Data_In = '1') then
              next_state <= S2;
              Found <= '0';
            else next_state <= S0;
            end if;
          when  S2 =>
            if (Data_In = '1') then
              next_state <= S3;
              Found <= '0';
            else next_state <= S0;
            end if;
          when  S3 =>
            if (Data_In = '0') then
              next_state <= S4;
              Found <= '0';
            else next_state <= S0;
            end if;
          when  S4 =>
            if (Data_In = '0') then
              next_state <= S5;
              Found <= '0';
            else next_state <= S0;
            end if;
          when  S5 =>
            if (Data_In = '1') then
              next_state <= S6;
              Found <= '0';
            else next_state <= S0;
            end if;
          when  S6 =>
            if (Data_In = '1') then
              next_state <= S7;
              Found <= '0';
            else next_state <= S0;
            end if;
          when  S7 =>
            if (Data_In = '0') then
              next_state <= S8;
              Found <= '0';
            else next_state <= S0;
            end if;
          when  S8 => 
            next_state <= S0;
            Found <= '1';
        end case;
      end process;

-- Note: No need for output logic; this is a Moore machine!

end architecture;