LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY adder IS
	GENERIC ( word_size : INTEGER :=32 );
	PORT(
		op_0 : IN STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
		op_1 : IN STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
		sum : OUT STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
		C : OUT STD_LOGIC
	);
END ENTITY adder;

ARCHITECTURE fdd_adder OF adder is
	signal res_xor1, res_xor2, carry_and1, carry_and2, carry_or : std_logic_vector(word_size-1 DOWNTO 0);
BEGIN
	res_xor1 <= op_0 xor op_1;
	carry_and1 <= op_0 and op_1;
	carry_and2(0) <= res_xor1(0);
	res_xor2(0) <= res_xor1(0);
	carry_or <= carry_and2 or carry_and1;
	adder_iter : for ii in 1 to word_size-1 generate
		carry_and2(ii) <= res_xor1(ii) and carry_or(ii-1); 
		res_xor2(ii) <= res_xor1(ii) xor carry_or(ii-1);
	end generate adder_iter;
	sum <= res_xor2;
    C <= carry_or(31);
END ARCHITECTURE;