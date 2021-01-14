LIBRARY IEEE;
library CombinationalTools;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE CombinationalTools.bus_mux_pkg.ALL;

ENTITY test_extension is
END ENTITY test_extension;


ARCHITECTURE behavior of test_extension is
constant clock_pulse : time := 1 ns;
signal done : std_logic := '0';
SIGNAL clock : STD_LOGIC := '0';

signal tb_op : STD_LOGIC;
signal tb_inst : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal tb_output : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
    struct : ENTITY work.Extension(fdd_extension)
        PORT MAP	(
            OpExt => tb_op,
            inst => tb_inst,
            output => tb_output 
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
        -- test tb_op = '0'
        tb_op <= '0';
        tb_inst <= "0100000000000000";
        wait until rising_edge(clock);
        assert tb_output = "00000000000000000100000000000000" report "OpExt = '0' and inst(15) = '0' failed" severity failure;

        -- test tb_op = '0'
        tb_op <= '0';
        tb_inst <= "1000000000000000";
        wait until rising_edge(clock);
        assert tb_output = "00000000000000001000000000000000" report "OpExt = '0' and inst(15) = '1' failed" severity failure;
        
        -- test tb_op = '1'
        tb_op <= '1';
        tb_inst <= "0100000000000000";
        wait until rising_edge(clock);
        assert tb_output = "00000000000000000100000000000000" report "OpExt = '1' and inst(15) = '0' failed" severity failure;

        -- test tb_op = '1'
        tb_op <= '1';
        tb_inst <= "1000000000000000";
        wait until rising_edge(clock);
        assert tb_output = "11111111111111111000000000000000" report "OpExt = '1' and inst(15) = '1' failed" severity failure;
        
        done <= '1';
        wait;
    end process;
END architecture behavior;
