LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--Function 		: 11 bit register(11 DFFs) with operations write, right shift and left shift. 
--Input 		: 11 bit signed mantissa from big ALU, an operation(Write/ShiftRight/ShiftLeft),
--			  clk signal, reset, and enable.
--Internal Execution	: in_shift_R_L_W = 00 => arithemtic Shift right
--			  in_shift_R_L_W = 01 => arithmetic Shift left	
--			  in_shift_R_L_W = 1X => write register
--Output		: outputs 11 bits, where bits(7 to 0) represent the mantissa
--			  bit 8 is the implicit one bit
--			  bit 9 is implicit one bit carry out
--			  bit 10 is the sign bit
--			  
ENTITY LR_Shift_11bit IS
	PORT (
		in_Mantissa  		 : IN STD_LOGIC_VECTOR (10 downto 0);
		in_shift_R_L_W		 : IN STD_LOGIC_VECTOR(1 downto 0);
		in_clk, in_en, i_rst_bar : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR (10 downto 0)	 );
END;

ARCHITECTURE rtl OF LR_Shift_11bit IS
	SIGNAL int_d, int_R 	: STD_LOGIC_VECTOR(10 downto 0);
	SIGNAL int_muxSel	: STD_LOGIC_VECTOR(1 downto 0);
	
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

COMPONENT FullAdder_11bit IS
	PORT(
		in_A, in_B 		 : IN STD_LOGIC_VECTOR(10 downto 0);
		in_C	 	 	 : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR(10 downto 0);
		o_CarryOut, o_Overflow	 : OUT STD_LOGIC );
END COMPONENT;
	
BEGIN

	--Creating flipflops
	DFF_0 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(0),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(0),
		o_qBar		=>open);

	DFF_1 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(1),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(1),
		o_qBar		=>open);

	DFF_2 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(2),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(2),
		o_qBar		=>open);

	DFF_3 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(3),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(3),
		o_qBar		=>open);

	DFF_4 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(4),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(4),
		o_qBar		=>open);

	DFF_5 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(5),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(5),
		o_qBar		=>open);

	DFF_6 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(6),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(6),
		o_qBar		=>open);
	
	DFF_7 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(7),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(7),
		o_qBar		=>open);

	DFF_8 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(8),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(8),
		o_qBar		=>open);

	DFF_9 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(9),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(9),
		o_qBar		=>open);

	DFF_10 : enARdFF_2
	PORT MAP(
		i_resetBar	=>i_rst_bar,
		i_d		=>int_d(10),
		i_enable	=>in_en,
		i_clock		=>in_clk,
		o_q		=>int_R(10),
		o_qBar		=>open);

	--Creating muxes
	Mux_0 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(1),
		input(1)	=>'0',
		input(2)	=>in_Mantissa(0),
		input(3)	=>in_Mantissa(0),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(0) );

	Mux_1 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(2),
		input(1)	=>int_R(0),
		input(2)	=>in_Mantissa(1),
		input(3)	=>in_Mantissa(1),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(1) );

	Mux_2 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(3),
		input(1)	=>int_R(1),
		input(2)	=>in_Mantissa(2),
		input(3)	=>in_Mantissa(2),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(2) );

	Mux_3 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(4),
		input(1)	=>int_R(2),
		input(2)	=>in_Mantissa(3),
		input(3)	=>in_Mantissa(3),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(3) );

	Mux_4 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(5),
		input(1)	=>int_R(3),
		input(2)	=>in_Mantissa(4),
		input(3)	=>in_Mantissa(4),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(4) );

	Mux_5 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(6),
		input(1)	=>int_R(4),
		input(2)	=>in_Mantissa(5),
		input(3)	=>in_Mantissa(5),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(5) );

	Mux_6 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(7),
		input(1)	=>int_R(5),
		input(2)	=>in_Mantissa(6),
		input(3)	=>in_Mantissa(6),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(6) );

	Mux_7 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(8),
		input(1)	=>int_R(6),
		input(2)	=>in_Mantissa(7),
		input(3)	=>in_Mantissa(7),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(7) );

	Mux_8 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(9),
		input(1)	=>int_R(7),
		input(2)	=>in_Mantissa(8),
		input(3)	=>in_Mantissa(8),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(8) );

	Mux_9 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(10),
		input(1)	=>int_R(8),
		input(2)	=>in_Mantissa(9),
		input(3)	=>in_Mantissa(9),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(9) );

	Mux_10 : MUX_4x1
	PORT MAP(
		input(0)	=>int_R(10),
		input(1)	=>int_R(9),
		input(2)	=>in_Mantissa(10),
		input(3)	=>in_Mantissa(10),
		sel 		=>in_shift_R_L_W,
		output 		=>int_d(10) );

	--Output
	o_Result <=int_R;
END rtl;
