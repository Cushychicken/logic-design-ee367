LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY lab_01_light IS
	PORT (x1,x2: IN	STD_LOGIC;
			f	  : OUT	STD_LOGIC);
END lab_01_light;

ARCHITECTURE LogicFunction OF lab_01_light IS
BEGIN
	f<=(x1 AND NOT x2) OR (NOT x1 AND x2);
END LogicFunction;