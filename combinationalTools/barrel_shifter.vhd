LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;

ENTITY barrel_shifter IS
	GENERIC 
	(
		shift_size : INTEGER := 5;
		shifter_width : INTEGER := 32
	);
	PORT
	(
		input : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		shift_amount : IN STD_LOGIC_VECTOR(shift_size-1 DOWNTO 0);
		LeftRight : IN STD_LOGIC;
		LogicArith : IN STD_LOGIC;
		ShiftRotate : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ENTITY barrel_shifter;

ARCHITECTURE fdd_barrel_shifter OF barrel_shifter IS
    signal selector : std_logic_vector(2 DOWNTO 0);
BEGIN
	selector <= (LeftRight & ShiftRotate & LogicArith );
	with (selector) select
		output <=  	std_logic_vector(shift_left(unsigned(input), to_integer(unsigned(shift_amount))))   when "000", 
					std_logic_vector(shift_left(signed(input), to_integer(unsigned(shift_amount))))     when "001", 
					std_logic_vector(rotate_left(unsigned(input), to_integer(unsigned(shift_amount))))  when "010", 
					std_logic_vector(rotate_left(signed(input), to_integer(unsigned(shift_amount))))    when "011",
					std_logic_vector(shift_right(unsigned(input), to_integer(unsigned(shift_amount))))  when "100", 
					std_logic_vector(shift_right(signed(input), to_integer(unsigned(shift_amount))))    when "101", 
					std_logic_vector(rotate_right(unsigned(input), to_integer(unsigned(shift_amount)))) when "110", 
					std_logic_vector(rotate_right(signed(input), to_integer(unsigned(shift_amount))))   when "111",
					(others=>'0') when others;
END ARCHITECTURE;