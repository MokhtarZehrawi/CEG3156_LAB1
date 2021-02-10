LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--Function 		: Increment/Decrement a 7bit unsigned number. 
--Input 		: 7bit unsigned number and an operation(Inc/Dec/Write)
--Internal Execution	: converts 7bit unsigned to 8bit signed then performs given operation
--		   OP = in_Inc_Dec_Write
--		   if(OP=1X) : write 
--		   if(OP=00) : increment 	
--		   if(OP=01) : decrement  
--Output		: always outputs a 7 bit unsigned number and a flag to indicate overflow
--			  (e.g. incrementing max value or decrementing zero) 
ENTITY Inc_Dec_7bit IS
	PORT (
		in_Exp  			 : IN STD_LOGIC_VECTOR (6 downto 0);
		in_Inc_Dec_Write		 : IN STD_LOGIC_VECTOR (1 downto 0);
		in_clk, in_en, in_resetbar	 : IN STD_LOGIC;
		o_Result			 : OUT STD_LOGIC_VECTOR (6 downto 0);
		o_flag_V			 : OUT STD_LOGIC	 );
END;

ARCHITECTURE struct OF Inc_Dec_7bit IS

	SIGNAL int_A, int_SR, int_AR, int_d, int_R	: STD_LOGIC_VECTOR (7 downto 0);
	
	-- Component Declarations

	COMPONENT enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;


	COMPONENT MUX_4x1 IS
	PORT (
		input : IN STD_LOGIC_VECTOR (3 downto 0);
		sel : IN STD_LOGIC_VECTOR (1 downto 0);
		output : OUT STD_LOGIC );

	END COMPONENT;

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
	--Signal Assigment
	int_A(6 downto 0) <= in_Exp;
	int_A(7) <='0';

	--Component Setup
	FA_8bit: FullAdder_8bit
	PORT MAP(
		in_A => int_R, 
		in_B => "00000001", 		
		in_C => '0',
		o_Result   => int_AR,
	 	o_CarryOut => open,
		o_Overflow => open );

	Sub_8bit: Subtractor_8bit
	PORT MAP(
		in_A => int_R, 
		in_B => "00000001", 		
		o_Result   => int_SR,
		o_Overflow => open );


	Mux_0 : MUX_4x1
	PORT MAP(
		input(0)	=>int_AR(0),
		input(1)	=>int_SR(0),
		input(2)	=>int_A(0),
		input(3)	=>int_A(0),
		sel 		=>in_Inc_Dec_Write,
		output 		=>int_d(0) );

	Mux_1 : MUX_4x1
	PORT MAP(
		input(0)	=>int_AR(1),
		input(1)	=>int_SR(1),
		input(2)	=>int_A(1),
		input(3)	=>int_A(1),
		sel 		=>in_Inc_Dec_Write,
		output 		=>int_d(1) );
	
	Mux_2 : MUX_4x1
	PORT MAP(
		input(0)	=>int_AR(2),
		input(1)	=>int_SR(2),
		input(2)	=>int_A(2),
		input(3)	=>int_A(2),
		sel 		=>in_Inc_Dec_Write,
		output 		=>int_d(2) );
	
	Mux_3 : MUX_4x1
	PORT MAP(
		input(0)	=>int_AR(3),
		input(1)	=>int_SR(3),
		input(2)	=>int_A(3),
		input(3)	=>int_A(3),
		sel 		=>in_Inc_Dec_Write,
		output 		=>int_d(3) );

	Mux_4 : MUX_4x1
	PORT MAP(
		input(0)	=>int_AR(4),
		input(1)	=>int_SR(4),
		input(2)	=>int_A(4),
		input(3)	=>int_A(4),
		sel 		=>in_Inc_Dec_Write,
		output 		=>int_d(4) );

	Mux_5 : MUX_4x1
	PORT MAP(
		input(0)	=>int_AR(5),
		input(1)	=>int_SR(5),
		input(2)	=>int_A(5),
		input(3)	=>int_A(5),
		sel 		=>in_Inc_Dec_Write,
		output 		=>int_d(5) );

	Mux_6 : MUX_4x1
	PORT MAP(
		input(0)	=>int_AR(6),
		input(1)	=>int_SR(6),
		input(2)	=>int_A(6),
		input(3)	=>int_A(6),
		sel 		=>in_Inc_Dec_Write,
		output 		=>int_d(6) );

	Mux_7 : MUX_4x1
	PORT MAP(	
		input(0)	=>int_AR(7),
		input(1)	=>int_SR(7),
		input(2)	=>int_A(7),
		input(3)	=>int_A(7),
		sel 		=>in_Inc_Dec_Write,
		output 		=>int_d(7) );


	DFF_0 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d(0),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(0),
		o_qBar		=>open);

	DFF_1 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d(1),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(1),
		o_qBar		=>open);

	DFF_2 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d(2),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(2),
		o_qBar		=>open);

	DFF_3 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d(3),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(3),
		o_qBar		=>open);

	DFF_4 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d(4),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(4),
		o_qBar		=>open);

	DFF_5 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d(5),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(5),
		o_qBar		=>open);

	DFF_6 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d(6),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(6),
		o_qBar		=>open);
	
	DFF_7 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d(7),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(7),
		o_qBar		=>open);
	

	--output assignment
	o_Result 	<= int_R(6 downto 0);
	o_flag_V    	<= int_R(7);

END struct;