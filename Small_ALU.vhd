LIBRARY ieee;
USE ieee.std_logic_1164.ALL;



ENTITY Small_ALU IS
	PORT (
		in_A, in_B 		 : IN STD_LOGIC_VECTOR (6 downto 0);
		in_Sub			 : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR (6 downto 0);
		o_Flag			 : OUT STD_LOGIC	 );
END;

ARCHITECTURE struct OF Small_ALU IS

SIGNAL int_A, int_B, int_SR, int_N, int_NR, int_AR 		: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL int_A_Pass, int_S_Pass 					: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL int_Overflow, int_S_Flag, int_A_Flag, in_Sub_Bar 	: STD_LOGIC;

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
	--Signa Assignment
	in_Sub_Bar <= NOT(in_Sub);

	int_A(6 downto 0) <= in_A;
	int_A(7) <='0';
	int_B(6 downto 0) <= in_B;
	int_B(7) <='0';
	
	int_A_Flag <= int_AR(7);
	int_S_Flag <= int_SR(7);
	int_N(0)   <= int_SR(0) XOR int_S_Flag;
	int_N(1)   <= int_SR(1) XOR int_S_Flag;
	int_N(2)   <= int_SR(2) XOR int_S_Flag;
	int_N(3)   <= int_SR(3) XOR int_S_Flag;
	int_N(4)   <= int_SR(4) XOR int_S_Flag;
	int_N(5)   <= int_SR(5) XOR int_S_Flag;
	int_N(6)   <= int_SR(6) XOR int_S_Flag;
	int_N(7)   <= int_SR(7) XOR int_S_Flag;

	
	int_A_Pass(0) <= int_AR(0) AND in_Sub_Bar;
	int_A_Pass(1) <= int_AR(1) AND in_Sub_Bar;
	int_A_Pass(2) <= int_AR(2) AND in_Sub_Bar;
	int_A_Pass(3) <= int_AR(3) AND in_Sub_Bar;
	int_A_Pass(4) <= int_AR(4) AND in_Sub_Bar;
	int_A_Pass(5) <= int_AR(5) AND in_Sub_Bar;
	int_A_Pass(6) <= int_AR(6) AND in_Sub_Bar;
	int_A_Pass(7) <= int_AR(7) AND in_Sub_Bar;
	
	int_S_Pass(0) <= int_NR(0) AND in_Sub;
	int_S_Pass(1) <= int_NR(1) AND in_Sub;
	int_S_Pass(2) <= int_NR(2) AND in_Sub;
	int_S_Pass(3) <= int_NR(3) AND in_Sub;
	int_S_Pass(4) <= int_NR(4) AND in_Sub;
	int_S_Pass(5) <= int_NR(5) AND in_Sub;
	int_S_Pass(6) <= int_NR(6) AND in_Sub;
	int_S_Pass(7) <= int_NR(7) AND in_Sub;

	--Component Setup
	FA_8bit: FullAdder_8bit
	PORT MAP(
		in_A => int_A, 
		in_B => int_B, 		
		in_C => '0',
		o_Result   => int_AR,
	 	o_CarryOut => open,
		o_Overflow => open );

	Sub_8bit: Subtractor_8bit
	PORT MAP(
		in_A => int_A, 
		in_B => int_B, 		
		o_Result   => int_SR,
		o_Overflow => open );

	Negative_To_Postive: FullAdder_8bit
	PORT MAP(
		in_A => int_N, 
		in_B => "00000000", 		
		in_C => int_S_Flag,
		o_Result   => int_NR,
	 	o_CarryOut => open,
		o_Overflow => open );

	--output assignment
	o_Result 	<= int_S_Pass(6 downto 0) OR int_A_Pass(6 downto 0) ;
	o_Flag    	<= (int_S_Flag AND in_Sub) OR (int_A_Flag AND in_Sub_Bar) ;
END struct;