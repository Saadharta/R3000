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



ENTITY R3000 IS
	PORT (
		CLK : IN STD_LOGIC;
		DMem_Abus, IMem_Abus : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --Address
		DMem_Dbus, IMem_Dbus : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0'); --data
		DMem_WR : OUT STD_LOGIC );
END ENTITY;

ARCHITECTURE struct_r3000 OF R3000 IS 
FOR ALL : add use ENTITY CombinationalTools.adder(fdd_adder);
FOR ALL : multiplexor USE ENTITY CombinationalTools.multiplexor(fdd_multiplexor);
FOR ALL : UALControler USE ENTITY work.UALControler(fdd_ual_controler);
FOR ALL : CpMuxControler USE ENTITY work.CpMuxControler(fdd_cp_mux_controler);
FOR ALL : InstructionDecoder USE ENTITY work.InstructionDecoder(fdd_instruction_decoder);
FOR ALL : RegisterBank USE ENTITY work.RegisterBank(struct_register_bank);
FOR ALL : alu USE ENTITY work.ALU(struct_alu);
FOR ALL : Extension USE ENTITY work.Extension(fdd_extension);
FOR ALL : registre USE ENTITY SequentialTools.parallel_register(fdd_parallel_register);
component add 
	generic (word_size : INTEGER := 32);
	port(
		op_0 : IN STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
		op_1 : IN STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
		sum : OUT STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
		C : OUT STD_LOGIC
	);
