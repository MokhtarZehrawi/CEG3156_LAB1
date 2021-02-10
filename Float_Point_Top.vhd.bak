
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Float_Point_Top IS
	PORT (
		in_FP_A, in_FP_B		 : IN STD_LOGIC_VECTOR (15 downto 0);
		in_g_clk, in_g_resetbar		 : IN STD_LOGIC; 
		o_Result			 : OUT STD_LOGIC_VECTOR (15 downto 0);
		o_Overflow, o_exception		 : OUT STD_LOGIC );
		
END;

ARCHITECTURE struct OF Float_Point_Top IS

	SIGNAL  int_FP_A, int_FP_B  						 	 : STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL  int_sALU_out, int_expDIFF_out, int_srcExp_out	 			 : STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL  int_IncDec_out						 		 : STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL  int_IncDec_OPsel, int_sLR_OPsel						 : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL  int_write_FP_A, int_write_FP_B, int_sAlU_flag, int_IncDec_en	 	 : STD_LOGIC;
	SIGNAL  int_write_FP_C, int_IncDec_flagV, int_FP_C_src, int_sR_en_fix		 : STD_LOGIC;
	SIGNAL  int_write_expDIFF, int_expDIFF_flag, int_sR_OPsel, int_sLR_en 		 : STD_LOGIC;	
	SIGNAL  int_Balu_srcA ,int_Balu_srcB, int_srcExp				 : STD_LOGIC;	--MUX sel signals
	SIGNAL  int_sign_srcA_out, int_sign_srcB_out, int_sR_enable, int_write_ALU_B 	 : STD_LOGIC;
	--SIGNAL  								 	 : STD_LOGIC;
	SIGNAL  int_srcA_out ,int_srcB_out					 	 : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL  int_sR_out , int_ALU_B						 	 : STD_LOGIC_VECTOR(10 downto 0); --Big ALU inputs
	SIGNAL  int_sLR_out, int_sLR_out_NR, int_sLR_out_NR_out, int_logic_state	 : STD_LOGIC_VECTOR(10 downto 0);
	SIGNAL  int_bigALU_out, int_FP_C_mux_out				 	 : STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL 	int_logic_cond : STD_LOGIC_VECTOR(3 downto 0);

COMPONENT control_logic_Lab1 IS
	PORT (
		in_Exp_Diff				   : IN STD_LOGIC_VECTOR (6 downto 0);
		in_Exp_flag, in_IncDec_overflow		   : IN STD_LOGIC;
		in_sLR_out				   : IN STD_LOGIC_VECTOR(10 downto 0);
		in_clk, in_resetbar			   : IN STD_LOGIC; 

		o_write_FP_A,    o_write_FP_B,  o_write_FP_C	: OUT STD_LOGIC;
		o_write_expDiff, o_write_ALU_B,	o_FP_C_src   	: OUT STD_LOGIC; 
		o_Balu_srcA,     o_Balu_srcB,   o_srcExp  	: OUT STD_LOGIC; 
		o_SR_en,         o_SR_OPsel,    o_IncDec_en	: OUT STD_LOGIC; 
		o_sLR_en   		 			: OUT STD_LOGIC; 
		o_IncDec_OPsel,  o_sLR_OPsel 		   	: OUT STD_LOGIC_VECTOR(1 downto 0);
		o_State						: OUT STD_LOGIC_VECTOR(10 downto 0); 
		o_cond						: OUT STD_LOGIC_VECTOR(3 downto 0) );	
END COMPONENT;
	

COMPONENT FullAdder_11bit IS
	PORT(
		in_A, in_B 		 : IN STD_LOGIC_VECTOR(10 downto 0);
		in_C	 	 	 : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR(10 downto 0);
		o_CarryOut, o_Overflow	 : OUT STD_LOGIC  );
	END COMPONENT;

COMPONENT Float_point_reg IS
	PORT (
		in_Mantissa			 : IN STD_LOGIC_VECTOR (7 downto 0);
		in_Exp				 : IN STD_LOGIC_VECTOR (6 downto 0);
		in_Sign				 : IN STD_LOGIC;
		in_clk, in_en, in_resetbar	 : IN STD_LOGIC; 
		o_Result			 : OUT STD_LOGIC_VECTOR (15 downto 0) );
