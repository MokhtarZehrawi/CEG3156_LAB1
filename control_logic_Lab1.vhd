LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY control_logic_Lab1 IS
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
		
END;

ARCHITECTURE struct OF control_logic_Lab1 IS

	SIGNAL int_CNT_OPsel, int_CNT_en, int_zeroDiff, int_CNT_zero  				: STD_LOGIC; --internal control signals
	SIGNAL int_x, int_y, int_z, int_w, int_sLR_zero, int_normalized, int_overflow		: STD_LOGIC; --control path signals
	SIGNAL int_d1, int_d2, int_d3, int_d4, int_d5, int_d6, int_d7, int_d8, int_d9, int_d10	: STD_LOGIC; --HOT 1 encoding state inputs
	SIGNAL int_c1, int_c2, int_c3, int_c4				: STD_LOGIC;	
	SIGNAL int_c1_in, int_c2_in, int_c3_in, int_c4_in		: STD_LOGIC;
	SIGNAL int_STATES, int_NR	 				: STD_LOGIC_VECTOR(10 downto 0);
	SIGNAL int_sLR 							: STD_LOGIC_VECTOR(10 downto 0);
	SIGNAL int_CNT_out						: STD_LOGIC_VECTOR(6 downto 0);

	
	COMPONENT FullAdder_11bit IS
	PORT(
		in_A, in_B 		 : IN STD_LOGIC_VECTOR(10 downto 0);
		in_C	 	 	 : IN STD_LOGIC;
		o_Result		 : OUT STD_LOGIC_VECTOR(10 downto 0);
		o_CarryOut, o_Overflow	 : OUT STD_LOGIC );
	END COMPONENT;

	COMPONENT enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

	COMPONENT enARdFF_2_Bar IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

	COMPONENT Timer_7bit IS
	PORT (
		in_Time	  			 : IN STD_LOGIC_VECTOR (6 downto 0);
		in_write_dec			 : IN STD_LOGIC;
		in_clk, in_en, in_resetbar	 : IN STD_LOGIC;
		o_Result			 : OUT STD_LOGIC_VECTOR (6 downto 0) );
	END COMPONENT;
