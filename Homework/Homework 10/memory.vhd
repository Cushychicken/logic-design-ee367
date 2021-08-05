------------------------------------------------------------------------------------------------------------
-- File name   : memory.vhd
--
-- Project     : 8-Bit Microcomputer
--               
-- Description : VHDL model of a 256x8 Memory System with ROM, RAM, and IO
--
-- Author(s)   : Brock J. LaMeres
--               Montana State University
--               lameres@ece.montana.edu
--
-- Note(s)     : Address      Description
--              ----------------------------------
--              x"00"       Instruction Memory (ROM)    
--               :            (128x8-bit) 
--               : 
--              x"7F"                          
--              ----------------------------------
--              x"80"       Data Memory (RAM)
--               :            (64x8-bit)
--              x"BF"           
--              ----------------------------------               
--              x"C0"            IO 
--               :            (64 ports)
--              x"FF"           
--              ----------------------------------
------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity memory is
  port      (clock           : in  std_logic;
             reset           : in  std_logic;
             address         : in  std_logic_vector (7 downto 0);
             write           : in  std_logic;
             data_in         : in  std_logic_vector (7 downto 0);
             data_out        : out std_logic_vector (7 downto 0);
             
             port_out_00     : out std_logic_vector (7 downto 0);
             port_in_00      : in  std_logic_vector (7 downto 0));
end entity;

architecture rtl of memory is

 -- Define Internal Signals
 signal      rom_data_out    : std_logic_vector(7 downto 0);
 signal      ram_data_out    : std_logic_vector(7 downto 0); 
 signal      port_in_00_data : std_logic_vector(7 downto 0); 

 -- Declare ROM 
 component rom_128x8_sync
     port   (clock           : in  std_logic;
             address         : in  std_logic_vector(7 downto 0);
             data_out        : out std_logic_vector(7 downto 0));
 end component;

 -- Declare RAM 
 component ram_64x8_sync
     port   (clock           : in  std_logic;
             data_in         : in  std_logic_vector(7 downto 0);    
             write           : in  std_logic;
             address         : in  std_logic_vector(7 downto 0);
             data_out        : out std_logic_vector(7 downto 0));
 end component;

 begin

 -- instantiate ROM
 U1 : rom_128x8_sync
   port map (clock          => clock,
             address        => address,
             data_out       => rom_data_out);

 -- instantiate RAM
 U2 : ram_64x8_sync
   port map (clock          => clock,
             data_in        => data_in,
             write          => write,
             address        => address,
             data_out       => ram_data_out);

 -- port_out_00 description : ADDRESS x"C0"
 U3 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_00 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C0" and write = '1') then
          port_out_00 <= data_in;
       end if;
     end if;
   end process;

 -- port_in_00 description : ADDRESS x"E0"
 U35 : process (clock, reset)
   begin
     if (reset = '0') then
       port_in_00_data <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"E0" and write = '1') then
          port_in_00_data <= port_in_00;
       end if;
     end if;
   end process;


 -- Multiplexer for data_out
 MUX1 : process (address, rom_data_out, ram_data_out,  port_in_00_data)
   begin
       if    (address >= 0 and address <= 127)   then data_out <= rom_data_out;    
       elsif (address >= 128 and address <= 191) then data_out <= ram_data_out;    
       elsif (address = x"E0")                   then data_out <= port_in_00_data; end if;   
   end process;

end architecture;