END COMPONENT;

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
		input 	: IN STD_LOGIC_VECTOR (1 downto 0);
		sel 	: IN STD_LOGIC;
		output  : OUT STD_LOGIC );
END COMPONENT;

COMPONENT MUX_2x1_7bit IS
	PORT (
		input0, input1  : IN STD_LOGIC_VECTOR (6 downto 0);
		SEL 		: IN STD_LOGIC;
		output 		: OUT STD_LOGIC_VECTOR (6 downto 0) );
END COMPONENT;

COMPONENT MUX_2x1_8bit IS
	PORT (
		input0, input1  : IN STD_LOGIC_VECTOR (7 downto 0);
		SEL 		: IN STD_LOGIC;
		output 		: OUT STD_LOGIC_VECTOR (7 downto 0) );
END COMPONENT;

COMPONENT MUX_2x1_11bit IS
	PORT (
		input0, input1  : IN STD_LOGIC_VECTOR (10 downto 0);
		SEL 		: IN STD_LOGIC;
		output 		: OUT STD_LOGIC_VECTOR (10 downto 0) );
END COMPONENT;

COMPONENT MUX_2x1_16bit IS
	PORT (
		input0, input1  : IN STD_LOGIC_VECTOR (15 downto 0);
		SEL 		: IN STD_LOGIC;
		output 		: OUT STD_LOGIC_VECTOR (15 downto 0) );
END COMPONENT;

COMPONENT Small_ALU IS
	PORT(
		in_A, in_B 		 : IN STD_LOGIC_VECTOR (6 downto 0);
		in_Sub			 : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR (6 downto 0);
		o_Flag			 : OUT STD_LOGIC);
END COMPONENT;

COMPONENT Exp_Diff_Reg IS
	PORT(
		in_Exp				 : IN STD_LOGIC_VECTOR (6 downto 0);
		in_Sign				 : IN STD_LOGIC;
		in_clk, in_en, in_resetbar	 : IN STD_LOGIC; 
		o_Result			 : OUT STD_LOGIC_VECTOR (6 downto 0);
		o_flag				 : OUT STD_LOGIC);
END COMPONENT;

COMPONENT Inc_Dec_7bit IS
	PORT (
		in_Exp  			 : IN STD_LOGIC_VECTOR (6 downto 0);
		in_Inc_Dec_Write		 : IN STD_LOGIC_VECTOR (1 downto 0);
		in_clk, in_en, in_resetbar	 : IN STD_LOGIC;
		o_Result			 : OUT STD_LOGIC_VECTOR (6 downto 0);
		o_flag_V			 : OUT STD_LOGIC	 );
END COMPONENT;

COMPONENT R_Shift_8bit IS
	PORT (
		in_Mantissa  		 : IN STD_LOGIC_VECTOR (7 downto 0);
		in_Sign			 : IN STD_LOGIC;
		in_Write_RSbar		 : IN STD_LOGIC;
		in_clk, in_en, i_rst_bar : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR (10 downto 0)	 );
END COMPONENT;


COMPONENT LR_Shift_11bit IS
	PORT (
		in_Mantissa  		 : IN STD_LOGIC_VECTOR (10 downto 0);
		in_shift_R_L_W		 : IN STD_LOGIC_VECTOR(1 downto 0);
		in_clk, in_en, i_rst_bar : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR (10 downto 0) );	
END COMPONENT;


COMPONENT bigALU_IN IS
	PORT (
		in_mantissa		 : IN STD_LOGIC_VECTOR(7 downto 0);
		in_sign		 	 : IN STD_LOGIC;
		in_clk, in_en, i_rst_bar : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR(10 downto 0)  );
END COMPONENT;

COMPONENT bigALU IS
	PORT (
		A, B 	: IN STD_LOGIC_VECTOR (15 downto 0);
		Op   	: IN STD_LOGIC;
		Result  : OUT STD_LOGIC_VECTOR (15 downto 0) );
END COMPONENT;

