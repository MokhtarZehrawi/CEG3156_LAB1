LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Small_ALU IS
	PORT (
		in_A, in_B 		 : IN STD_LOGIC_VECTOR (6 downto 0);
		o_Result		 : OUT STD_LOGIC_VECTOR (6 downto 0);
		o_Flag			 : OUT STD_LOGIC	 );
END;

ARCHITECTURE struct OF Small_ALU IS

SIGNAL int_A, int_B, int_R, int_N, int_NR : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL int_Overflow, int_Flag : STD_LOGIC;

	-- Component Declarations
COMPONENT FullAdder_8bit IS
	PORT(
		in_A, in_B 		 : IN STD_LOGIC_VECTOR(7 downto 0);
		in_C	 	 	 : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR(7 downto 0);
		o_CarryOut, o_Overflow	 : OUT STD_LOGIC  );
END COMPONENT;

COMPONENT Subtractor_8bit IS
	PORT (
		in_A, in_B 		 : IN STD_LOGIC_VECTOR (7 downto 0);
		o_Result		 : OUT STD_LOGIC_VECTOR (7 downto 0);
		o_Overflow		 : OUT STD_LOGIC	 );
END COMPONENT;

BEGIN

	int_A(6 downto 0) <= in_A;
	int_A(7) <='0';
	int_B(6 downto 0) <= in_B;
	int_B(7) <='0';

	int_Flag <= int_R(7);
	int_N(0) <= int_R(0) XOR int_Flag;
	int_N(1) <= int_R(1) XOR int_Flag;
	int_N(2) <= int_R(2) XOR int_Flag;
	int_N(3) <= int_R(3) XOR int_Flag;
	int_N(4) <= int_R(4) XOR int_Flag;
	int_N(5) <= int_R(5) XOR int_Flag;
	int_N(6) <= int_R(6) XOR int_Flag;
	int_N(7) <= int_R(7) XOR int_Flag;
	
	Sub_8bit: Subtractor_8bit
	PORT MAP(
		in_A => int_A, 
		in_B => int_B, 		
		o_Result   => int_R,
		o_Overflow => open );

	FA_8bit: FullAdder_8bit
	PORT MAP(
		in_A => int_N, 
		in_B => "00000000", 		
		in_C => int_Flag,
		o_Result   => int_NR,
	 	o_CarryOut => open,
		o_Overflow => open );
	--output assignment
	o_Result 	<= int_NR(6 downto 0);
	o_Flag    	<= int_Flag;
END struct;