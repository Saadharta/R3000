LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY RegisterBank IS
	PORT
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
END ENTITY RegisterBank;

ARCHITECTURE struct_register_bank of RegisterBank is
signal selected_register : std_logic_vector(31 DOWNTO 0);
signal wr_register : std_logic_vector(31 DOWNTO 0);
signal bus_data_out : bus_mux_array(31 DOWNTO 0);
FOR ALL: decoder USE ENTITY CombinationalTools.decoder(fdd_decoder);
FOR ALL: multiplexor USE ENTITY CombinationalTools.multiplexor(fdd_multiplexor);
component decoder 
	generic(dec_size : integer := 5);
	port(input : in STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0);
			output : out STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0));
end component;
component multiplexor
	generic(mux_size : integer :=5);
	port(input : in bus_mux_array((2**mux_size)-1 DOWNTO 0);
		sel_input : in STD_LOGIC_VECTOR(mux_size-1 DOWNTO 0);
		output : out STD_LOGIC_VECTOR((2**mux_size)-1 DOWNTO 0));
end component;
component parallel_register
	generic(register_size : integer:=32);
	port(	wr : in STD_LOGIC;
			data_in : in STD_LOGIC_VECTOR(31 DOWNTO 0);
			data_out: out STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

--here is where the fun begins...
BEGIN
	dst_reg : decoder port map(	input => destination_register,
								output => selected_register);
	wr_reg : for ii in 0 TO 31 generate
		FOR ALL: parallel_register USE ENTITY sequentialTools.parallel_register(fdd_parallel_register);
		begin 
		w_regs :  wr_register(ii) <= '0' when ii = 0 else (selected_register(ii) and write_register and clk);
		p_regs: parallel_register port map(wr => wr_register(ii),
									data_in => data_in,
									data_out => bus_data_out(ii));
	end generate wr_reg;

	src_reg0 : multiplexor port map(input => bus_data_out,
							sel_input => source_register_0,
							output => data_out_0);
	src_reg1 : multiplexor port map(input => bus_data_out,
							sel_input => source_register_1,
							output => data_out_1);

END ARCHITECTURE;