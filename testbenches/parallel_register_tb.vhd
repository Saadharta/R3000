LIBRARY IEEE;
LIBRARY SequentialTools;

USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.ALL;

USE SequentialTools.ALL;

entity test_parallel_register is

end test_parallel_register;
--archi test
architecture behavior of test_parallel_register is
    --test constants
    constant register_size : positive:=32;
    -- clock constant
    constant clk_pulse : Time := 5 ns;
    -- test signals
    signal t_wr : STD_LOGIC;
    signal t_input : std_logic_vector(register_size-1 DOWNTO 0);
    signal t_output : std_logic_vector(register_size-1 DOWNTO 0);

begin
-- main test
dec0 : entity sequentialTools.parallel_register(fdd_parallel_register)
    generic map(register_size)
    port map (  wr => t_wr,
                data_in => t_input,
                data_out => t_output);
P_TEST : process
    VARIABLE TEMP : STD_LOGIC_VECTOR(register_size-1 DOWNTO 0);
begin
    t_input <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,32));
    FOR i IN 0 TO register_size-1 LOOP
        TEMP := STD_LOGIC_VECTOR(TO_UNSIGNED(i, 32));
        t_input <= TEMP;
        t_wr <= TEMP(2);
        WAIT FOR clk_pulse;
    END LOOP;
WAIT;

end process P_TEST;
end behavior;

