LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpAdd_Top IS
	PORT (
		mantissaA, mantissaB, exponentA, exponentB	: IN STD_LOGIC_VECTOR (3 downto 0);
		signA, signB, GClk, GResetbar		 : IN STD_LOGIC; 
		Result		 : OUT STD_LOGIC_VECTOR (15 downto 0);
		Overflow, exception		 : OUT STD_LOGIC );
		
END;

ARCHITECTURE struct OF fpAdd_Top IS



COMPONENT Float_Point_Top IS
	PORT (
		in_FP_A, in_FP_B		 : IN STD_LOGIC_VECTOR (15 downto 0);
		in_g_clk, in_g_resetbar		 : IN STD_LOGIC; 
		o_Result			 : OUT STD_LOGIC_VECTOR (15 downto 0);
		o_Overflow, o_exception		 : OUT STD_LOGIC );
		
END COMPONENT;

BEGIN
	-- Component Instantiation --
	TopL: Float_Point_Top
	PORT MAP (in_FP_A(15) => signA,
		  in_FP_A(14 downto 11) => exponentA,
		  in_FP_A(10 downto 8) => "000",
		  in_FP_A(7 downto 4) => mantissaA,
		  in_FP_A(3 downto 0) => "0000",
		  in_FP_B(15) => signB,
		  in_FP_B(14 downto 11) => exponentB,
		  in_FP_B(10 downto 8) => "000",
		  in_FP_B(7 downto 4) => mantissaB,
		  in_FP_B(3 downto 0) => "0000", 
		  in_g_clk => GClk,
		  in_g_resetbar => GResetbar,
		  o_Result => Result,
		  o_Overflow => Overflow,
		  o_exception => exception
	);

END struct;