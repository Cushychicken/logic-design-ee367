------------------------------------------------------------------------------------------------------------
-- File name   : memory_interface.vhd
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
use ieee.std_logic_arith.all;

entity memory_interface is
  port (SW         : IN  STD_LOGIC_VECTOR(17 downto 0);
	     KEY	       : IN  STD_LOGIC_VECTOR(3 downto 0);
		  CLOCK_50 	 : IN  STD_LOGIC;
			 
        LEDR       : OUT STD_LOGIC_VECTOR(17 downto 0);
		  LEDG     	 : OUT STD_LOGIC_VECTOR(7 downto 0);
		  GPIO_0   	 : OUT STD_LOGIC_VECTOR(35 downto 0));
end entity;

architecture memory_interface_arch of memory_interface is

type state_type is (RST, COPY, COPY_ADDR_INC, ADDR_CLR, READ_RAM, READ_ADDR_INC);

signal current_state, next_state                                               : state_type;                      -- State Variables for State Machine
signal rom_en, ram_en, ram_write, addr_count_clr, addr_count_inc, x_reg_load   : std_logic;                       -- Sequence Controller Control Lines
signal addr_count                                                              : std_logic_vector(3 downto 0);    -- Address Vector
signal Data, x_reg, rom_to_ram                                                 : std_logic_vector(3 downto 0);    -- Memory data and register vectors
signal clock, reset																				 : std_logic;								-- System clock and reset lines
signal Logic_Analyzer_Port																		 : std_logic_vector(16 downto 0);   -- Logic Analyzer Interface Signals

component rom_16x4_sync
  port (clock       : in  std_logic;
        en          : in  std_logic;
        address     : in  std_logic_vector(3 downto 0);
        data_out    : out std_logic_vector(3 downto 0));
end component;

component ram_16x4_sync
  port (clock       : in  std_logic;
        en       	  : in  std_logic;
        write_ram   : in  std_logic;
        address     : in  std_logic_vector(3 downto 0);
        data_out    : out std_logic_vector(3 downto 0);
        data_in     : in  std_logic_vector(3 downto 0));
end component;

component clock_div
  port(Clock_In     : in   STD_LOGIC;
       Reset        : in   STD_LOGIC;
       Sel          : in   STD_LOGIC_VECTOR(4 downto 0);
       Clock_Out    : out  STD_LOGIC);
end component;

begin

-------------------------------------------------------
--	 Physical Reset
-------------------------------------------------------

		reset<= KEY(0);

-------------------------------------------------------
--  Logic Analyzer Signal Mapping
-------------------------------------------------------

		LEDR(11 downto 8) <= rom_to_ram;
		LEDR(7 downto 4)  <= Data;
		LEDR(3 downto 0)	<= x_reg;
		
		Logic_Analyzer_Port(3 downto 0)  <= addr_count (3 downto 0);
		Logic_Analyzer_Port(7 downto 4)  <= rom_to_ram;
		Logic_Analyzer_Port(11 downto 8)	<= Data;
		Logic_Analyzer_Port(12)			   <= rom_en;
		Logic_Analyzer_Port(13) 		   <= ram_write;
		Logic_Analyzer_Port(14) 			<= ram_en;
		Logic_Analyzer_Port(15) 		   <= addr_count_clr;
		Logic_Analyzer_Port(16) 		   <= addr_count_inc;
		
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
	





-------------------------------------------------------
--  Component Declaration (memory)
-------------------------------------------------------
  
U1 : rom_16x4_sync port map(clock=>clock, 
                            en=>rom_en,
                            address=>addr_count,
                            data_out=>rom_to_ram);
                            
U2 : ram_16x4_sync port map(clock=>clock,
                            en=>ram_en,
                            write_ram=>ram_write,
                            address=>addr_count,
                            data_out=>Data,
                            data_in=>rom_to_ram);
                            
U3 : clock_div port map    (Clock_In=>CLOCK_50,
									 Reset=>reset,
									 Sel => SW(4 downto 0),
									 Clock_Out=> clock);

                            
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
        next_state <= COPY;
      elsif (current_state = COPY) then 
        next_state <= COPY_ADDR_INC;
      elsif (current_state = COPY_ADDR_INC) then 
        if (addr_count = 15) then
          next_state <= ADDR_CLR;
        else
          next_state <= COPY;
        end if;
      elsif (current_state = ADDR_CLR) then 
        next_state <= READ_RAM;
      elsif (current_state = READ_RAM) then
        next_state <= READ_ADDR_INC;
      elsif (current_state = READ_ADDR_INC) then 
        if (addr_count = 15) then
          next_state <= COPY;
        else
          next_state <= READ_RAM;
        end if;
      end if;
    end process;
  
  OUTPUT_LOGIC : process(current_state)     --  Determines outputs 
    begin
      case(current_state) is
        when RST => 
          rom_en <= '0';
          ram_en <= '0';
          ram_write <= '0';
          addr_count_clr <= '0';
          addr_count_inc <= '0';
          x_reg_load <= '0';
        when COPY => 
          rom_en <= '1';
          ram_en <= '1';
          ram_write <= '1';
          addr_count_clr <= '0';
          addr_count_inc <= '0';
          x_reg_load <= '0';
        when COPY_ADDR_INC => 
          rom_en <= '1';
          ram_en <= '1';
          ram_write <= '1';
          addr_count_clr <= '0';
          addr_count_inc <= '1';
          x_reg_load <= '0';
        when ADDR_CLR => 
          rom_en <= '0';
          ram_en <= '0';
          ram_write <= '0';
          addr_count_clr <= '1';
          addr_count_inc <= '0';
          x_reg_load <= '0';
        when READ_RAM => 
          rom_en <= '0';
          ram_en <= '1';
          ram_write <= '0';
          addr_count_clr <= '0';
          addr_count_inc <= '0';
          x_reg_load <= '0';
        when READ_ADDR_INC => 
          rom_en <= '0';
          ram_en <= '1';
          ram_write <= '0';
          addr_count_clr <= '0';
          addr_count_inc <= '1';
          x_reg_load <= '1';
        when others => 
          rom_en <= '0';
          ram_en <= '0';
          ram_write <= '0';
          addr_count_clr <= '0';
          addr_count_inc <= '0';
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
        x_reg <= "0000";
      elsif (clock'event and clock = '1' and x_reg_load = '1') then
        x_reg <= Data;
      end if;
    end process;
       
end architecture;