end component;
component multiplexor
	generic (mux_size : INTEGER := 2);
	port(
		input : IN bus_mux_array((2**mux_size)-1 DOWNTO 0);
		sel_input : IN STD_LOGIC_VECTOR(mux_size-1 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;
component UALControler
	port(
		op : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		f : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		UALOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Enable_V : OUT STD_LOGIC;
		Slt_Slti : OUT STD_LOGIC;
		Sel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
end component;
component CpMuxControler
	port(
		B_ltz_ltzAl_gez_gezAl : IN STD_LOGIC;
		B_gtz : IN STD_LOGIC;
		B_lez : IN STD_LOGIC;
		B_ne : IN STD_LOGIC;
		B_eq : IN STD_LOGIC;
		N : IN STD_LOGIC;
		Z : IN STD_LOGIC;
		rt0 : IN STD_LOGIC;
		CPSrc : OUT STD_LOGIC
	);
end component;
component InstructionDecoder
	port(
		code_op : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		func_code : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		Saut : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		EcrireMem_W : OUT STD_LOGIC;
		EcrireMem_H : OUT STD_LOGIC;
		EcrireMem_B : OUT STD_LOGIC;
		LireMem_W : OUT STD_LOGIC;
		LireMem_UH : OUT STD_LOGIC;
		LireMem_UB : OUT STD_LOGIC;
		LireMem_SH : OUT STD_LOGIC;
		LireMem_SB : OUT STD_LOGIC;
		B_ltz_ltzAl_gez_gezAl : OUT STD_LOGIC;
		B_gtz : OUT STD_LOGIC;
		B_lez : OUT STD_LOGIC;
		B_ne : OUT STD_LOGIC;
		B_eq : OUT STD_LOGIC;
		UALOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		UALSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		EcrireReg : OUT STD_LOGIC;
		RegDst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		OpExt : OUT STD_LOGIC;
		MemVersReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
end component;
component RegisterBank
	port
	(
		source_register_0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		data_out_0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		source_register_1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		data_out_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		destination_register : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_register : IN STD_LOGIC;
		clk : IN STD_LOGIC
	);
end component;
component alu
	port(
		A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		Enable_V : IN STD_LOGIC;
		ValDec : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Slt : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		Res : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		N : OUT STD_LOGIC;
		Z : OUT STD_LOGIC;
		C : OUT STD_LOGIC;
		V : OUT STD_LOGIC
	);
end component;
component Extension
	port(
		OpExt : IN STD_LOGIC;
		inst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;
component registre
	generic
		( register_size : INTEGER := 32);
	port (
		wr : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR(register_size-1 DOWNTO 0);
		data_out : OUT STD_LOGIC_VECTOR(register_size-1 DOWNTO 0)
	);
end component;
-- internal signals
signal Code_op : STD_LOGIC_VECTOR(5 DOWNTO 0);
signal Code_fun : STD_LOGIC_VECTOR(5 DOWNTO 0);
signal CP : STD_LOGIC_VECTOR(31 DOWNTO 0);
-- cp_mux_ctrl output
signal cp_src : STD_LOGIC := '0';
-- alu_ctrl output
signal enable_v, slt : STD_LOGIC;
signal sel : STD_LOGIC_VECTOR(3 DOWNTO 0);
-- dec_instr
signal Dmem_r_W, Dmem_r_UH, Dmem_r_UB, Dmem_r_SH, Dmem_r_SB : STD_LOGIC;
signal DMem_w_W, DMem_w_H, DMem_w_B : STD_LOGIC;
signal B_ltz_ltzAl_gez_gezAl, B_gtz, B_lez, B_ne, B_eq : std_logic;
signal Jmp : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal ALU_op : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal ALU_src : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal Mem_to_reg : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal Reg_dst : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal ext_op : STD_LOGIC;
signal reg_w : STD_LOGIC;
-- reg_bank
signal Areg_1 : STD_LOGIC_VECTOR(4 DOWNTO 0) ; --out A
signal Reg_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
signal Areg_2 : STD_LOGIC_VECTOR(4 DOWNTO 0) ; --out B
signal Reg_2 : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
signal Areg_0 : STD_LOGIC_VECTOR(4 DOWNTO 0) :=(others => '0'); -- in
signal Reg_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
-- ALU
signal N, Z, V, C : STD_LOGIC;
signal ALU_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal ALU_res : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
signal Ext_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
-- CP ctrl
type Addr_array IS ARRAY(3 DOWNTO 0) OF STD_LOGIC_VECTOR(4 DOWNTO 0);
signal Areg0_mux_in : Addr_array ;

signal CP_add1_in2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000100";
signal CP_add_out : bus_mux_array(3 DOWNTO 0);
signal CP_add2_in2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Jmp_mux_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal C1, C2 : STD_LOGIC; -- Carrys for CP path adders, just hanging out there
signal Cp_src0 : std_logic_vector(1 DOWNTO 0);
signal ALU_b_mux_in4 : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Reg0_mux_in : bus_mux_array(3 DOWNTO 0);
signal Jmp_mux_in : bus_mux_array(3 DOWNTO 0);
signal ALU_b_mux_in : bus_mux_array(3 DOWNTO 0);
BEGIN 
	Code_op <= IMem_DBus(31 DOWNTO 26);
	Code_fun <= IMem_DBus(5 DOWNTO 0);
	-- CP logic
	cp_reg : registre port map (CLK, Jmp_mux_out, CP);
	-- CP adder1
	CP_add1 : add port map(CP, CP_add1_in2 , CP_add_out(0), C1);
	-- CP adder2
	CP_add2_in2(31 DOWNTO 2) <= Ext_out(29 DOWNTO 0);
	CP_add2_in2(1 DOWNTO 0) <= "00";
	CP_add2 : add port map(CP_add_out(0), CP_add2_in2, CP_add_out(1), C2);
	CP_add_out(2) <= (others => '0');
	CP_add_out(3) <= (others => '0');
	-- pseudo CPSrc
	Cp_src0 <= (0 => CP_Src, 1 => '0');
	-- jmp mux1
	jmp_mux_in_0 : multiplexor port map( CP_add_out, Cp_src0 , Jmp_mux_in(0) );
	-- jmp mux2	
	Jmp_mux_in(1)(31 DOWNTO 28)<= CP(31 DOWNTO 28);
	Jmp_mux_in(1)(27 DOWNTO 2)<= IMem_DBus(25 DOWNTO 0);
	Jmp_mux_in(1)(1 DOWNTO 0)<= "00";
	Jmp_mux_in(2) <= ALU_res;
	Jmp_mux_in(3) <= (others => '0');
	jmp_mux : multiplexor port map( Jmp_mux_in, Jmp, Jmp_mux_out);
	IMem_Abus <= CP;
	--end of CP logic

	-- register bank
	-- mux EcritureRegistre
	Areg0_mux_in <= (0 => IMem_DBus(20 DOWNTO 16), 1 => IMem_DBus(15 DOWNTO 11), 2 => (others => '1'), others => (others => '0'));
	AReg_0 <= AReg0_mux_in(to_integer(unsigned(Reg_dst)));
	Areg_1 <= IMem_Dbus(25 DOWNTO 21);
	AReg_2 <= IMem_Dbus(20 DOWNTO 16);
	-- mux Donnée à écrire
	Reg0_mux_in <= (0 => ALU_res, 1 => DMem_DBus, 2 => CP_add_out(0), others => (others => '0'));
	reg0_mux : multiplexor port map( Reg0_mux_in, Mem_to_reg, Reg_0);
	reg_bank : RegisterBank port map( Areg_1, Reg_1, Areg_2, Reg_2, Areg_0, Reg_0, reg_w, CLK);
	DMem_DBus <= Reg_2;
	-- end of register bank

	-- control unit
	-- instruction decoder
	dec_inst : InstructionDecoder port map( Code_op, Code_fun, Jmp, 
										DMem_w_W, DMem_w_H, DMem_w_B,
										Dmem_r_W, Dmem_r_UH, Dmem_r_UB, Dmem_r_SH, Dmem_r_SB,
										B_ltz_ltzAl_gez_gezAl, B_gtz, B_lez, B_ne, B_eq,
										ALU_op, ALU_src, reg_w, Reg_dst, ext_op, Mem_to_reg);
	-- DMem_WR basic control
	DMem_WR <=not( DMem_w_W or DMem_w_H or DMem_w_B) or (Dmem_r_W or Dmem_r_UH or Dmem_r_UB or Dmem_r_SH or Dmem_r_SB); 
	--CP mux Controler
	cu_mux_ctrl : CpMuxControler port map( B_ltz_ltzAl_gez_gezAl, B_gtz, B_lez, B_ne, B_eq, N ,Z , IMem_DBus(16), cp_src);
	-- ALU controler
	ALU_ctrl : UALControler port map( Code_op, Code_fun, ALU_op, enable_v, slt, sel);
	-- end of Control unit

	-- ALU
	ALU_b_mux_in4(15 DOWNTO 0) <= (others => '0');
	ALU_b_mux_in4(31 DOWNTO 16) <= IMem_Dbus(15 DOWNTO 0);
	ALU_b_mux_in <= (0 => Reg_2, 1 => Ext_out, 2 => (others => '0'), 3 => ALU_b_mux_in4);
	ALU_b : multiplexor port map(ALU_b_mux_in, ALU_src, ALU_2);
	AL_Unit : alu port map( Reg_1, ALU_2, sel, enable_v, "00000", slt, CLK, ALU_res, N, Z, V, C);
	DMem_ABus <= ALU_res;
	-- end of ALU

	-- extension
	ext : Extension port map( ext_op, IMem_DBus(15 DOWNTO 0), Ext_out);
	--end of extension


END ARCHITECTURE;