LIBRARY IEEE;
library CombinationalTools;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE CombinationalTools.bus_mux_pkg.ALL;

ENTITY test_cp_mux_controler is
END ENTITY test_cp_mux_controler;


ARCHITECTURE behavior of test_cp_mux_controler is
constant clock_pulse : time := 1 ns;
signal done : std_logic := '0';
SIGNAL clock : STD_LOGIC := '0';

signal tb_BLtzGezAl :  STD_LOGIC := '0';
signal tb_Bgtz : STD_LOGIC := '0';
signal tb_Blez : STD_LOGIC := '0';
signal tb_Bne : STD_LOGIC := '0';
signal tb_Beq : STD_LOGIC := '0';
signal tb_N : STD_LOGIC := '0';
signal tb_Z : STD_LOGIC := '0';
signal tb_rt0 : STD_LOGIC := '0';
signal tb_CPSrc : STD_LOGIC;

begin
    struct : ENTITY work.CpMuxControler(fdd_cp_mux_controler)
        PORT MAP	(
            B_ltz_ltzAl_gez_gezAl => tb_BLtzGezAl,
		    B_gtz => tb_Bgtz,
		    B_lez => tb_Blez,
		    B_ne => tb_Bne,
		    B_eq => tb_Beq,
            N => tb_N,
            Z => tb_Z,
            rt0 => tb_rt0,
            CPSrc => tb_CPSrc
        );
    
    clk_gen_p: process is
    begin
        while done = '0' loop
            wait for clock_pulse;
            clock <= not clock;
        end loop;
        wait;
    end process;
          
    stim :process
    begin
        done <= '0';
        -- test B_eq and Z
        tb_Beq <= '1';
        tb_Z <= '1';
        wait until rising_edge(clock);
        assert tb_CPSrc = '1' report "B_eq and Z failed" severity failure;
        -- test B_ne and (not Z)
        tb_Bne <= '1';
        tb_Z <= '0';
        wait until rising_edge(clock);
        assert tb_CPSrc = '1' report "B_ne and (not Z) failed" severity failure;
        -- test B_lez and ( N or Z)
        tb_Blez <= '1';
        tb_Z <= '0';
        tb_N <= '1';
        wait until rising_edge(clock);
        assert tb_CPSrc = '1' report "B_lez and ( N or Z) failed" severity failure;
        -- test B_gtz and (not N) and (not Z)
        tb_Bgtz <= '1';
        tb_Z <= '0';
        tb_N <= '0';
        wait until rising_edge(clock);
        assert tb_CPSrc = '1' report "B_gtz and (not N) and (not Z) failed" severity failure;
        -- test tb_BLtzGezAl 1
        tb_BLtzGezAl <= '1';
        tb_Z <= '0';
        tb_N <= '1';
        tb_rt0 <= '0';
        wait until rising_edge(clock);
        assert tb_CPSrc = '1' report "B_ltz_ltzAl_gez_gezAl and N and (not Z) and (not rt0)  failed" severity failure;
        -- test tb_BLtzGezAl 2
        tb_BLtzGezAl <= '1';
        tb_Z <= '1';
        tb_N <= '0';
        tb_rt0 <= '1';
        wait until rising_edge(clock);
        assert tb_CPSrc = '1' report "B_ltz_ltzAl_gez_gezAl and rt0 and ((not N) or Z)  failed" severity failure;
        done <= '1';
        wait;
    end process;
END architecture behavior;
