LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY ALU IS
	PORT(
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
END ENTITY ALU;

ARCHITECTURE struct_alu of ALU is
signal c30, c31, res0 : STD_LOGIC;
signal bus_in_mux : bus_mux_array(7 DOWNTO 0);
signal bus_out_mux : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal z_nor : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal flags_in : STD_LOGIC_vector (3 DOWNTO 0);
signal flags_out : STD_LOGIC_VECTOR (3 DOWNTO 0);
FOR ALL: barrel_shifter USE ENTITY combinationalTools.barrel_shifter(fdd_barrel_shifter);
FOR ALL: multiplexor USE ENTITY combinationalTools.multiplexor(fdd_multiplexor);
FOR ALL: alu_flags USE ENTITY sequentialTools.parallel_register(fdd_parallel_register);

component barrel_shifter 
	generic(shift_size : INTEGER := 5;
		shifter_width : INTEGER := 32);
	port(input : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		shift_amount : IN STD_LOGIC_VECTOR(shift_size-1 DOWNTO 0);
		LeftRight : IN STD_LOGIC;
		LogicArith : IN STD_LOGIC;
		ShiftRotate : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

component multiplexor
	generic(mux_size : integer :=3);
	port(	input : IN bus_mux_array((2**mux_size)-1 DOWNTO 0);
			sel_input : IN STD_LOGIC_VECTOR(mux_size-1 DOWNTO 0);
			output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
end component;
component alu_flags 
	generic(register_size : integer:=4);
	port(wr : in STD_LOGIC;
		data_in : in STD_LOGIC_VECTOR(register_size-1 DOWNTO 0);
		data_out: out STD_LOGIC_VECTOR(register_size-1 DOWNTO 0));
end component;
component adder
	port(A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		C_in : IN STD_LOGIC;
		Ret : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		C30 : OUT STD_LOGIC;
		C31 : OUT STD_LOGIC);
end component;
--here is where the fun begins...
BEGIN
	-- multiplexor
	-- 000 => and gate
	bus_in_mux(0) <= A and B;
	-- 001 => or gate
	bus_in_mux(1) <= A or  B;
	-- 010 => adder
	calc : adder port map(	A => A, 
							B => B, 
							C_in => sel(3),
							Ret => bus_in_mux(2),
							C30 => C30,
							C31 => C31);
	-- 011 => position if inferior
	res0 <= ( (not Enable_V) or flags_in(3) ) or ( Enable_V and ( ( C31 xor C30 ) xor flags_in(1) ) );
	bus_in_mux(3) <= (0 => res0, others => '0');
	-- 100 => nor gate
	bus_in_mux(4) <= A nor B;
	-- 101 => xor gate
	bus_in_mux(5) <= A xor B;
	-- 110 => lsr
	r_shift :  barrel_shifter port map (input => B, 
										shift_amount => ValDec, 
										LeftRight => '1', 
										LogicArith => '0', 
										ShiftRotate => '0', 
										output => bus_in_mux(6));
	-- 111 => lsl
	l_shift :  barrel_shifter port map (input => B, 
										shift_amount => ValDec, 
										LeftRight => '0', 
										LogicArith => '0', 
										ShiftRotate => '0', 
										output => bus_in_mux(7));
	mux_out : multiplexor port map(	input => bus_in_mux, 
									sel_input => sel(2 DOWNTO 0), 
									output => bus_out_mux);
	-- c flag in : C31 xor sel3									
	flags_in(3) <= C31 xor sel(3); 
	-- v flag in : not Slt and Enable_V and C31 xor C30									
	flags_in(2) <= (not Slt) and Enable_v and (C31 xor C30);
	-- n flag in : S31 out of adder									
	flags_in(1) <= bus_in_mux(2)(31);
	-- z flag in : bitwize nor from multiplexor output	
	z_nor(0) <= bus_out_mux(0);								
	z_flag : for ii in 1 to 31 generate
		z_nor(ii) <= z_nor(ii-1) or bus_out_mux(ii);
	end generate z_flag;
	flags_in(0) <= not (z_nor(31) );
	-- flags latches
	cvnz : alu_flags port map(	wr => CLK, 
								data_in => flags_in,
								data_out => flags_out);
	C <= flags_out(3);
	V <= flags_out(2);
	N <= flags_out(1);
	Z <= flags_out(0);
	Res <= bus_out_mux;
END ARCHITECTURE;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY adder IS 
    PORT(
        A : in STD_LOGIC_VECTOR (31 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        C_in : IN STD_LOGIC;
        Ret : out STD_LOGIC_VECTOR(31 DOWNTO 0);
        C30 : OUT STD_LOGIC;
        C31 : OUT STD_LOGIC);
END ENTITY;
ARCHITECTURE fdd_adder OF adder is
	signal b_xor,cin_v: std_logic_vector(31 DOWNTO 0);
	signal res_xor1, res_xor2, carry_and1, carry_and2, carry_or : std_logic_vector(31 DOWNTO 0);
BEGIN
	cin_v <= (others => C_in);
	b_xor <= B xor cin_v;
	res_xor1 <= A xor B_xor;
	carry_and1 <= A and b_xor;
	carry_and2(0) <= C_in and res_xor1(0);
	res_xor2(0) <= res_xor1(0) xor C_in;
	carry_or <= carry_and2 or carry_and1;
	adder_iter : for ii in 1 to 31 generate
		carry_and2(ii) <= res_xor1(ii) and carry_or(ii-1); 
		res_xor2(ii) <= res_xor1(ii) xor carry_or(ii-1);
	end generate adder_iter;
	ret <= res_xor2;
    C30 <= carry_or(30);
    C31 <= carry_or(31);
END ARCHITECTURE;