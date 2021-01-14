LIBRARY IEEE;
LIBRARY CombinationalTools;

USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

USE CombinationalTools.ALL;
USE CombinationalTools.bus_mux_pkg.ALL;


entity test_decoder is

end test_decoder;
--archi test
architecture behavior of test_decoder is
    --test constants
    constant d_size : positive:=2;
    -- clock constant
    constant clk_pulse : Time := 5 ns;
    -- test signals
    signal t_input : std_logic_vector(d_size-1 DOWNTO 0);
    signal t_output : std_logic_vector((d_size**2)-1 DOWNTO 0);
begin
-- main test
dec0 : entity CombinationalTools.decoder(fdd_decoder)
    generic map(d_size)
    port map (  input => t_input,
                output => t_output);
P_TEST : process
begin
    -- init
    t_input <= "00";
    wait for clk_pulse;
    t_input<=  "01";
    wait for clk_pulse;
    t_input<= "10";
    wait for clk_pulse;
    t_input<= "11";
    wait for clk_pulse;
    t_input<= "00";
    wait for clk_pulse;
    wait;
end process P_TEST;
end behavior;

