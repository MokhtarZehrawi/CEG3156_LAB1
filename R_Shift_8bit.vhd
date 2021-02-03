LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

--Function 		: 8 bit register(8 DFFs) with operations write and right shift. 
--Input 		: 8 bit mantissa, an operation(Write/ShiftRight), clk signal, reset, and enable
--Internal Execution	: 
--Output		: outputs 11 bits, where bits(7 to 0) represent the mantissa
--			  bit 8 is the implicit one bit
--			  bit 9 is implicit one bit carry out
--			  bit 10 is the sign bit
--			  
ENTITY R_Shift_8bit IS
	PORT (
		in_Mantissa  		 : IN STD_LOGIC_VECTOR (7 downto 0);
		in_Sign			 : IN STD_LOGIC;
		in_Write_RSbar		 : IN STD_LOGIC;
		in_clk, in_en, i_rst_bar : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR (10 downto 0)	 );
END;

ARCHITECTURE rtl OF R_Shift_8bit IS
	SIGNAL int_A, int_N, int_NR, int_d, int_R : STD_LOGIC_VECTOR(10 downto 0);
	
COMPONENT enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

COMPONENT MUX_2x1 IS
	PORT (
		input : IN STD_LOGIC_VECTOR (1 downto 0);
		sel : IN STD_LOGIC;
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
	--Signal Assigment
	int_A(7 downto 0) <= in_Mantissa;
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

	--Component Setup
	Negative_To_Postive: FullAdder_11bit
	PORT MAP(
		in_A => int_N, 
		in_B => "00000000000", 		
		in_C => in_Sign,
		o_Result   => int_NR,
	 	o_CarryOut => open,	
		o_Overflow => open );

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
	Mux_0 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(1),
		input(1)	=>int_NR(0),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(0) );

	Mux_1 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(2),
		input(1)	=>int_NR(1),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(1) );

	Mux_2 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(3),
		input(1)	=>int_NR(2),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(2) );

	Mux_3 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(4),
		input(1)	=>int_NR(3),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(3) );

	Mux_4 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(5),
		input(1)	=>int_NR(4),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(4) );

	Mux_5 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(6),
		input(1)	=>int_NR(5),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(5) );

	Mux_6 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(7),
		input(1)	=>int_NR(6),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(6) );

	Mux_7 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(8),
		input(1)	=>int_NR(7),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(7) );

	Mux_8 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(9),
		input(1)	=>int_NR(8),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(8) );

	Mux_9 : MUX_2x1
	PORT MAP(
		input(0)	=>int_R(10),
		input(1)	=>int_NR(9),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(9) );

	Mux_10 : MUX_2x1
	PORT MAP(
		input(0)	=>in_Sign,
		input(1)	=>int_NR(10),
		sel 		=>in_Write_RSbar,
		output 		=>int_d(10) );



	--Output
	o_Result <=int_R;
END rtl;