------------------------------------------------------------------------------------------------------------
-- File name   : memory_interface.vhd
--
-- Project     : EELE367 - Logic Design
--               
-- Description : VHDL model of a 16 x 8-bit ROM memory interface system
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
use ieee.std_logic_arith.all;

entity memory_interface is
  port (clock     : in   STD_LOGIC;
        reset     : in   STD_LOGIC);
end entity;

architecture memory_interface_arch of memory_interface is

type state_type is (RST, EN, LOAD, INC);

signal current_state, next_state            : state_type;
signal rom_en, addr_count_inc, x_reg_load   : std_logic;
signal addr_count                           : std_logic_vector(3 downto 0);
signal Data, x_reg                          : std_logic_vector(7 downto 0);

component rom_16x8_sync
  port (clock   : in  std_logic;
        enable  : in  std_logic;
        address : in  std_logic_vector(3 downto 0);
        data    : out std_logic_vector(7 downto 0));
end component;

begin

-------------------------------------------------------
--  Component Declaration (memory)
-------------------------------------------------------
  
U1 : rom_16x8_sync port map(clock=>clock, 
                            enable=>rom_en,
                            address=>addr_count,
                            data=>Data);

-------------------------------------------------------
--  Process Declaration (State Machine to control register load)
-------------------------------------------------------
  
  STATE_MEMORY : process(clock, reset)      -- Holds current state
    begin
      if (reset = '0') then
        current_state <= RST;
      elsif (clock'event and clock = '1') then
        current_state <= next_state;
      end if;
    end process;
  
  NEXT_STATE_LOGIC : process(current_state) --  Determines Next State (comb. logic)
    begin
      if (current_state = RST) then 
        next_state <= EN;
      elsif (current_state = EN) then 
        next_state <= LOAD;
      elsif (current_state = LOAD) then 
        next_state <= INC;
      elsif (current_state = INC) then 
        next_state <= EN;
      end if;
    end process;
  
  OUTPUT_LOGIC : process(current_state)     --  Determines outputs 
    begin
      case(current_state) is
        when RST => 
          rom_en <= '0';
          addr_count_inc <= '0';
          x_reg_load <= '0';
        when EN => 
          rom_en <= '1';
          addr_count_inc <= '0';
          x_reg_load <= '0';
        when LOAD => 
          rom_en <= '1';
          addr_count_inc <= '0';
          x_reg_load <= '1';
        when INC => 
          rom_en <= '0';
          addr_count_inc <= '1';
          x_reg_load <= '0';
      end case;
    end process;

-------------------------------------------------------
--  Address Counter process (selects memory address)
-------------------------------------------------------        


  ADDRESS_COUNTER : process(clock, reset)
    begin
      if (reset = '0') then
        addr_count <= "0000";
      elsif (clock'event and clock = '1' and addr_count_inc = '1') then
        addr_count <= addr_count + 1;
      end if;
    end process;

-------------------------------------------------------
--  Register Process  (location of load)
-------------------------------------------------------


  X_REGISTER : process(clock, reset)
    begin
      if (reset = '0') then
        x_reg <= "00000000";
      elsif (clock'event and clock = '1' and x_reg_load = '1') then
        x_reg <= Data;
      end if;
    end process;
       
end architecture;