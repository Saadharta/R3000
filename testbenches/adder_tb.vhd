LIBRARY IEEE;
library CombinationalTools;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE CombinationalTools.bus_mux_pkg.ALL;

ENTITY test_adder is
END ENTITY test_adder;


ARCHITECTURE behavior of test_adder is
    --timing signals    
    constant clock_pulse : time := 1 ns;
    signal clock : STD_LOGIC := '0';
    signal done : std_logic := '0';
    -- testbench signals
    constant word_size : INTEGER := 32;
    SIGNAL tb_op_0 : STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
    SIGNAL tb_op_1 : STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
	SIGNAL tb_sum : STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
	SIGNAL tb_ecrireMem_W : STD_LOGIC;
	SIGNAL tb_ecrireMem_H : STD_LOGIC;
	SIGNAL tb_ecrireMem_B : STD_LOGIC;
	SIGNAL tb_lireMem_W : STD_LOGIC;
	SIGNAL tb_lireMem_UH : STD_LOGIC;
	SIGNAL tb_lireMem_UB : STD_LOGIC;
	SIGNAL tb_lireMem_SH : STD_LOGIC;
	SIGNAL tb_lireMem_SB : STD_LOGIC;
	SIGNAL tb_b_ltz_ltzAl_gez_gezAl : STD_LOGIC;
	SIGNAL tb_b_gtz : STD_LOGIC;
	SIGNAL tb_b_lez : STD_LOGIC;
	SIGNAL tb_b_ne : STD_LOGIC;
	SIGNAL tb_b_eq : STD_LOGIC;
	SIGNAL tb_UALOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL tb_UALSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL tb_ecrireReg : STD_LOGIC;
	SIGNAL tb_regDst : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL tb_opExt : STD_LOGIC;
    SIGNAL tb_memVersReg : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal tb_rMem : std_logic_vector(4 DOWNTO 0) := (others => '0');
    signal tb_wMem : STD_logic_vector(2 DOWNTO 0) := (others => '0');
    signal tb_cmp : std_logic_vector(4 DOWNTO 0) := (others => '0');
    
