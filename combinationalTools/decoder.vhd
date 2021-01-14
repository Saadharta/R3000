LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY decoder IS
	GENERIC 
	(
		dec_size : INTEGER := 32
	);
	PORT
	(
		input : IN STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0)
	);
END ENTITY decoder;
    
ARCHITECTURE fdd_decoder OF decoder IS
SIGNAL shifter : std_logic_vector(output'range);
BEGIN 
	shifter <= (0=> '1', others => '0');
	output<= std_logic_vector(shift_left(unsigned(shifter), to_integer(unsigned(input))));
END ARCHITECTURE;

--ARCHITECTURE cmp_decoder OF decoder IS
--SIGNAL shifter : std_logic_vector(output'range);
--BEGIN 
--PROCESS(input)
--BEGIN
--	shifter <= (0=> '1', others => '0');
--	output<= std_logic_vector(shift_left(unsigned(shifter), to_integer(unsigned(input))));
--END Process;
--END ARCHITECTURE;
