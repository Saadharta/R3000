LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY UALControler IS
	PORT
	(
		op : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		f : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		UALOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Enable_V : OUT STD_LOGIC;
		Slt_Slti : OUT STD_LOGIC;
		Sel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY UALControler;

ARCHITECTURE fdd_ual_controler of UALControler IS
	function or_reduce(tab : std_logic_vector) return std_logic is
		variable ret : std_logic := '0';
	begin
		for i in tab'range loop
			ret := ret or tab(i);
		end loop;
		return ret;
	end function or_reduce;
	for all: fun_decoder use entity CombinationalTools.decoder(fdd_decoder);
	component fun_decoder 
		generic(dec_size : integer := f'length);
		port(input : in STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0);
			output : out STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0) );
	end component;
	signal f_min : std_logic_vector ((2**f'length)-1 DOWNTO 0);
	signal UALop1_nUALOp0, UALOp1_UALOp0 : std_logic;
begin	
	UALop1_nUALOp0 <= UALOp(1) and (not UALOp(0) );
	UALOp1_UALOp0 <= UALOp(1) and UALOp(0);

	f_dec : fun_decoder port map(input => f, output => f_min);
	Enable_V <= (UALOp1_nUALOp0 and (f_min(32) or f_min(34) or f_min(40) or f_min(42) or f_min(48) or f_min(50) or f_min(58) or f_min(60))
				) or ( UALOp1_UALOp0 and (not op(2)) and (not op(0))
				); 
	Slt_Slti <= ( UALOp1_nUALOp0 and (f_min(10) or f_min(26) or f_min(58) or f_min(58)) 
				) or ( UALOp1_UALOp0 and (not op(2)) and op(1) and (not op(0)) 
				);

	Sel(0) <= 	( UALOp1_nUALOp0	
					and( f_min(0) or f_min(16)  
						or f_min(37) or f_min(53) 
						or f_min(6) or f_min(22) 
						or f_min(10) or f_min(11) or f_min(26) or f_min(27)
					) 
				) or ( UALOp1_UALOp0 and( op(1) or ( op(2) and (not op(1)) and op(0) ) )
				);
	Sel(1) <= 	( 	(not UALOp(1) 
					)or ( UALOp1_nUALOp0 
						and( f_min(0) or f_min(2) or f_min(16) or f_min(18) or f_min(32) or f_min(34) or f_min(48) or f_min(50) 
						  or f_min(4) or f_min(20)
						  or f_min(8) or f_min(24)
						  or f_min(33) or f_min(35) or f_min(49) or f_min(51)
						  or f_min(10) or f_min(11) or f_min(26) or f_min(27)
						) 
					)or ( UALOp1_UALOp0 and not( op(2)) 
					)
				);
	Sel(2) <= 	( UALOp1_nUALOp0 and (f_min(0) or f_min(2) or f_min(16) or f_min(18) 
								  or f_min(6) or f_min(7) or f_min(22) or f_min(23)) 
				) or ( UALOp1_UALOp0 and op(2) and op(1) and (not op(0))
				);

	Sel(3) <=	((not UALOp(1)) and UALOp(0)
				)or( UALOp1_nUALOp0 
					and (f_min(34) or f_min(35) or f_min(50) or f_min(51)
					  or f_min(10) or f_min(11) or f_min(26) or f_min(27)
					)
				)or( UALOp1_UALOp0 and (not op(2)) and op(1)
				);
end architecture;
