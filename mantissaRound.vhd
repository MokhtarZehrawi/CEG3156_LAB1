LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-------------------------------------------------
-- Name: mantissaRound
-- Input: 12-bit output of Normalized mantissa
-- Function: Depending on last 3 bits we round
--	     the mantissa up or truncate it
-------------------------------------------------

ENTITY mantissaRound IS
	PORT (
		mntNorm : IN STD_LOGIC_VECTOR (7 downto 0);
		grsIn : IN STD_LOGIC_VECTOR (2 downto 0);
		Load, Rst, Clk : IN STD_LOGIC;
		mntRound : OUT STD_LOGIC_VECTOR (8 downto 0);
		grsOut : OUT STD_LOGIC_VECTOR (2 downto 0);
		mntRnd_NORM : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF mantissaRound IS

COMPONENT roundAdder_8bit IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (7 downto 0);
		Cin : IN STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR (7 downto 0);
		Cout : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT mntRoundReg_9bit IS
	PORT (
		D : IN STD_LOGIC_VECTOR (8 downto 0);
		Clk, Rst, En : IN STD_LOGIC;
		Q, QBar : OUT STD_LOGIC_VECTOR (8 downto 0)
	);
END COMPONENT;

SIGNAL int_B : STD_LOGIC_VECTOR (7 downto 0);
SIGNAL int_mntRound : STD_LOGIC_VECTOR (8 downto 0);
SIGNAL int_roundUp : STD_LOGIC;

BEGIN

	int_roundUp <= grsIn(2) AND (grsIn(1) OR grsIn(0));

	int_B(7) <= '0';
	int_B(6) <= '0';
	int_B(5) <= '0';
	int_B(4) <= '0';
	int_B(3) <= '0';
	int_B(2) <= '0';
	int_B(1) <= '0';
	int_B(0) <= int_roundUp;

	-- Component Instantiation --
	INC: roundAdder_8bit
	PORT MAP (A => mntNorm,
		  B => int_B,
		  Cin => '0',
		  S => int_mntRound(7 downto 0),
		  Cout => int_mntRound(8)
	);
	
	Round: mntRoundReg_9bit
	PORT MAP (D => int_mntRound,
		  Clk => Clk,
		  Rst => Rst,
		  En => Load,
		  Q => mntRound,
		  QBar => OPEN
	);

	grsOut <= grsIn;
	mntRnd_NORM <= (NOT int_mntRound(8));
		  
END struct;

	
