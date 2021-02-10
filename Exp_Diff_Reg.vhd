
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Exp_Diff_Reg IS
	PORT (
		in_Exp				 : IN STD_LOGIC_VECTOR (6 downto 0);
		in_Sign				 : IN STD_LOGIC;
		in_clk, in_en, in_resetbar	 : IN STD_LOGIC; 
		o_Result			 : OUT STD_LOGIC_VECTOR (6 downto 0);
		o_flag				 : OUT STD_LOGIC);
END;

ARCHITECTURE struct OF Exp_Diff_Reg IS

	SIGNAL  int_R 		: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL  int_SR		: STD_LOGIC;
	
COMPONENT enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

	
BEGIN


	--Component Setup
	DFF_0 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>in_Exp(0),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(0),
		o_qBar		=>open);

	DFF_1 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>in_Exp(1),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(1),
		o_qBar		=>open);

	DFF_2 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>in_Exp(2),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(2),
		o_qBar		=>open);

	DFF_3 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>in_Exp(3),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(3),
		o_qBar		=>open);

	DFF_4 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>in_Exp(4),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(4),
		o_qBar		=>open);

	DFF_5 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>in_Exp(5),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(5),
		o_qBar		=>open);

	DFF_6 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>in_Exp(6),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(6),
		o_qBar		=>open);
	
	DFF_7 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>in_Sign,
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_SR,
		o_qBar		=>open);


	--output assignment
	o_Result 	<= int_R;
	o_flag		<= int_SR;

END struct;
