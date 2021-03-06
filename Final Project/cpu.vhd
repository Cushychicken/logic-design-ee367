------------------------------------------------------------------------------------------------------------
-- File name   : cpu.hhd
--
-- Project     : 8-Bit Microcomputer
--
-- Description : VHDL model of an 8-bit CPU
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
  
entity cpu is
    port  ( clock      : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            memory_in  : out STD_LOGIC_VECTOR (7 downto 0);
            memory_out : in  STD_LOGIC_VECTOR (7 downto 0);             
            address    : out STD_LOGIC_VECTOR (7 downto 0);
            write      : out STD_LOGIC);    
end entity;

architecture rtl of cpu is

 -- Signal Declaration
 
     signal  IR_Load   : STD_LOGIC;
     signal  IR        : STD_LOGIC_VECTOR (7 downto 0);
     signal  MAR_Load  : STD_LOGIC;             
     signal  PC_Load   : STD_LOGIC;
     signal  PC_Inc    : STD_LOGIC;             
     signal  X_Load    : STD_LOGIC;
     signal  Y_Load    : STD_LOGIC;             
     signal  Z_Load    : STD_LOGIC;
     signal  ALU_Sel   : STD_LOGIC_VECTOR (2 downto 0);             
     signal  CCR_Result: STD_LOGIC_VECTOR (7 downto 0);
     signal  CCR_Load  : STD_LOGIC;             
     signal  Bus1_Sel  : STD_LOGIC_VECTOR (1 downto 0);                          
     signal  Bus2_Sel  : STD_LOGIC_VECTOR (1 downto 0);


 -- Component Declaration

    component processing_unit
      port ( Clock     : in  STD_LOGIC;
             Reset     : in  STD_LOGIC;
             Memory_In : out STD_LOGIC_VECTOR (7 downto 0);
             Memory_Out: in  STD_LOGIC_VECTOR (7 downto 0);             
             Address   : out STD_LOGIC_VECTOR (7 downto 0);
             IR_Load   : in  STD_LOGIC;
             IR        : out STD_LOGIC_VECTOR (7 downto 0);
             MAR_Load  : in  STD_LOGIC;             
             PC_Load   : in  STD_LOGIC;
             PC_Inc    : in  STD_LOGIC;             
             X_Load    : in  STD_LOGIC;
             Y_Load    : in  STD_LOGIC;             
             Z_Load    : in  STD_LOGIC;
             ALU_Sel   : in  STD_LOGIC_VECTOR (2 downto 0);             
             CCR_Result: out STD_LOGIC_VECTOR (7 downto 0);
             CCR_Load  : in  STD_LOGIC;             
             Bus1_Sel  : in  STD_LOGIC_VECTOR (1 downto 0);                          
             Bus2_Sel  : in  STD_LOGIC_VECTOR (1 downto 0));                          
    end component;

    component Control_unit
      port ( Clock     : in  STD_LOGIC;
             Reset     : in  STD_LOGIC;
             Write     : out STD_LOGIC;
             IR_Load   : out STD_LOGIC;
             IR        : in  STD_LOGIC_VECTOR (7 downto 0);
             MAR_Load  : out STD_LOGIC;             
             PC_Load   : out STD_LOGIC;
             PC_Inc    : out STD_LOGIC;             
             X_Load    : out STD_LOGIC;
             Y_Load    : out STD_LOGIC;             
             Z_Load    : out STD_LOGIC;
             ALU_Sel   : out STD_LOGIC_VECTOR (2 downto 0);             
             CCR_Result: in  STD_LOGIC_VECTOR (7 downto 0);
             CCR_Load  : out STD_LOGIC;             
             Bus1_Sel  : out STD_LOGIC_VECTOR (1 downto 0);                          
             Bus2_Sel  : out STD_LOGIC_VECTOR (1 downto 0));                          
    end component;


 begin

 -- Component Instantiations

 PU_1 : processing_unit
  port map ( Clock     => clock,
             Reset     => reset,
             Memory_In => Memory_In,
             Memory_Out=> Memory_Out,  
             Address   => Address,
             IR_Load   => IR_Load ,
             IR        => IR,
             MAR_Load  => MAR_Load,             
             PC_Load   => PC_Load,
             PC_Inc    => PC_Inc,             
             X_Load    => X_Load,
             Y_Load    => Y_Load,
             Z_Load    => Z_Load,
             ALU_Sel   => ALU_Sel,
             CCR_Result=> CCR_Result,
             CCR_Load  => CCR_Load,
             Bus1_Sel  => Bus1_Sel,
             Bus2_Sel  => Bus2_Sel);

 CU_1 : Control_unit
  port map ( Clock     => clock,
             Reset     => reset,
             Write     => write,
             IR_Load   => IR_Load,
             IR        => IR,
             MAR_Load  => MAR_Load,
             PC_Load   => PC_Load,
             PC_Inc    => PC_Inc,
             X_Load    => X_load,
             Y_Load    => Y_Load,
             Z_Load    => Z_Load,
             ALU_Sel   => ALU_Sel,
             CCR_Result=> CCR_Result,
             CCR_Load  => CCR_Load,
             Bus1_Sel  => Bus1_Sel,
             Bus2_Sel  => Bus2_Sel);

end architecture;