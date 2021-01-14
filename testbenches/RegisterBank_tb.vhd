LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

entity test_register_bank is

end test_register_bank;
--archi test
architecture behavior of test_register_bank is
    --test constants
    constant reg_size : integer :=5;
    --timing signals    
    constant clock_pulse : time := 1 ns;
    signal clock : STD_LOGIC := '0';
    signal done : std_logic := '0';
    -- test signals
    signal t_source_register_0 : STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	signal t_data_out_0 : STD_LOGIC_VECTOR((2**reg_size)-1 DOWNTO 0);
	signal t_source_register_1 : STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	signal t_data_out_1 : STD_LOGIC_VECTOR((2**reg_size)-1 DOWNTO 0);
	signal t_destination_register : STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	signal t_data_in : STD_LOGIC_VECTOR((2**reg_size)-1 DOWNTO 0);
	signal t_write_register : STD_LOGIC;
begin
-- main test
reg_bnk : entity work.RegisterBank(struct_register_bank)

    port map (  source_register_0 => t_source_register_0,
                data_out_0 => t_data_out_0,
                source_register_1 => t_source_register_1,
                data_out_1 => t_data_out_1,
                destination_register => t_destination_register,
                data_in => t_data_in,
                write_register => t_write_register,
                clk=> clock
    );
-- clock process
clk_gen_p: process is
    begin
        while done = '0' loop
            wait for clock_pulse/2;
            clock <= not clock;
        end loop;
        wait;
    end process;
    
P_TEST : process
   vARIABLE t_ii : std_logic_vector(31 DOWNTO 0);
