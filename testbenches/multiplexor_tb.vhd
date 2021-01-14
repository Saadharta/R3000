LIBRARY IEEE;
LIBRARY CombinationalTools;

USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.ALL;

USE CombinationalTools.ALL;
USE CombinationalTools.bus_mux_pkg.ALL;


entity test_multiplexor is

end test_multiplexor;
--archi test
architecture behavior of test_multiplexor is
    --test constants
    constant mux_size : integer :=2;
    -- clock constant
    constant clk_pulse : Time := 5 ns;
    -- test signals
    signal t_input : bus_mux_array((2**mux_size)-1 DOWNTO 0);
	signal t_sel_input : STD_LOGIC_VECTOR(mux_size-1 DOWNTO 0);
	signal t_output : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
-- main test
dec0 : entity CombinationalTools.multiplexor(fdd_multiplexor)
    generic map(mux_size)
    port map (  input => t_input,
                sel_input => t_sel_input,
                output => t_output);

P_TEST : process
    VARIABLE TEMP : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
    t_input <= (others => STD_LOGIC_VECTOR(TO_UNSIGNED(0,32)));
    FOR i IN 0 TO 2**mux_size-1 LOOP
        TEMP := STD_LOGIC_VECTOR(TO_UNSIGNED(i, 32));
        t_input(i) <= TEMP;
        t_sel_input <= TEMP(1 DOWNTO 0);
        WAIT FOR clk_pulse;
    END LOOP;
    WAIT;

end process P_TEST;
end behavior;

