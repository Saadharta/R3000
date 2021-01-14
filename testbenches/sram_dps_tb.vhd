LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY test_sram_dps is
END ENTITY test_sram_dps;


ARCHITECTURE behavior of test_sram_dps is
    --timing signals    
    constant clock_pulse : time := 1 ns;
    signal clock : STD_LOGIC := '0';
    signal done : std_logic := '0';
    
    constant tb_address_width : NATURAL := 8;
	constant tb_data_bus_width : NATURAL := 8;
    -- testbench signals
    SIGNAL tb_address : STD_LOGIC_VECTOR(tb_address_width-1 DOWNTO 0);
    signal tb_data_in : STD_LOGIC_VECTOR(tb_data_bus_width-1 DOWNTO 0); 
    signal tb_data_out : STD_LOGIC_VECTOR(tb_data_bus_width-1 DOWNTO 0); 
    signal tb_we, tb_cs, tb_oe, tb_clk : STD_LOGIC;

begin
    fdd0 : ENTITY work.sram_dps(seq_sram_dps)
    generic map(tb_address_width, tb_data_bus_width)
    port map (  address => tb_address,
                data_in => tb_data_in,
                data_out => tb_data_out,
                WE => tb_we,
                CS => tb_cs,
                OE => tb_oe,
                CLK => tb_clk);
    
    clk_gen_p: process is
    begin
        while done = '0' loop
            wait for clock_pulse/2;
            clock <= not clock;
        end loop;
        wait;
    end process;
    tb_clk <= clock;
    stim_p :process
    begin
        done <= '0';
        wait until rising_edge(clock);
        tb_address <="10011001";
        -- test CS = '1'
        tb_data_in <= "00000001";
        tb_we <= '0';
        tb_cs <= '1';
        tb_oe <= '0';
        wait until rising_edge(clock);
        assert tb_data_out = "ZZZZZZZZ" report "WE = '0' CS = '1' OE = '0' failed " & CR & LF 
                    & "data_out: "  & std_logic'image(tb_data_out(7))(2) 
                                    & std_logic'image(tb_data_out(6))(2)
                                    & std_logic'image(tb_data_out(5))(2)
                                    & std_logic'image(tb_data_out(4))(2)
                                    & std_logic'image(tb_data_out(3))(2)
                                    & std_logic'image(tb_data_out(2))(2)
                                    & std_logic'image(tb_data_out(1))(2)
                                    & std_logic'image(tb_data_out(0))(2)
        severity error;
        tb_we <= '1';
        tb_cs <= '0';
        tb_oe <= '1';
        wait until rising_edge(clock);
        assert tb_data_out = "ZZZZZZZZ" report "WE = '1' CS = '0' OE = '1' failed " & CR & LF 
                    & "data_out: "  & std_logic'image(tb_data_out(7))(2) 
                                    & std_logic'image(tb_data_out(6))(2)
                                    & std_logic'image(tb_data_out(5))(2)
                                    & std_logic'image(tb_data_out(4))(2)
                                    & std_logic'image(tb_data_out(3))(2)
                                    & std_logic'image(tb_data_out(2))(2)
                                    & std_logic'image(tb_data_out(1))(2)
                                    & std_logic'image(tb_data_out(0))(2)
        severity error;
        tb_we <= '0';
        tb_cs <= '0';
        tb_oe <= '1';
        wait until rising_edge(clock);
        assert tb_data_out = "ZZZZZZZZ" report "WE = '0' CS = '0' OE = '1' failed " & CR & LF 
                    & "data_out: "  & std_logic'image(tb_data_out(7))(2) 
                                    & std_logic'image(tb_data_out(6))(2)
                                    & std_logic'image(tb_data_out(5))(2)
                                    & std_logic'image(tb_data_out(4))(2)
                                    & std_logic'image(tb_data_out(3))(2)
                                    & std_logic'image(tb_data_out(2))(2)
                                    & std_logic'image(tb_data_out(1))(2)
                                    & std_logic'image(tb_data_out(0))(2)
        severity error;
        tb_we <= '1';
        tb_cs <= '0';
        tb_oe <= '0';
        wait until rising_edge(clock);
        assert tb_data_out = "00000001" report "WE = '1' CS = '0' OE = '0' failed " & CR & LF 
                    & "data_out: "  & std_logic'image(tb_data_out(7))(2) 
                                    & std_logic'image(tb_data_out(6))(2)
                                    & std_logic'image(tb_data_out(5))(2)
                                    & std_logic'image(tb_data_out(4))(2)
                                    & std_logic'image(tb_data_out(3))(2)
                                    & std_logic'image(tb_data_out(2))(2)
                                    & std_logic'image(tb_data_out(1))(2)
                                    & std_logic'image(tb_data_out(0))(2)
        severity error;
        
        -- signal to kill the clock
        done <= '1';
        wait;
    end process;
END architecture behavior;