begin
    -- write in reg0 ?
    done <= '0';
    t_write_register <= '1';
    t_destination_register <= "00000";
    t_data_in <= "01010101010101010101010101010101";
    t_source_register_0 <= "00000";
    wait until rising_edge(clock);
    assert to_integer(unsigned(t_data_out_0)) = 0
    report "failure in REG0" & CR & LF
        & "data_out_0: "    & std_logic'image(t_data_out_0(31))(2)
                            & std_logic'image(t_data_out_0(30))(2)
                            & std_logic'image(t_data_out_0(29))(2)
                            & std_logic'image(t_data_out_0(28))(2)
                            & std_logic'image(t_data_out_0(27))(2)
                            & std_logic'image(t_data_out_0(26))(2)
                            & std_logic'image(t_data_out_0(25))(2)
                            & std_logic'image(t_data_out_0(24))(2)
        & " "               & std_logic'image(t_data_out_0(23))(2)
                            & std_logic'image(t_data_out_0(22))(2)
                            & std_logic'image(t_data_out_0(21))(2)
                            & std_logic'image(t_data_out_0(20))(2)
                            & std_logic'image(t_data_out_0(19))(2)
                            & std_logic'image(t_data_out_0(18))(2)
                            & std_logic'image(t_data_out_0(17))(2)
                            & std_logic'image(t_data_out_0(16))(2)
        & " "               & std_logic'image(t_data_out_0(15))(2)
                            & std_logic'image(t_data_out_0(14))(2)
                            & std_logic'image(t_data_out_0(13))(2)
                            & std_logic'image(t_data_out_0(12))(2)
                            & std_logic'image(t_data_out_0(11))(2)
                            & std_logic'image(t_data_out_0(10))(2)
                            & std_logic'image(t_data_out_0(9))(2)
                            & std_logic'image(t_data_out_0(8))(2)
        & " "               & std_logic'image(t_data_out_0(7))(2)
                            & std_logic'image(t_data_out_0(6))(2)
                            & std_logic'image(t_data_out_0(5))(2)
                            & std_logic'image(t_data_out_0(4))(2)
                            & std_logic'image(t_data_out_0(3))(2)
                            & std_logic'image(t_data_out_0(2))(2)
                            & std_logic'image(t_data_out_0(1))(2)
                            & std_logic'image(t_data_out_0(0))(2) & CR & LF
    severity failure;
    t_source_register_1 <= "00000";
    assert to_integer(unsigned(t_data_out_1)) = 0
    report "failure in REG0" &  CR & LF
        & "data_out_1: "    & std_logic'image(t_data_out_1(31))(2)
                            & std_logic'image(t_data_out_1(30))(2)
                            & std_logic'image(t_data_out_1(29))(2)
                            & std_logic'image(t_data_out_1(28))(2)
                            & std_logic'image(t_data_out_1(27))(2)
                            & std_logic'image(t_data_out_1(26))(2)
                            & std_logic'image(t_data_out_1(25))(2)
                            & std_logic'image(t_data_out_1(24))(2)
        & " "               & std_logic'image(t_data_out_1(23))(2)
                            & std_logic'image(t_data_out_1(22))(2)
                            & std_logic'image(t_data_out_1(21))(2)
                            & std_logic'image(t_data_out_1(20))(2)
                            & std_logic'image(t_data_out_1(19))(2)
                            & std_logic'image(t_data_out_1(18))(2)
                            & std_logic'image(t_data_out_1(17))(2)
                            & std_logic'image(t_data_out_1(16))(2)
        & " "               & std_logic'image(t_data_out_1(15))(2)
                            & std_logic'image(t_data_out_1(14))(2)
                            & std_logic'image(t_data_out_1(13))(2)
                            & std_logic'image(t_data_out_1(12))(2)
                            & std_logic'image(t_data_out_1(11))(2)
                            & std_logic'image(t_data_out_1(10))(2)
                            & std_logic'image(t_data_out_1(9))(2)
                            & std_logic'image(t_data_out_1(8))(2)
        & " "               & std_logic'image(t_data_out_1(7))(2)
                            & std_logic'image(t_data_out_1(6))(2)
                            & std_logic'image(t_data_out_1(5))(2)
                            & std_logic'image(t_data_out_1(4))(2)
                            & std_logic'image(t_data_out_1(3))(2)
                            & std_logic'image(t_data_out_1(2))(2)
                            & std_logic'image(t_data_out_1(1))(2)
                            & std_logic'image(t_data_out_1(0))(2) & CR & LF
    severity failure;
    --write and read somewhere else
    for ii in 1 to 31 loop
        t_ii := std_logic_vector(to_unsigned (ii,32));
        t_write_register <= '1';
        t_destination_register <= t_ii(4 DOWNTO 0);
        t_data_in <= t_ii;
        t_source_register_0 <= t_ii(4 DOWNTO 0);
        t_source_register_1 <= t_ii(4 DOWNTO 0);
        wait until rising_edge(clock);
        assert to_integer(unsigned(t_data_out_0)) = to_integer(unsigned(t_ii))
        report "failure in REG" & integer'image(to_integer(unsigned(t_destination_register))) & CR & LF
            & "data_out_0: "    & std_logic'image(t_data_out_0(31))(2)
                                & std_logic'image(t_data_out_0(30))(2)
                                & std_logic'image(t_data_out_0(29))(2)
                                & std_logic'image(t_data_out_0(28))(2)
                                & std_logic'image(t_data_out_0(27))(2)
                                & std_logic'image(t_data_out_0(26))(2)
                                & std_logic'image(t_data_out_0(25))(2)
                                & std_logic'image(t_data_out_0(24))(2)
            & " "               & std_logic'image(t_data_out_0(23))(2)
                                & std_logic'image(t_data_out_0(22))(2)
                                & std_logic'image(t_data_out_0(21))(2)
                                & std_logic'image(t_data_out_0(20))(2)
                                & std_logic'image(t_data_out_0(19))(2)
                                & std_logic'image(t_data_out_0(18))(2)
                                & std_logic'image(t_data_out_0(17))(2)
                                & std_logic'image(t_data_out_0(16))(2)
            & " "               & std_logic'image(t_data_out_0(15))(2)
                                & std_logic'image(t_data_out_0(14))(2)
                                & std_logic'image(t_data_out_0(13))(2)
                                & std_logic'image(t_data_out_0(12))(2)
                                & std_logic'image(t_data_out_0(11))(2)
                                & std_logic'image(t_data_out_0(10))(2)
                                & std_logic'image(t_data_out_0(9))(2)
                                & std_logic'image(t_data_out_0(8))(2)
            & " "               & std_logic'image(t_data_out_0(7))(2)
                                & std_logic'image(t_data_out_0(6))(2)
                                & std_logic'image(t_data_out_0(5))(2)
                                & std_logic'image(t_data_out_0(4))(2)
                                & std_logic'image(t_data_out_0(3))(2)
                                & std_logic'image(t_data_out_0(2))(2)
                                & std_logic'image(t_data_out_0(1))(2)
                                & std_logic'image(t_data_out_0(0))(2) & CR & LF
        severity failure;
        assert to_integer(unsigned(t_data_out_1)) = to_integer(unsigned(t_ii))
        report "failure in REG"& integer'image(to_integer(unsigned(t_destination_register))) & CR & LF
            & "data_out_1: "    & std_logic'image(t_data_out_1(31))(2)
                                & std_logic'image(t_data_out_1(30))(2)
                                & std_logic'image(t_data_out_1(29))(2)
                                & std_logic'image(t_data_out_1(28))(2)
                                & std_logic'image(t_data_out_1(27))(2)
                                & std_logic'image(t_data_out_1(26))(2)
                                & std_logic'image(t_data_out_1(25))(2)
                                & std_logic'image(t_data_out_1(24))(2)
            & " "               & std_logic'image(t_data_out_1(23))(2)
                                & std_logic'image(t_data_out_1(22))(2)
                                & std_logic'image(t_data_out_1(21))(2)
                                & std_logic'image(t_data_out_1(20))(2)
                                & std_logic'image(t_data_out_1(19))(2)
                                & std_logic'image(t_data_out_1(18))(2)
                                & std_logic'image(t_data_out_1(17))(2)
                                & std_logic'image(t_data_out_1(16))(2)
            & " "               & std_logic'image(t_data_out_1(15))(2)
                                & std_logic'image(t_data_out_1(14))(2)
                                & std_logic'image(t_data_out_1(13))(2)
                                & std_logic'image(t_data_out_1(12))(2)
                                & std_logic'image(t_data_out_1(11))(2)
                                & std_logic'image(t_data_out_1(10))(2)
                                & std_logic'image(t_data_out_1(9))(2)
                                & std_logic'image(t_data_out_1(8))(2)
            & " "               & std_logic'image(t_data_out_1(7))(2)
                                & std_logic'image(t_data_out_1(6))(2)
                                & std_logic'image(t_data_out_1(5))(2)
                                & std_logic'image(t_data_out_1(4))(2)
                                & std_logic'image(t_data_out_1(3))(2)
                                & std_logic'image(t_data_out_1(2))(2)
                                & std_logic'image(t_data_out_1(1))(2)
                                & std_logic'image(t_data_out_1(0))(2) & CR & LF
        severity failure;
    end loop;
    -- signal to kill the clock
    done <= '1';
    wait;
end process P_TEST;
end behavior;