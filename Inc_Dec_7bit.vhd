LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--Function 		: Increment/Decrement a 7bit unsigned number. 
--Input 		: 7bit unsigned number and an operation(Inc/Dec)
--Internal Execution	: converts 7bit unsigned to 8bit signed then performs given operation
--Output		: always outputs a 7 bit unsigned number and a flag to indicate overflow
--			  (e.g. incrementing max value or decrementing zero) 
ENTITY Inc_Dec_7bit IS
	PORT (
		in_Exp  		 : IN STD_LOGIC_VECTOR (6 downto 0);
		in_Inc_DecBar		 : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR (6 downto 0);
		o_flag_V		 : OUT STD_LOGIC	 );
END;

ARCHITECTURE struct OF Inc_Dec_7bit IS

	SIGNAL int_A, int_SR, int_AR 					: STD_LOGIC_VECTOR (7 downto 0);
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
		o_Result		 : OUT STD_LOGIC_VECTOR(7 downto 0);
		o_Overflow		 : OUT STD_LOGIC	 );
	END COMPONENT;

BEGIN

	--Signa Assignment
	int_A(6 downto 0) <= in_Exp;
	int_A(7) <='0';
	
	int_S_Flag <= int_SR(7);
	int_A_Flag <= int_AR(7);
	
	int_S_Pass(0) <= int_SR(0) AND NOT(in_Inc_DecBar);
	int_S_Pass(1) <= int_SR(1) AND NOT(in_Inc_DecBar);
	int_S_Pass(2) <= int_SR(2) AND NOT(in_Inc_DecBar);
	int_S_Pass(3) <= int_SR(3) AND NOT(in_Inc_DecBar);
	int_S_Pass(4) <= int_SR(4) AND NOT(in_Inc_DecBar);
	int_S_Pass(5) <= int_SR(5) AND NOT(in_Inc_DecBar);
	int_S_Pass(6) <= int_SR(6) AND NOT(in_Inc_DecBar);
	int_S_Pass(7) <= int_SR(7) AND NOT(in_Inc_DecBar);
	
	int_A_Pass(0) <= int_AR(0) AND in_Inc_DecBar;
	int_A_Pass(1) <= int_AR(1) AND in_Inc_DecBar;
	int_A_Pass(2) <= int_AR(2) AND in_Inc_DecBar;
	int_A_Pass(3) <= int_AR(3) AND in_Inc_DecBar;
	int_A_Pass(4) <= int_AR(4) AND in_Inc_DecBar;
	int_A_Pass(5) <= int_AR(5) AND in_Inc_DecBar;
	int_A_Pass(6) <= int_AR(6) AND in_Inc_DecBar;
	int_A_Pass(7) <= int_AR(7) AND in_Inc_DecBar;


	--Component Setup
	FA_8bit: FullAdder_8bit
	PORT MAP(
		in_A => int_A, 
		in_B => "00000001", 		
		in_C => '0',
		o_Result   => int_AR,
	 	o_CarryOut => open,
		o_Overflow => open );

	Sub_8bit: Subtractor_8bit
	PORT MAP(
		in_A => int_A, 
		in_B => "00000001", 		
		o_Result   => int_SR,
		o_Overflow => open );


	--output assignment
	o_Result 	<= int_S_Pass(6 downto 0) OR int_A_Pass(6 downto 0) ;
	o_flag_V    	<= (int_S_Flag AND in_Inc_DecBar) OR (int_A_Flag AND not(in_Inc_DecBar) ) ;

END struct;