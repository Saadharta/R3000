LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

ENTITY parallel_register IS
	GENERIC
	(
		register_size : INTEGER := 32
	);
		PORT 
	(
		wr : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR(register_size-1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(register_size-1 DOWNTO 0)
	);
END ENTITY parallel_register;

ARCHITECTURE fdd_parallel_register OF parallel_register IS
SIGNAL storage : STD_LOGIC_VECTOR(register_size -1 DOWNTO 0) := (others=>'0');
BEGIN
	storage <= data_in when rising_edge(wr);
	data_out <= storage;
END ARCHITECTURE;