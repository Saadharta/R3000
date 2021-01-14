LIBRARY IEEE;
LIBRARY CombinationalTools;

USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.ALL;

USE CombinationalTools.ALL;
USE CombinationalTools.bus_mux_pkg.ALL;


entity test_barrel_shifter is

end test_barrel_shifter;
--archi test
architecture behavior of test_barrel_shifter is
    --test constants
    constant tb_size : integer := 5;
    constant tb_width : integer := 32;
    -- clock constant
    constant clk_pulse : Time := 5 ns;
    -- test signals
    signal tb_in : STD_LOGIC_VECTOR(tb_width-1 DOWNTO 0);
	signal tb_sa : STD_LOGIC_VECTOR(tb_size-1 DOWNTO 0);
	signal tb_lr : STD_LOGIC;
	signal tb_la : STD_LOGIC;
	signal tb_sr : STD_LOGIC;
	signal tb_out : STD_LOGIC_VECTOR(tb_width-1 DOWNTO 0);

begin
-- main test
dec0 : entity CombinationalTools.barrel_shifter(fdd_barrel_shifter)
    generic map(tb_size, tb_width)
    port map (  
        input => tb_in,
		shift_amount => tb_sa, 
		LeftRight => tb_lr,
		LogicArith => tb_la,
		ShiftRotate => tb_sr,
		output => tb_out);

P_TEST : process
    variable TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);
begin
    tb_in <= "11111010101010101010101010101111";
    tb_sa <= "00111";
    -- begin test logic left shift
    tb_lr <= '0';
    tb_sr <= '0';
    tb_la <= '0';
    wait for clk_pulse;
    assert tb_out="01010101010101010101011110000000"  report "lls anomaly" severity failure;
    -- begin test arith left shift
    tb_la <= '1';
    wait for clk_pulse;
    assert tb_out="01010101010101010101011110000000"  report "als anomaly" severity failure;
    -- begin test logic left rotate
    tb_sr <= '1';
    tb_la <= '0';
    wait for clk_pulse;
    assert tb_out="01010101010101010101011111111101"  report "llr anomaly" severity failure;
    -- begin test arith left rotate
    tb_la <= '1';
    wait for clk_pulse;
    assert tb_out="01010101010101010101011111111101"  report "alr anomaly" severity failure;
    -- begin test logic right shift
    tb_lr <= '1';
    tb_sr <= '0';
    tb_la <= '0';
    wait for clk_pulse;
    assert tb_out="00000001111101010101010101010101"  report "lrs anomaly" severity failure;
    -- begin test arith right shift
    tb_la <= '1';
    wait for clk_pulse;
    assert tb_out="11111111111101010101010101010101"  report "ars anomaly" severity failure;
    -- begin test logic right rotate
    tb_sr <= '1';
    tb_la <= '0';
    wait for clk_pulse;
    assert tb_out="01011111111101010101010101010101"  report "lrr anomaly" severity failure;
    -- begin test arith right rotate
    tb_la <= '1';
    wait for clk_pulse;
    assert tb_out="01011111111101010101010101010101"  report "arr anomaly" severity failure;
    wait;

end process P_TEST;
end behavior;