BEGIN
	--Signal setup
	int_sLR_out_NR(0) <= int_sLR_out(0) XOR int_sLR_out(10);
	int_sLR_out_NR(1) <= int_sLR_out(1) XOR int_sLR_out(10);
	int_sLR_out_NR(2) <= int_sLR_out(2) XOR int_sLR_out(10);
	int_sLR_out_NR(3) <= int_sLR_out(3) XOR int_sLR_out(10);
	int_sLR_out_NR(4) <= int_sLR_out(4) XOR int_sLR_out(10);
	int_sLR_out_NR(5) <= int_sLR_out(5) XOR int_sLR_out(10);
	int_sLR_out_NR(6) <= int_sLR_out(6) XOR int_sLR_out(10);
	int_sLR_out_NR(7) <= int_sLR_out(7) XOR int_sLR_out(10);
	int_sLR_out_NR(8) <= int_sLR_out(8) XOR int_sLR_out(10);
	int_sLR_out_NR(9) <= int_sLR_out(9) XOR int_sLR_out(10);
	int_sLR_out_NR(10) <= int_sLR_out(10) XOR int_sLR_out(10);

	int_sR_en_fix <= int_sR_enable AND (int_logic_state(2) OR int_logic_state(1) OR int_logic_state(3) OR int_logic_state(4) );

	--Component Setup
	ControlLogic : control_logic_Lab1 
	PORT MAP(
		in_Exp_Diff		=>int_expDIFF_out,
		in_Exp_flag		=>int_expDIFF_flag, 
		in_IncDec_overflow	=>int_IncDec_flagV,
		in_sLR_out		=>int_sLR_out,
		in_clk			=>in_g_clk,
		in_resetbar		=>in_g_resetbar,		

		o_write_FP_A 		=>int_write_FP_A,
		o_write_FP_B 		=>int_write_FP_B,
		o_write_FP_C 		=>int_write_FP_C,
		o_write_expDiff		=>int_write_expDIFF,
		o_write_ALU_B		=>int_write_ALU_B,	
		o_FP_C_src		=>int_FP_C_src, 
		o_Balu_srcA		=>int_Balu_srcA,
     		o_Balu_srcB		=>int_Balu_srcB,   
		o_srcExp		=>int_srcExp,  	
		o_SR_en			=>int_sR_enable,         
		o_SR_OPsel		=>int_sR_OPsel,    
		o_IncDec_en		=>int_IncDec_en, 
		o_sLR_en 		=>int_sLR_en, 
		o_IncDec_OPsel		=>int_IncDec_OPsel,  
		o_sLR_OPsel 		=>int_sLR_OPsel,
		o_State			=>int_logic_state,
		o_cond			=>int_logic_cond );	




	
	FP_A : Float_point_reg
	PORT MAP(
		in_Mantissa		=>in_FP_A(7 downto 0),
		in_Exp			=>in_FP_A(14 downto 8),
		in_Sign			=>in_FP_A(15),
		in_clk			=>in_g_clk, 
		in_en			=>int_write_FP_A, 
		in_resetbar	 	=>in_g_resetbar,
		o_Result		=>int_FP_A );

	FP_B : Float_point_reg
	PORT MAP(
		in_Mantissa		=>in_FP_B(7 downto 0),
		in_Exp			=>in_FP_B(14 downto 8),
		in_Sign			=>in_FP_B(15),
		in_clk			=>in_g_clk, 
		in_en			=>int_write_FP_B, 
		in_resetbar	 	=>in_g_resetbar,
		o_Result		=>int_FP_B );

	FP_C : Float_point_reg
	PORT MAP(
		in_Mantissa		=>int_FP_C_mux_out(7 downto 0),
		in_Exp			=>int_FP_C_mux_out(14 downto 8),
		in_Sign			=>int_FP_C_mux_out(15),
		in_clk			=>in_g_clk, 
		in_en			=>int_write_FP_C, 
		in_resetbar	 	=>in_g_resetbar,
		o_Result		=>o_Result );


	aluSmall : Small_ALU
	PORT MAP(
		in_A		=>in_FP_A(14 downto 8), 
		in_B		=>in_FP_B(14 downto 8),
		in_Sub  	=>'1',
		o_Result	=>int_sALU_out,
		o_Flag		=>int_sAlU_flag	);
	
	
	expDiff : Exp_Diff_Reg
	PORT MAP(
		in_Exp				=> int_sALU_out,
		in_Sign				=> int_sAlU_flag,
		in_clk				=> in_g_clk, 
		in_en				=> int_write_expDIFF,
		in_resetbar			=> in_g_resetbar,	 
		o_Result			=> int_expDIFF_out,
		o_flag				=> int_expDIFF_flag);

	Sign_srcA: MUX_2x1
	PORT MAP (
		  input(0) => in_FP_A(15),
		  input(1) => in_FP_B(15),
		  sel => int_Balu_srcA,
		  output => int_sign_srcA_out );

	Balu_srcA: MUX_2x1_8bit
	PORT MAP (
		  input0 => in_FP_A(7 downto 0),
		  input1 => in_FP_B(7 downto 0),
		  sel 	 => int_Balu_srcA,
		  output => int_srcA_out  );

	Sign_srcB: MUX_2x1
	PORT MAP (		
		  input(0) => in_FP_A(15),
		  input(1) => in_FP_B(15),
		  sel => int_Balu_srcB,
		  output => int_sign_srcB_out );

	Balu_srcB: MUX_2x1_8bit
	PORT MAP (
		  input0 => in_FP_A(7 downto 0),
		  input1 => in_FP_B(7 downto 0),
		  sel	 => int_Balu_srcB,
		  output => int_srcB_out );

	Exp_sel: MUX_2x1_7bit
	PORT MAP (
		  input0 => in_FP_A(14 downto 8),
		  input1 => in_FP_B(14 downto 8),
		  sel	 => int_srcExp,
		  output => int_srcExp_out );

	FP_C_mux: MUX_2x1_16bit
	PORT MAP (
		  input0(7 downto 0) 	=> int_sLR_out_NR_out(7 downto 0),
		  input0(14 downto 8)	=> int_IncDec_out, 
		  input0(15)		=> int_sLR_out(10),	
		  input1 		=> "0000000000000000",
		  sel	 		=> int_FP_C_src,
		  output 		=> int_FP_C_mux_out );


	sR_Block : R_Shift_8bit
	PORT MAP(
		in_Mantissa  		 =>int_srcA_out,
		in_Sign			 =>int_sign_srcA_out,
		in_Write_RSbar		 =>int_sR_OPsel,
		in_clk			 =>in_g_clk,
		in_en			 =>int_sR_en_fix,
		i_rst_bar		 =>in_g_resetbar,
		o_Result		 =>int_sR_out );

	sLR_Block : LR_Shift_11bit
	PORT MAP(
		in_Mantissa  		 => int_bigALU_out(10 downto 0),
		in_shift_R_L_W		 => int_sLR_OPsel,
		in_clk			 => in_g_clk,
		in_en			 => int_sLR_en, 
		i_rst_bar 		 => in_g_resetbar,
		o_Result		 => int_sLR_out);


	bigALU_B_in : bigALU_IN
	PORT MAP(
		in_mantissa		 => int_srcB_out,
		in_sign		 	 => int_sign_srcB_out,
		in_clk			 => in_g_clk,
		in_en			 => int_write_ALU_B,
		i_rst_bar 		 => in_g_resetbar,
		o_Result		 => int_ALU_B );
	
	big_ALU : bigALU
	PORT MAP(
		A(10 downto 0)	=>int_sR_out,
		A(15 downto 11) =>"00000", 
		B(10 downto 0)	=>int_ALU_B,
		B(15 downto 11) =>"00000",
		Op   	=>'0',
		Result  => int_bigALU_out );
	
	IncDec : Inc_Dec_7bit
	PORT MAP(
		in_Exp			=> int_srcExp_out,
		in_Inc_Dec_Write	=> int_IncDec_OPsel,
		in_clk			=> in_g_clk, 
		in_en			=> int_IncDec_en, 
		in_resetbar	 	=> in_g_resetbar, 
		o_Result		=> int_IncDec_out,
		o_flag_V		=> int_IncDec_flagV );
	
	NegativeToPositve : FullAdder_11bit
	PORT MAP(
		in_A		=> int_sLR_out_NR, 
		in_B		=> "00000000000", 		
		in_C		=> int_sLR_out(10),
		o_Result	=> int_sLR_out_NR_out,
		o_CarryOut	=> open,
		o_Overflow	=> open);   
	

	--output assignment
	

END struct;
