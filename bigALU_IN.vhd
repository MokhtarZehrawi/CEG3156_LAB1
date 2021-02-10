LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY bigALU_IN IS
	PORT (
		in_mantissa		 : IN STD_LOGIC_VECTOR(7 downto 0);
		in_sign		 	 : IN STD_LOGIC;
		in_clk, in_en, i_rst_bar : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR(10 downto 0) );
END;

ARCHITECTURE struct OF bigALU_IN IS

SIGNAL int_A, int_N, int_R : STD_LOGIC_VECTOR(10 downto 0);

COMPONENT enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT FullAdder_11bit IS
	PORT(
		in_A, in_B 		 : IN STD_LOGIC_VECTOR(10 downto 0);
		in_C	 	 	 : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR(10 downto 0);
		o_CarryOut, o_Overflow	 : OUT STD_LOGIC );
END COMPONENT;

	--Component Setup

BEGIN
	int_A(7 downto 0) <= in_mantissa;
	int_A(8) <='1';
	int_A(10 downto 9) <="00";

	int_N(0)   <= int_A(0) XOR in_Sign;
	int_N(1)   <= int_A(1) XOR in_Sign;
	int_N(2)   <= int_A(2) XOR in_Sign;
	int_N(3)   <= int_A(3) XOR in_Sign;
	int_N(4)   <= int_A(4) XOR in_Sign;
	int_N(5)   <= int_A(5) XOR in_Sign;
	int_N(6)   <= int_A(6) XOR in_Sign;
	int_N(7)   <= int_A(7) XOR in_Sign;
	int_N(8)   <= int_A(8) XOR in_Sign;
	int_N(9)   <= int_A(9) XOR in_Sign;
	int_N(10)  <= int_A(10)XOR in_Sign;


	Negative_To_Postive: FullAdder_11bit
	PORT MAP(
		in_A => int_N, 
		in_B => "00000000000", 		
		in_C => in_sign,
		o_Result   => int_R,
	 	o_CarryOut => open,	
		o_Overflow => open );

	DFF_0 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(0),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(0),
		o_qBar		=>open);

	DFF_1 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(1),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(1),
		o_qBar		=>open);

	DFF_2 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(2),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(2),
		o_qBar		=>open);

	DFF_3 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(3),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(3),
		o_qBar		=>open);

	DFF_4 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(4),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(4),
		o_qBar		=>open);

	DFF_5 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(5),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(5),
		o_qBar		=>open);

	DFF_6 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(6),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(6),
		o_qBar		=>open);
	
	DFF_7 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(7),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(7),
		o_qBar		=>open);

	DFF_8 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(8),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(8),
		o_qBar		=>open);

	DFF_9 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(9),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(9),
		o_qBar		=>open);

	DFF_10 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_R(10),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>o_Result(10),
		o_qBar		=>open);
		

	--Output Assignment
	
	
END struct;
