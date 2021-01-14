LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE bus_mux_pkg IS
	TYPE bus_mux_array IS ARRAY(NATURAL RANGE<>) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
END PACKAGE bus_mux_pkg;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.bus_mux_pkg.ALL;

ENTITY multiplexor IS
	GENERIC 
	(
		mux_size : INTEGER := 2
	);
	PORT
	(
		input : IN bus_mux_array((2**mux_size)-1 DOWNTO 0);
		sel_input : IN STD_LOGIC_VECTOR(mux_size-1 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ENTITY multiplexor;

ARCHITECTURE fdd_multiplexor OF multiplexor IS
BEGIN
    output <= input(to_integer(unsigned(sel_input)));
END ARCHITECTURE;
