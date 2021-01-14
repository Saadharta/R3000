LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SRAM_DPS IS
	GENERIC (
		address_width : NATURAL := 8;
		data_bus_width : NATURAL := 8
	);
	PORT (
		address : IN STD_LOGIC_VECTOR(address_width-1 DOWNTO 0);
		data_in : IN STD_LOGIC_VECTOR(data_bus_width-1 DOWNTO 0); 
		data_out : OUT STD_LOGIC_VECTOR(data_bus_width-1 DOWNTO 0); 
		WE, CS, OE, CLK : IN STD_LOGIC
	);
END ENTITY SRAM_DPS;

ARCHITECTURE seq_sram_dps OF SRAM_DPS IS
	type bus_sram_array IS ARRAY((2**address_width)-1 DOWNTO 0) OF STD_LOGIC_VECTOR(data_bus_width-1 DOWNTO 0) ;
	signal data : bus_sram_array := (others => (others => '0'));
BEGIN
	PROCESS(CLK) IS
	BEGIN
		IF( CS = '0' ) THEN
			IF(WE = '0') THEN
				IF(rising_edge(CLK)) THEN
					data(to_integer(unsigned(address))) <= data_in;
				END IF;
			ELSE
				IF (OE = '0' ) THEN
					data_out <= data(to_integer(unsigned(address)));	
				ELSE
					data_out <= (others => 'Z');
				END IF;
			END IF;
		ELSE 
			data_out <= (others => 'Z');
		END IF;
	END PROCESS;
END ARCHITECTURE;