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
end entity;

architecture rtl of memory is

 -- Define Internal Signals
 signal      rom_data_out    : std_logic_vector(7 downto 0);
 signal      ram_data_out    : std_logic_vector(7 downto 0); 
 signal      port_in_00_data : std_logic_vector(7 downto 0);
 signal      port_in_01_data : std_logic_vector(7 downto 0);
 signal      port_in_02_data : std_logic_vector(7 downto 0);
 signal      port_in_03_data : std_logic_vector(7 downto 0);
  

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

 -- port_out_01 description : ADDRESS x"C1"
 U4 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_01 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C1" and write = '1') then
          port_out_01 <= data_in;
       end if;
     end if;
   end process;
   
 -- port_out_02 description : ADDRESS x"C2"
 U5 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_02 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C2" and write = '1') then
          port_out_02 <= data_in;
       end if;
     end if;
   end process;
   
 -- port_out_03 description : ADDRESS x"C3"
 U6 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_03 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C3" and write = '1') then
          port_out_03 <= data_in;
       end if;
     end if;
   end process;
 
 -- port_out_04 description : ADDRESS x"C4"  
 U7 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_04 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C4" and write = '1') then
          port_out_04 <= data_in;
       end if;
     end if;
   end process;
   
 -- port_out_05 description : ADDRESS x"C5"  
 U8 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_05 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C5" and write = '1') then
          port_out_05 <= data_in;
       end if;
     end if;
   end process;  

 -- port_out_06 description : ADDRESS x"C6"  
 U9 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_06 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C6" and write = '1') then
          port_out_06 <= data_in;
       end if;
     end if;
   end process;
   
 -- port_out_07 description : ADDRESS x"C7"  
 U10 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_07 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C7" and write = '1') then
          port_out_07 <= data_in;
       end if;
     end if;
   end process;

 -- port_out_08 description : ADDRESS x"C8"  
 U11 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_08 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C8" and write = '1') then
          port_out_08 <= data_in;
       end if;
     end if;
   end process;

 -- port_out_09 description : ADDRESS x"C9"  
 U12 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_09 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"C9" and write = '1') then
          port_out_09 <= data_in;
       end if;
     end if;
   end process;

 -- port_out_10 description : ADDRESS x"CA"  
 U13 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_10 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"CA" and write = '1') then
          port_out_10 <= data_in;
       end if;
     end if;
   end process;
   
 -- port_out_11 description : ADDRESS x"CB"  
 U14 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_11 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"CB" and write = '1') then
          port_out_11 <= data_in;
       end if;
     end if;
   end process;
   
 -- port_out_12 description : ADDRESS x"CC"  
 U15 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_12 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"CC" and write = '1') then
          port_out_12 <= data_in;
       end if;
     end if;
   end process;   

 -- port_out_13 description : ADDRESS x"CD"  
 U16 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_13 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"CD" and write = '1') then
          port_out_13 <= data_in;
       end if;
     end if;
   end process;

 -- port_out_14 description : ADDRESS x"CE"  
 U17 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_14 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"CE" and write = '1') then
          port_out_14 <= data_in;
       end if;
     end if;
   end process;
   
 -- port_out_15 description : ADDRESS x"CF"  
 U18 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_15 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"CF" and write = '1') then
          port_out_15 <= data_in;
       end if;
     end if;
   end process;
   
 -- port_out_16 description : ADDRESS x"D0"  
 U19 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_16 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"D0" and write = '1') then
          port_out_16 <= data_in;
       end if;
     end if;
   end process;

 -- port_out_17 description : ADDRESS x"D1"  
 U20 : process (clock, reset)
   begin
     if (reset = '0') then
       port_out_17 <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"D1" and write = '1') then
          port_out_17 <= data_in;
       end if;
     end if;
   end process;

 -- port_in_00 description : ADDRESS x"E0"
 U35 : process (clock, reset)
   begin
     if (reset = '0') then
       port_in_00_data <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"E0") then
          port_in_00_data <= port_in_00;
       end if;
     end if;
   end process;
  
  -- port_in_01 description : ADDRESS x"E1" 
  U36 : process (clock, reset)
   begin
     if (reset = '0') then
       port_in_01_data <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"E1") then
          port_in_01_data <= port_in_01;
       end if;
     end if;
   end process;
   
   -- port_in_02 description : ADDRESS x"E2" 
  U37 : process (clock, reset)
   begin
     if (reset = '0') then
       port_in_02_data <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"E2") then
          port_in_02_data <= port_in_02;
       end if;
     end if;
   end process;
   
   -- port_in_03 description : ADDRESS x"E3" 
  U38 : process (clock, reset)
   begin
     if (reset = '0') then
       port_in_03_data <= x"00";
     elsif (clock'event and clock='1') then
       if (address = x"E3") then
          port_in_03_data <= port_in_03;
       end if;
     end if;
   end process;


 -- Multiplexer for data_out
 MUX1 : process (address, rom_data_out, ram_data_out,  port_in_00_data, port_in_01_data, port_in_02_data, port_in_03_data)
   begin
       if    (address >= 0 and address <= 127)   then data_out <= rom_data_out;    
       elsif (address >= 128 and address <= 191) then data_out <= ram_data_out;    
       elsif (address = x"E0")                   then data_out <= port_in_00_data; 
       elsif (address = x"E1")                   then data_out <= port_in_01_data;
       elsif (address = x"E2")                   then data_out <= port_in_02_data;
       elsif (address = x"E3")                   then data_out <= port_in_03_data;
       else  data_out <= x"00";
       end if;   
   end process;

end architecture;