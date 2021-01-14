-- Standard libraries
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_MISC.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- User-defined libraries
LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;


ENTITY test_r3000 is
END ENTITY test_r3000;


ARCHITECTURE behavior of test_r3000 is
    --timing signals    
    constant clock_pulse : time := 1 ns;
    signal clock : STD_LOGIC := '0';
    signal done : std_logic := '0';
    -- testbench signals
    signal tb_DMem_Abus, tb_IMem_Abus : STD_LOGIC_VECTOR(31 DOWNTO 0); --Address
	signal tb_DMem_Dbus, tb_IMem_Dbus : STD_LOGIC_VECTOR(31 DOWNTO 0); --data
    signal tb_DMem_WR : STD_LOGIC;
    signal tb_AMem_WR : STD_LOGIC;
		
    --constant tb_address_width : NATURAL := 8;
    --constant tb_data_bus_width : NATURAL := 8;
    
begin
    struct : ENTITY work.R3000(struct_r3000)
        PORT MAP(
            CLK => clock,
            DMem_Abus => tb_DMem_Abus,
            IMem_Abus => tb_IMem_ABus, --Address
            DMem_Dbus => tb_DMem_Dbus,
            IMem_Dbus => tb_IMem_Dbus, --data
		    DMem_WR => tb_DMem_WR
        );
    
    clk_gen_p: process is
    begin
        while done = '0' loop
            wait for clock_pulse/2;
            clock <= not clock;
        end loop;
        wait;
    end process;
    
    stim_p :process
    begin
        done <= '0';
        tb_DMem_DBus <= (others => 'Z');

        tb_IMem_Dbus <= "001111"&"00000"&"00100"&"0000000000000001"; -- lui r4, 0b1
        wait until falling_edge(clock);
        tb_IMem_Dbus <= "001111"&"00000"&"00101"&"0000000000000001"; -- lui r5, 0b1
        wait until falling_edge(clock);
        tb_IMem_Dbus <= "000000"&"00100"&"00101"&"00110"&"00000"&"100001"; -- addu r6, r4, r5
        wait until falling_edge(clock);
        tb_IMem_DBus <= "101011"&"00000"&"00110"&"0000000000000011"; -- sw r0+0b11, r6
        wait until falling_edge(clock);
        
        assert  tb_DMem_Abus = "00000000000000000000000000000011" and tb_DMem_Dbus="00000000000000100000000000000000" and tb_DMem_WR = '0'
            report "Test ADD failed!" & CR & LF 
                    & "tb_DMem_WR: "    & std_logic'image(tb_DMem_WR)(2) & CR & LF
                    & "tb_IMem_ABus: "  & std_logic'image(tb_IMem_ABus(31))(2)
                                        & std_logic'image(tb_IMem_ABus(30))(2)
                                        & std_logic'image(tb_IMem_ABus(29))(2)
                                        & std_logic'image(tb_IMem_ABus(28))(2)
                                        & std_logic'image(tb_IMem_ABus(27))(2)
                                        & std_logic'image(tb_IMem_ABus(26))(2)
                                        & std_logic'image(tb_IMem_ABus(25))(2)
                                        & std_logic'image(tb_IMem_ABus(24))(2)
                    & " "               & std_logic'image(tb_IMem_ABus(23))(2)
                                        & std_logic'image(tb_IMem_ABus(22))(2)
                                        & std_logic'image(tb_IMem_ABus(21))(2)
                                        & std_logic'image(tb_IMem_ABus(20))(2)
                                        & std_logic'image(tb_IMem_ABus(19))(2)
                                        & std_logic'image(tb_IMem_ABus(18))(2)
                                        & std_logic'image(tb_IMem_ABus(17))(2)
                                        & std_logic'image(tb_IMem_ABus(16))(2)
                    & " "               & std_logic'image(tb_IMem_ABus(15))(2)
                                        & std_logic'image(tb_IMem_ABus(14))(2)
                                        & std_logic'image(tb_IMem_ABus(13))(2)
                                        & std_logic'image(tb_IMem_ABus(12))(2)
                                        & std_logic'image(tb_IMem_ABus(11))(2)
                                        & std_logic'image(tb_IMem_ABus(10))(2)
                                        & std_logic'image(tb_IMem_ABus(9))(2)
                                        & std_logic'image(tb_IMem_ABus(8))(2)
                    & " "               & std_logic'image(tb_IMem_ABus(7))(2)
                                        & std_logic'image(tb_IMem_ABus(6))(2)
                                        & std_logic'image(tb_IMem_ABus(5))(2)
                                        & std_logic'image(tb_IMem_ABus(4))(2)
                                        & std_logic'image(tb_IMem_ABus(3))(2)
                                        & std_logic'image(tb_IMem_ABus(2))(2)
                                        & std_logic'image(tb_IMem_ABus(1))(2)
                                        & std_logic'image(tb_IMem_ABus(0))(2) & CR & LF 
                    & "tb_IMem_DBus: "  & std_logic'image(tb_IMem_DBus(31))(2)
                                        & std_logic'image(tb_IMem_DBus(30))(2)
                                        & std_logic'image(tb_IMem_DBus(29))(2)
                                        & std_logic'image(tb_IMem_DBus(28))(2)
                                        & std_logic'image(tb_IMem_DBus(27))(2)
                                        & std_logic'image(tb_IMem_DBus(26))(2)
                                        & std_logic'image(tb_IMem_DBus(25))(2)
                                        & std_logic'image(tb_IMem_DBus(24))(2)
                    & " "               & std_logic'image(tb_IMem_DBus(23))(2)
                                        & std_logic'image(tb_IMem_DBus(22))(2)
                                        & std_logic'image(tb_IMem_DBus(21))(2)
                                        & std_logic'image(tb_IMem_DBus(20))(2)
                                        & std_logic'image(tb_IMem_DBus(19))(2)
                                        & std_logic'image(tb_IMem_DBus(18))(2)
                                        & std_logic'image(tb_IMem_DBus(17))(2)
                                        & std_logic'image(tb_IMem_DBus(16))(2)
                    & " "               & std_logic'image(tb_IMem_DBus(15))(2)
                                        & std_logic'image(tb_IMem_DBus(14))(2)
                                        & std_logic'image(tb_IMem_DBus(13))(2)
                                        & std_logic'image(tb_IMem_DBus(12))(2)
                                        & std_logic'image(tb_IMem_DBus(11))(2)
                                        & std_logic'image(tb_IMem_DBus(10))(2)
                                        & std_logic'image(tb_IMem_DBus(9))(2)
                                        & std_logic'image(tb_IMem_DBus(8))(2)
                    & " "               & std_logic'image(tb_IMem_DBus(7))(2)
                                        & std_logic'image(tb_IMem_DBus(6))(2)
                                        & std_logic'image(tb_IMem_DBus(5))(2)
                                        & std_logic'image(tb_IMem_DBus(4))(2)
                                        & std_logic'image(tb_IMem_DBus(3))(2)
                                        & std_logic'image(tb_IMem_DBus(2))(2)
                                        & std_logic'image(tb_IMem_DBus(1))(2)
                                        & std_logic'image(tb_IMem_DBus(0))(2) & CR & LF 
                    & "tb_DMem_Abus: "  & std_logic'image(tb_DMem_Abus(31))(2)
                                        & std_logic'image(tb_DMem_Abus(30))(2)
                                        & std_logic'image(tb_DMem_Abus(29))(2)
                                        & std_logic'image(tb_DMem_Abus(28))(2)
                                        & std_logic'image(tb_DMem_Abus(27))(2)
                                        & std_logic'image(tb_DMem_Abus(26))(2)
                                        & std_logic'image(tb_DMem_Abus(25))(2)
                                        & std_logic'image(tb_DMem_Abus(24))(2)
                    & " "               & std_logic'image(tb_DMem_Abus(23))(2)
                                        & std_logic'image(tb_DMem_Abus(22))(2)
                                        & std_logic'image(tb_DMem_Abus(21))(2)
                                        & std_logic'image(tb_DMem_Abus(20))(2)
                                        & std_logic'image(tb_DMem_Abus(19))(2)
                                        & std_logic'image(tb_DMem_Abus(18))(2)
                                        & std_logic'image(tb_DMem_Abus(17))(2)
                                        & std_logic'image(tb_DMem_Abus(16))(2)
                    & " "               & std_logic'image(tb_DMem_Abus(15))(2)
                                        & std_logic'image(tb_DMem_Abus(14))(2)
                                        & std_logic'image(tb_DMem_Abus(13))(2)
                                        & std_logic'image(tb_DMem_Abus(12))(2)
                                        & std_logic'image(tb_DMem_Abus(11))(2)
                                        & std_logic'image(tb_DMem_Abus(10))(2)
                                        & std_logic'image(tb_DMem_Abus(9))(2)
                                        & std_logic'image(tb_DMem_Abus(8))(2)
                    & " "               & std_logic'image(tb_DMem_Abus(7))(2)
                                        & std_logic'image(tb_DMem_Abus(6))(2)
                                        & std_logic'image(tb_DMem_Abus(5))(2)
                                        & std_logic'image(tb_DMem_Abus(4))(2)
                                        & std_logic'image(tb_DMem_Abus(3))(2)
                                        & std_logic'image(tb_DMem_Abus(2))(2)
                                        & std_logic'image(tb_DMem_Abus(1))(2)
                                        & std_logic'image(tb_DMem_Abus(0))(2) & CR & LF 
                    & "tb_DMem_Dbus: "  & std_logic'image(tb_DMem_Dbus(31))(2)
                                        & std_logic'image(tb_DMem_Dbus(30))(2)
                                        & std_logic'image(tb_DMem_Dbus(29))(2)
                                        & std_logic'image(tb_DMem_Dbus(28))(2)
                                        & std_logic'image(tb_DMem_Dbus(27))(2)
                                        & std_logic'image(tb_DMem_Dbus(26))(2)
                                        & std_logic'image(tb_DMem_Dbus(25))(2)
                                        & std_logic'image(tb_DMem_Dbus(24))(2)
                    & " "               & std_logic'image(tb_DMem_Dbus(23))(2)
                                        & std_logic'image(tb_DMem_Dbus(22))(2)
                                        & std_logic'image(tb_DMem_Dbus(21))(2)
                                        & std_logic'image(tb_DMem_Dbus(20))(2)
                                        & std_logic'image(tb_DMem_Dbus(19))(2)
                                        & std_logic'image(tb_DMem_Dbus(18))(2)
                                        & std_logic'image(tb_DMem_Dbus(17))(2)
                                        & std_logic'image(tb_DMem_Dbus(16))(2)
                    & " "               & std_logic'image(tb_DMem_Dbus(15))(2)
                                        & std_logic'image(tb_DMem_Dbus(14))(2)
                                        & std_logic'image(tb_DMem_Dbus(13))(2)
                                        & std_logic'image(tb_DMem_Dbus(12))(2)
                                        & std_logic'image(tb_DMem_Dbus(11))(2)
                                        & std_logic'image(tb_DMem_Dbus(10))(2)
                                        & std_logic'image(tb_DMem_Dbus(9))(2)
                                        & std_logic'image(tb_DMem_Dbus(8))(2)
                    & " "               & std_logic'image(tb_DMem_Dbus(7))(2)
                                        & std_logic'image(tb_DMem_Dbus(6))(2)
                                        & std_logic'image(tb_DMem_Dbus(5))(2)
                                        & std_logic'image(tb_DMem_Dbus(4))(2)
                                        & std_logic'image(tb_DMem_Dbus(3))(2)
                                        & std_logic'image(tb_DMem_Dbus(2))(2)
                                        & std_logic'image(tb_DMem_Dbus(1))(2)
                                        & std_logic'image(tb_DMem_Dbus(0))(2) & CR & LF                               
            severity failure;
        -- signal to kill the clock
        done <= '1';
        wait;
    end process;
END architecture behavior;

        --tb_IMem_DBus <= "10001100000000100000000000000100"; --lw r2 4
        --wait until falling_edge(clock);
        --tb_IMem_DBus <= "10001100000000100000000000000100"; --lw r1 0
        --wait until falling_edge(clock);
        --tb_IMem_DBus <= "10001100000000100000000000000100"; --addi r4 r0 15
        --wait until falling_edge(clock);
        --tb_IMem_DBus <= "10001100000000100000000000000100";--add r3 r1 r2
        --wait until falling_edge(clock);
        --tb_IMem_DBus <= "10001100000000100000000000000100"; --addi r5 r4 9
        --wait until falling_edge(clock);
        --tb_IMem_DBus <= "10001100000000100000000000000100"; --sw r3 8
        --wait until falling_edge(clock);