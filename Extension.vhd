LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY Extension IS
	PORT
	(
		OpExt : IN STD_LOGIC;
		inst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ENTITY Extension;

ARCHITECTURE fdd_extension OF Extension IS 
	signal selector : std_logic;
BEGIN 
	selector <= OpExt and inst(15);
	output(15 DOWNTO 0) <= inst;
	with (selector) select
		output(31 DOWNTO 16) <= (others => '1') when '1',
								(others => '0') when others; 
END ARCHITECTURE;
