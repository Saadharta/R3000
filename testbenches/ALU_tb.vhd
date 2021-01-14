LIBRARY IEEE;
library CombinationalTools;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE CombinationalTools.bus_mux_pkg.ALL;

ENTITY test_alu is
END ENTITY test_alu;


ARCHITECTURE behavior of test_alu is
constant clock_pulse : time := 1 ns;
signal done : std_logic := '0';
SIGNAL clock : STD_LOGIC := '0';

SIGNAL inputA : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL inputB : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL selecteur : STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL enable : STD_LOGIC;
SIGNAL slt : STD_LOGIC;
SIGNAL Negatif : STD_LOGIC;
SIGNAL Zero : STD_LOGIC;
SIGNAL Overflow : STD_LOGIC;
SIGNAL Carry : STD_LOGIC;
SIGNAL output : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL shiftAmount : STD_LOGIC_VECTOR(4 DOWNTO 0);
begin
    struct : ENTITY work.ALU(struct_ALU)

        PORT MAP	(
            A => inputA,
            B => inputB,
            sel => selecteur,
            Enable_V => enable,
            ValDec => shiftAmount,
            Slt => slt,
            CLK => clock,
            Res => output,
            N => Negatif,
            Z => Zero,
            V => Overflow,
            C => Carry
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
        inputA <= std_logic_vector(to_signed(150,32));
        inputB <= std_logic_vector(to_signed(36,32));
        enable <= '0';
        slt <= '0';
        shiftAmount<=std_logic_vector(to_unsigned(2,5));

        --and 150 ET 36
        selecteur <= "0000";
        wait until rising_edge(clock);
        assert output = "00000000000000000000000000000100" report "and" severity failure;

        --OR 150 ET 36
        selecteur <= "0001";
        wait until rising_edge(clock);
        assert output = "00000000000000000000000010110110" report "or" severity failure;

        --ADD => 150 + 36
        selecteur <= "0010";
        enable <= '1';
        wait until rising_edge(clock);
        assert to_integer(signed(output)) = 186 report "add 150 + 36" severity failure;
        assert Zero = '0' report "ZERO" severity failure;
        --SUB => 150 - 36
        selecteur <= "1010";
        wait until rising_edge(clock);
        assert to_integer(signed(output)) = 114 report "add 150 - 36" severity failure;

        --NOR 150 et 36
        selecteur <= "0100";
        enable <= '0';
        wait until rising_edge(clock);
        assert output = "11111111111111111111111101001001" report "nor" severity failure;

        --XOR 150 et 36
        selecteur <= "0101";
        wait until rising_edge(clock);
        assert output = "00000000000000000000000010110010" report "xor" severity failure;

        --SHIFTleft de 2 SUR 36
        selecteur <= "0110";
        wait until rising_edge(clock);
        assert output = "00000000000000000000000000001001" report "shiftRight" severity failure;
        
        --SHIFTRight de 2 SUR 36
        selecteur <= "0111";
        wait until rising_edge(clock);
        assert output = "00000000000000000000000010010000" report "ShiftLeft" severity failure;

        --ADD => 150 + (-36)
        inputB <= std_logic_vector(to_signed(-36,32));
        selecteur <= "0010";
        enable <= '1';
        wait until rising_edge(clock);
        assert to_integer(signed(output)) = 114 report "add 150  -36" severity failure;

        --SUB =>  150 - (-36)
        selecteur <= "1010";
        wait until rising_edge(clock);
        assert to_integer(signed(output)) = 186 report "sub 150  -36" severity failure;

        --test flag N
        inputB <= std_logic_vector(to_signed(180,32));
        selecteur <= "1010";
        wait until rising_edge(clock);
        assert Negatif = '1' report "Negatif" severity failure;

        --test flag Z
        inputB <= std_logic_vector(to_signed(0,32));
        selecteur <= "0000";
        enable <= '0';
        wait until rising_edge(clock);
        assert Zero = '1' report "ZERO" severity failure;

        --test flag V en overflow positif
        inputA<="01111111111111111111111111111111";
        inputB<="01111111111111111111111111111111";
        enable <= '1';
        selecteur <= "0010";
        wait until rising_edge(clock);
        assert Overflow = '1' report "Overflow + + => -" severity failure;

        --test flag V en overflow negatif
        inputA<="10000000000000000000010000000000";
        inputB<="10000000000000000000000001000000";
        enable <= '1';
        selecteur <= "0010";
        wait until rising_edge(clock);
        assert Overflow = '1' report "Overflow - - => +" severity failure;

        --test flag c
        inputA<="11111111111111111111111111111111";
        inputB<="00000000000000000000000000000001";
        selecteur <= "0010";
        enable <= '1';
        wait until rising_edge(clock);
        assert Carry = '1' report "Carry" severity failure;

        --test logique positionnement si inferieur = 1
        enable<='0';
        selecteur <= "0011";
        wait until rising_edge(clock);
        assert output = "00000000000000000000000000000001" report "output should be 1" severity failure;
        
        --test logique position si inferieur = 0
        inputA<="00000000000000000000000000000001";
        inputB<="00000000000000000000000000000001";
        enable<='1';
        wait until rising_edge(clock);
        assert output = "00000000000000000000000000000000" report "output should be 0" severity failure;
        done <= '1';
        wait;
    end process;
END architecture behavior;