begin
    struct : ENTITY work.InstructionDecoder(fdd_instruction_decoder)
        PORT MAP(
            code_op => tb_code_op,
            func_code => tb_code_fun,
            Saut => tb_saut,
            EcrireMem_W => tb_ecrireMem_W,
            EcrireMem_H => tb_ecrireMem_H,
            EcrireMem_B => tb_ecrireMem_B,
            LireMem_W   => tb_lireMem_W,
            LireMem_UH  => tb_lireMem_UH,
            LireMem_UB  => tb_lireMem_UB,
            LireMem_SH  => tb_lireMem_SH,
            LireMem_SB  => tb_lireMem_SB,
            B_ltz_ltzAl_gez_gezAl => tb_b_ltz_ltzAl_gez_gezAl,
            B_gtz       => tb_b_gtz,
            B_lez       => tb_b_lez,
            B_ne        => tb_b_ne,
            B_eq        => tb_b_eq,
            UALOp       => tb_UALOp,
            UALSrc      => tb_UALSrc,
            EcrireReg   => tb_ecrireReg,
            RegDst      => tb_regDst,
            OpExt       => tb_opExt,
            MemVersReg  => tb_memVersReg
        );
    
    clk_gen_p: process is
    begin
        while done = '0' loop
            wait for clock_pulse/2;
            clock <= not clock;
        end loop;
        wait;
    end process;
    
    tb_wMem <= tb_ecrireMem_B&tb_ecrireMem_H & tb_ecrireMem_W;
    tb_rMem <= tb_lireMem_SB & tb_lireMem_SH & tb_lireMem_W & tb_lireMem_UB & tb_lireMem_UH ;
    tb_cmp  <= tb_b_eq & tb_b_ne & tb_b_lez & tb_b_gtz & tb_b_ltz_ltzAl_gez_gezAl;     
    
    stim_p :process
    begin
        done <= '0';
        tb_code_fun <="000000";
        -- test R
        tb_code_op <= "000000";
        wait until rising_edge(clock);
        assert  tb_regDst = "01" and tb_UALSrc="00" and tb_memVersReg="00" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "10" 
            report "Test R failed!" & CR & LF 
                    & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                    & std_logic'image(tb_regDst(0))(2) & CR & LF
                    & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                    & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                    & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                    & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                    & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                    & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                    & std_logic'image(tb_rMem(3))(2) 
                                    & std_logic'image(tb_rMem(2))(2) 
                                    & std_logic'image(tb_rMem(1))(2) 
                                    & std_logic'image(tb_rMem(0))(2) & CR & LF
                    & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                    & std_logic'image(tb_wMem(1))(2) 
                                    & std_logic'image(tb_wMem(0))(2) & CR & LF
                    & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                    & std_logic'image(tb_cmp(3))(2) 
                                    & std_logic'image(tb_cmp(2))(2) 
                                    & std_logic'image(tb_cmp(1))(2) 
                                    & std_logic'image(tb_cmp(0))(2) & CR & LF
                    & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                    & std_logic'image(tb_saut(0))(2) & CR & LF
                    & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                    & std_logic'image(tb_UALOp(0))(2)                                    
            severity error;
        -- test jr
        tb_code_fun <="001000";
        wait until rising_edge(clock);
        assert  tb_opExt = '0' and tb_UALSrc="00" and tb_ecrireReg = '0' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "10" and tb_UALOp = "00" 
            report "Test jr" & CR & LF 
                    & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                    & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                    & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                    & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                    & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                    & std_logic'image(tb_rMem(3))(2) 
                                    & std_logic'image(tb_rMem(2))(2) 
                                    & std_logic'image(tb_rMem(1))(2) 
                                    & std_logic'image(tb_rMem(0))(2) & CR & LF
                    & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                    & std_logic'image(tb_wMem(1))(2) 
                                    & std_logic'image(tb_wMem(0))(2) & CR & LF
                    & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                    & std_logic'image(tb_cmp(3))(2) 
                                    & std_logic'image(tb_cmp(2))(2) 
                                    & std_logic'image(tb_cmp(1))(2) 
                                    & std_logic'image(tb_cmp(0))(2) & CR & LF
                    & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                    & std_logic'image(tb_saut(0))(2) & CR & LF
                    & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                    & std_logic'image(tb_UALOp(0))(2)                                    
            severity error;
        -- test jalr
        tb_code_fun <= "001001";
        wait until rising_edge(clock);
        assert  tb_opExt = '0' and tb_regDst="01" and tb_UALSrc="00" and tb_memVersReg="10" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "10" and tb_UALOp = "00"
            report "Test jalr" & CR & LF 
                    & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                    & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                    & std_logic'image(tb_regDst(0))(2) & CR & LF
                    & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                    & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                    & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                    & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                    & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                    & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                    & std_logic'image(tb_rMem(3))(2) 
                                    & std_logic'image(tb_rMem(2))(2) 
                                    & std_logic'image(tb_rMem(1))(2) 
                                    & std_logic'image(tb_rMem(0))(2) & CR & LF
                    & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                    & std_logic'image(tb_wMem(1))(2) 
                                    & std_logic'image(tb_wMem(0))(2) & CR & LF
                    & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                    & std_logic'image(tb_cmp(3))(2) 
                                    & std_logic'image(tb_cmp(2))(2) 
                                    & std_logic'image(tb_cmp(1))(2) 
                                    & std_logic'image(tb_cmp(0))(2) & CR & LF
                    & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                    & std_logic'image(tb_saut(0))(2) & CR & LF
                    & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                    & std_logic'image(tb_UALOp(0))(2)                                    
            severity error;
        -- test bltz_gez_ltzAl_gezAl
        tb_code_op <= "000001";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_regDst = "10" and tb_UALSrc="10" and tb_memVersReg="10" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00001" and tb_saut = "00" and tb_UALOp = "01" 
                report "Test bltz_gez_ltzAl_gezAl" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test j
        tb_code_op <= "000010";
        wait until rising_edge(clock);
        assert tb_opExt = '0' and tb_ecrireReg = '0' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "01"
                report "Test j" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2)
            severity error;
        -- test jal
        tb_code_op <= "000011";
        wait until rising_edge(clock);
        assert tb_opExt = '0' and tb_regDst = "10" and tb_memVersReg="10" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "01"  
                report "Test jal" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2)   
            severity error;
        -- test beq
        tb_code_op <= "000100";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_UALSrc="00" and tb_ecrireReg = '0' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "10000" and tb_saut = "00" and tb_UALOp = "01" 
                report "Test beq" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test bne
        tb_code_op <= "000101";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_UALSrc="00" and tb_ecrireReg = '0' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "01000" and tb_saut = "00" and tb_UALOp = "01" 
                report "Test bne" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test blez
        tb_code_op <= "000110";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_UALSrc="00" and tb_ecrireReg = '0' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00100" and tb_saut = "00" and tb_UALOp = "01" 
                report "Test blez" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test bgtz
        tb_code_op <= "000111";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_UALSrc="00" and tb_ecrireReg = '0' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00010" and tb_saut = "00" and tb_UALOp = "01" 
                report "Test bgtz" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test addi
        tb_code_op <= "001000";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="00" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "11" 
                report "Test addi" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test addui
        tb_code_op <= "001001";
        wait until rising_edge(clock);
        assert tb_opExt = '0' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="00" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "11" 
                report "Test addui" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test slti
        tb_code_op <= "001010";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="00" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "11" 
                report "Test slti" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test sltui
        tb_code_op <= "001011";
        wait until rising_edge(clock);
        assert tb_opExt = '0' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="00" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "11" 
                report "Test sltui" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test andi
        tb_code_op <= "001100";
        wait until rising_edge(clock);
        assert tb_opExt = '0' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="00" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "11" 
                report "Test andi" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test ori
        tb_code_op <= "001101";
        wait until rising_edge(clock);
        assert tb_opExt = '0' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="00" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "11" 
                report "Test ori" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test xori
        tb_code_op <= "001110";
        wait until rising_edge(clock);
        assert tb_opExt = '0' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="00" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "11" 
                report "Test xori" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test lui
        tb_code_op <= "001111";
        wait until rising_edge(clock);
        assert tb_opExt = '0' and tb_regDst = "00" and tb_UALSrc="11" and tb_memVersReg="00" and tb_ecrireReg = '1' 
                and tb_rMem = "00000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "11" 
                report "Test lui" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test lb
        tb_code_op <= "100000";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="01" and tb_ecrireReg = '1' 
                and tb_rMem = "10000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "00" 
                report "Test lb" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test lh
        tb_code_op <= "100001";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="01" and tb_ecrireReg = '1' 
                and tb_rMem = "01000" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "00" 
                report "Test lh" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test lw
        tb_code_op <= "100011";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="01" and tb_ecrireReg = '1' 
                and tb_rMem = "00100" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "00" 
                report "Test lw" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test lbu
        tb_code_op <= "100100";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="01" and tb_ecrireReg = '1' 
                and tb_rMem = "00010" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "00" 
                report "Test lbu" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test lhu
        tb_code_op <= "100101";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_regDst = "00" and tb_UALSrc="01" and tb_memVersReg="01" and tb_ecrireReg = '1'
                and tb_rMem = "00001" and tb_wMem = "000" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "00" 
                report "Test lhu" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "regDst:     "& std_logic'image(tb_regDst(1))(2) 
                                & std_logic'image(tb_regDst(0))(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "MemVersReg: "& std_logic'image(tb_memVersReg(1))(2) 
                                & std_logic'image(tb_memVersReg(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test sb
        tb_code_op <= "101000";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_UALSrc="01" and tb_ecrireReg = '0' 
                and tb_rMem = "00000" and tb_wMem = "100" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "00" 
                report "Test sb" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test sh
        tb_code_op <= "101001";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_UALSrc="01" and tb_ecrireReg = '0' 
                and tb_rMem = "00000" and tb_wMem = "010" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "00" 
                report "Test sh" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- test sw
        tb_code_op <= "101011";
        wait until rising_edge(clock);
        assert tb_opExt = '1' and tb_UALSrc="01" and tb_ecrireReg = '0' 
                and tb_rMem = "00000" and tb_wMem = "001" and tb_cmp = "00000" and tb_saut = "00" and tb_UALOp = "00" 
                report "Test sw" & CR & LF 
                & "OpExt:      "& std_logic'image(tb_opExt)(2) & CR & LF
                & "UALSrc:     "& std_logic'image(tb_UALSrc(1))(2) 
                                & std_logic'image(tb_UALSrc(0))(2) & CR & LF
                & "EcrireReg:  "& std_logic'image(tb_ecrireReg)(2) & CR & LF
                & "LireMem:    "& std_logic'image(tb_rMem(4))(2) 
                                & std_logic'image(tb_rMem(3))(2) 
                                & std_logic'image(tb_rMem(2))(2) 
                                & std_logic'image(tb_rMem(1))(2) 
                                & std_logic'image(tb_rMem(0))(2) & CR & LF
                & "EcrireMem:  "& std_logic'image(tb_wMem(2))(2) 
                                & std_logic'image(tb_wMem(1))(2) 
                                & std_logic'image(tb_wMem(0))(2) & CR & LF
                & "B_cmp:      "& std_logic'image(tb_cmp(4))(2) 
                                & std_logic'image(tb_cmp(3))(2) 
                                & std_logic'image(tb_cmp(2))(2) 
                                & std_logic'image(tb_cmp(1))(2) 
                                & std_logic'image(tb_cmp(0))(2) & CR & LF
                & "Saut:       "& std_logic'image(tb_saut(1))(2) 
                                & std_logic'image(tb_saut(0))(2) & CR & LF
                & "UALOp:      "& std_logic'image(tb_UALOp(1))(2) 
                                & std_logic'image(tb_UALOp(0))(2)     
            severity error;
        -- signal to kill the clock
        done <= '1';
        wait;
    end process;
END architecture behavior;