BEGIN

	--Signal Assignment
	int_overflow <= in_IncDec_overflow;
	int_zeroDiff <= NOT( (in_Exp_Diff(6) OR in_Exp_Diff(5) OR in_Exp_Diff(4) OR in_Exp_Diff(3) OR in_Exp_Diff(2) OR in_Exp_Diff(1) OR in_Exp_Diff(0) ) );
	int_sLR_zero <= NOT( (int_sLR(10) OR int_sLR(9) OR int_sLR(8) OR int_sLR(7) OR int_sLR(6) OR int_sLR(5) OR int_sLR(4) OR int_sLR(3) OR int_sLR(2) OR int_sLR(1) OR int_sLR(0) ) );
	int_CNT_zero <= NOT( (int_CNT_out(6) OR int_CNT_out(5) OR int_CNT_out(4) OR int_CNT_out(3) OR int_CNT_out(2) OR int_CNT_out(1) OR int_CNT_out(0) ) );
	int_normalized <= int_sLR(8) AND NOT(int_sLR(9)) AND NOT(int_sLR(10)) ;


	int_x <= NOT(int_sLR_zero) AND NOT(int_overflow) AND NOT(int_normalized);
	int_y <= NOT(int_sLR(9)) AND int_sLR(8) AND NOT(int_overflow) AND int_normalized;
	int_z <= NOT(int_sLR_zero) AND NOT(int_overflow) AND int_normalized;
	int_w <= NOT(int_sLR(9)) AND NOT(int_sLR(8));

	int_c1_in <= int_STATES(0);
	int_c2_in <= int_STATES(3);
	int_c3_in <= int_STATES(5) OR int_STATES(6);
	int_c4_in <= int_STATES(7) OR int_STATES(8);

	int_d1 <= int_c1 AND in_Exp_flag AND NOT(int_zeroDiff);
	int_d2 <= int_c1 AND NOT(in_Exp_flag) AND NOT(int_zeroDiff);
	int_d4 <= int_c1 AND int_zeroDiff;
	int_d3 <= int_STATES(1) OR int_STATES(2) OR (int_c2 AND NOT(int_CNT_zero) );
	int_d5 <= int_c2 AND int_CNT_zero;
	int_d6 <= int_STATES(4);
	int_d7 <= (int_sLR(9) AND int_c3) OR ( int_sLR(9) AND int_X AND int_c4 ) ;
	int_d8 <= (int_w AND int_c3 ) OR (int_x AND int_c4 AND int_w );
	int_d9 <= (int_y AND int_c3 ) OR (int_z AND int_c4 );
	int_d10 <= (int_c4 AND int_sLR_zero) OR int_STATES(10) ; 

	int_CNT_OPsel <= int_STATES(1) OR int_STATES(2);
	int_CNT_en    <= int_STATES(1) OR int_STATES(2) OR int_STATES(3);

	int_NR(0) <=in_sLR_out(0) XOR in_sLR_out(10);
	int_NR(1) <=in_sLR_out(1) XOR in_sLR_out(10);
	int_NR(2) <=in_sLR_out(2) XOR in_sLR_out(10);
	int_NR(3) <=in_sLR_out(3) XOR in_sLR_out(10);
	int_NR(4) <=in_sLR_out(4) XOR in_sLR_out(10);
	int_NR(5) <=in_sLR_out(5) XOR in_sLR_out(10);
	int_NR(6) <=in_sLR_out(6) XOR in_sLR_out(10);
	int_NR(7) <=in_sLR_out(7) XOR in_sLR_out(10);
	int_NR(8) <=in_sLR_out(8) XOR in_sLR_out(10);
	int_NR(9) <=in_sLR_out(9) XOR in_sLR_out(10);
	int_NR(10) <=in_sLR_out(10) XOR in_sLR_out(10);

	Negative_To_Postive: FullAdder_11bit
	PORT MAP(
		in_A => int_NR, 
		in_B => "00000000000", 		
		in_C => in_sLR_out(10),
		o_Result   => int_sLR,
	 	o_CarryOut => open,	
		o_Overflow => open );

	CNT : Timer_7bit
	PORT MAP(
		in_Time	  	=>in_Exp_Diff,
		in_write_dec	=>int_CNT_OPsel,
		in_clk		=>in_clk, 
		in_en		=>int_CNT_en, 
		in_resetbar	=>in_resetbar,
		o_Result	=>int_CNT_out );	

	DFF_0 : enARdFF_2_Bar
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>'0',
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(0),
		o_qBar		=>open);

	DFF_1 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d1,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(1),
		o_qBar		=>open);

	DFF_2 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d2,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(2),
		o_qBar		=>open);

	DFF_3 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d3,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(3),
		o_qBar		=>open);

	DFF_4 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d4,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(4),
		o_qBar		=>open);

	DFF_5 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d5,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(5),
		o_qBar		=>open);

	DFF_6 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d6,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(6),
		o_qBar		=>open);

	DFF_7 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d7,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(7),
		o_qBar		=>open);

	DFF_8 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d8,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(8),
		o_qBar		=>open);

	DFF_9 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d9,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(9),
		o_qBar		=>open);

	DFF_10 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_d10,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_STATES(10),
		o_qBar		=>open);

	DFF_c1 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_c1_in,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_c1,
		o_qBar		=>open);

	DFF_c2 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_c2_in,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_c2,
		o_qBar		=>open);

	DFF_c3 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_c3_in,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_c3,
		o_qBar		=>open);

	DFF_c4 : enARdFF_2
	PORT MAP(
		i_resetBar	=>in_resetbar,
		i_d		=>int_c4_in,
		i_enable	=>'1',
		i_clock		=>in_clk,
		o_q		=>int_c4,
		o_qBar		=>open);
	
	--Output Control Signals
	o_write_FP_A 	 <= int_STATES(0);
	o_write_FP_B 	 <= int_STATES(0); 
	o_write_FP_C 	 <= int_STATES(9) OR int_STATES(10);
	o_write_expDiff	 <= int_STATES(0); 
	o_write_ALU_B 	 <= int_STATES(1) OR int_STATES(2) OR int_STATES(4);
	o_FP_C_src	 <= int_STATES(10);
	o_Balu_srcA	 <= int_STATES(2);
	o_Balu_srcB	 <= int_STATES(1) OR int_STATES(4);  
	o_srcExp	 <= int_STATES(5) AND in_Exp_flag ;
	o_SR_en		 <= int_STATES(1) OR int_STATES(2) OR int_STATES(3) OR int_STATES(4);
        o_SR_OPsel	 <= int_STATES(1) OR int_STATES(2) OR int_STATES(4);
	o_IncDec_en	 <= int_STATES(4) OR int_STATES(5) OR int_STATES(7) OR int_STATES(8);   
   	o_sLR_en	 <= int_STATES(5) OR int_STATES(6) OR int_STATES(7) OR int_STATES(8); 
	o_IncDec_OPsel(0)<= int_STATES(4) OR int_STATES(5) OR int_STATES(8);
	o_IncDec_OPsel(1)<= int_STATES(4) OR int_STATES(5);
	o_sLR_OPsel(0) 	 <= int_STATES(5) OR int_STATES(6) OR int_STATES(8);
	o_sLR_OPsel(1)	 <= int_STATES(5) OR int_STATES(6); 

	o_State <=int_STATES;
	o_cond(0) <= int_c1;
	o_cond(1) <= int_c2;
	o_cond(2) <= int_c3;
	o_cond(3) <= int_c4;
END struct;