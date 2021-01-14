LIBRARY IEEE;
library CombinationalTools;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE CombinationalTools.bus_mux_pkg.ALL;

ENTITY test_ual_controler is
END ENTITY test_ual_controler;


ARCHITECTURE behavior of test_ual_controler is
constant clock_pulse : time := 1 ns;
signal done : std_logic := '0';
SIGNAL clock : STD_LOGIC := '0';

signal tb_op : STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
signal tb_f : STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
signal tb_ALUOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal tb_enableV : STD_LOGIC;
signal tb_slt : STD_LOGIC;
signal tb_Sel : STD_LOGIC_VECTOR(3 DOWNTO 0);
begin
    struct : ENTITY work.UALControler(fdd_ual_controler)
        PORT MAP	(
            op => tb_op,
		    f => tb_f,
		    UALOp => tb_ALUOp,
		    Enable_V => tb_enableV,
		    Slt_Slti => tb_slt,
		    Sel => tb_sel
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
        -- test Enable_V fun = "1xx0x0"
        tb_ALUOp <= "10";
        tb_f <= (5 => '1', 2 => '0', 0 => '0', others => '1');
        wait until rising_edge(clock);
        assert tb_enableV = '1' report "EnableV fun = '1xx0x0' failed" severity failure;
        -- test Enable_V op = "xxx0x0"
        tb_ALUOp <= "11";
        tb_op <= (2=> '0', 0 => '0', others => '0');
        wait until rising_edge(clock);
        assert tb_enableV = '1' report "EnableV op = 'xxx0x0' failed" severity failure;
        

        -- test Slt_Slti fun = "1xx00x"
        tb_ALUOp <= "10";
        tb_f <= (3 => '1', 2 => '0', 1 => '1', 0 => '0', others => '1');
        wait until rising_edge(clock);
        assert tb_slt = '1' report "Slt_Slti fun = 'xx1010' failed" severity failure;
        -- test Slt_Slti op = "xxx010"
        tb_ALUOp <= "11";
        tb_op <= (2=> '0', 1 =>'1', 0 => '0', others => '0');
        wait until rising_edge(clock);
        assert tb_slt = '1' report "Slt_Slti op = 'xxx010' failed" severity failure;


        -- test sel(0) fun = "0x0000"
        tb_ALUOp <= "10";
        tb_f <= (5 => '0', 3 => '0', 2 => '0', 1 => '0', 0 => '0', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(0) = '1' report "sel(0) fun = '0x0000' failed" severity failure;
        -- test sel(0) fun = "1x0101"
        tb_f <= (5 => '1', 3 => '0', 2 => '1', 1 => '0', 0 => '1', others => '0');
        wait until rising_edge(clock);
        assert tb_sel(0) = '1' report "sel(0) fun = '1x0101' failed" severity failure;
        -- test sel(0) fun = "0x0110"
        tb_f <= (5 => '0', 3 => '0', 2 => '1', 1 => '1', 0 => '0', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(0) = '1' report "sel(0) fun = '0x0110' failed" severity failure;
        -- test sel(0) fun = "0x101x"
        tb_f <= (5 => '0', 3 => '1', 2 => '0', 1 => '1', others => '0');
        wait until rising_edge(clock);
        assert tb_sel(0) = '1' report "sel(0) fun = '0x101x' failed" severity failure;
        -- test sel(0) op = "xxxx1x"
        tb_ALUOp <= "11";
        tb_op <= (1=> '1', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(0) = '1' report "sel(0) op = 'xxxx1x' failed" severity failure;
        -- test sel(0) op = "xxx010"
        tb_op <= (2=> '1', 1 =>'0', 0 => '1', others => '0');
        wait until rising_edge(clock);
        assert tb_sel(0) = '1' report "sel(0) op = 'xxx101' failed" severity failure;


        -- test sel(1) UALOp(1) = '0'
        tb_ALUOp <= (1 => '0', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(1) = '1' report "sel(1) UALOp(1) = '0' failed" severity failure;
        -- test sel(1) fun = "xx00x0"
        tb_ALUOp <= "10";
        tb_f <= (3 => '0', 2 => '0', 0 => '0', others => '0');
        wait until rising_edge(clock);
        assert tb_sel(1) = '1' report "sel(1) fun = 'xx00x0' failed" severity failure;
        -- test sel(1) fun = "0x0100"
        tb_f <= (5 => '0', 3 => '0', 2 => '1', 1 => '0', 0 => '0', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(1) = '1' report "sel(1) fun = '0x0100' failed" severity failure;
        -- test sel(1) fun = "0x1001"
        tb_f <= (5 => '0', 3 => '1', 2 => '0', 1 => '1', 0 => '1', others => '0');
        wait until rising_edge(clock);
        assert tb_sel(1) = '1' report "sel(1) fun = '0x1001' failed" severity failure;
        -- test sel(1) fun = "1x00x1"
        tb_f <= (5 => '1', 3 => '0', 2 => '0', 0 => '1', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(1) = '1' report "sel(1) fun = '1x00x1' failed" severity failure;
        -- test sel(1) fun = "0x101x"
        tb_f <= (5 => '0', 3 => '1', 2 => '0', 1 => '1', others => '0');
        wait until rising_edge(clock);
        assert tb_sel(1) = '1' report "sel(1) fun = '0x101x' failed" severity failure;
        -- test sel(1) op = "xxx0xx"
        tb_ALUOp <= "11";
        tb_op <= (2=> '0', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(1) = '1' report "sel(1) op = 'xxx0xx' failed" severity failure;


        -- test sel(2) fun = "0x00x0"
        tb_ALUOp <= "10";
        tb_f <= (5 => '0', 3 => '0', 2 => '0', 0 => '0', others => '0');
        wait until rising_edge(clock);
        assert tb_sel(2) = '1' report "sel(2) fun = '0x00x0' failed" severity failure;
        -- test sel(2) fun = "0x011x"
        tb_f <= (5 => '0', 3 => '0', 2 => '1', 1 => '1', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(2) = '1' report "sel(2) fun = '0x011x' failed" severity failure;
        -- test sel(2) op = "xxx110"
        tb_ALUOp <= "11";
        tb_op <= (2=> '1', 1 =>'1', 0 => '0', others => '0');
        wait until rising_edge(clock);
        assert tb_sel(2) = '1' report "sel(2) op = 'xxx110' failed" severity failure;


        -- test sel(3) UALOp = "01"
        tb_ALUOp <= "01";
        wait until rising_edge(clock);
        assert tb_sel(3) = '1' report "sel(3) UALOp(1) = '01' failed" severity failure;
        -- test sel(1) fun = "1x001x"
        tb_ALUOp <= "10";
        tb_f <= (5 => '1', 3 => '0', 2 => '0', 1 => '1', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(3) = '1' report "sel(3) fun = '1x001x' failed" severity failure;
        -- test sel(1) fun = "0x101x"
        tb_f <= (5 => '0', 3 => '1', 2 => '0', 1 => '1', others => '0');
        wait until rising_edge(clock);
        assert tb_sel(3) = '1' report "sel(3) fun = '0x101x' failed" severity failure;
        -- test sel(2) op = "xxx01x"
        tb_ALUOp <= "11";
        tb_op <= (2=> '0', 1 =>'1', others => '1');
        wait until rising_edge(clock);
        assert tb_sel(3) = '1' report "sel(3) op = 'xxx01x' failed" severity failure;

        done <= '1';
        wait;
    end process;
END architecture behavior;
