LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EnDFF IS
	PORT (
		d, en, clk, rstBar : IN STD_LOGIC;
		q, qBar : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF EnDFF IS

SIGNAL int_q, int_qBar, int_hold : STD_LOGIC;
SIGNAL int_d, int_dBar, rstD : STD_LOGIC;
SIGNAL int_notD, int_Clk, int_notClk : STD_LOGIC;

COMPONENT EnSRLatch
	PORT (
		set, reset, enable : IN STD_LOGIC;
		q, qBar : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT MUX2x1
	PORT (
		input : IN STD_LOGIC_VECTOR (1 downto 0);
		sel : IN STD_LOGIC;
		output : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN
	-- Component Instantiation

	enable: MUX2x1
	PORT MAP (input(1) => rstD,
		  input(0) => int_hold,
		  sel => en,
		  output => int_d
	);

	masterLatch: EnSRLatch
	PORT MAP (set => int_d,
		  reset => int_notD,
		  enable => int_notClk,
		  q => int_q,
		  qBar => int_qBar
	);

	slaveLatch: EnSRLatch
	PORT MAP (set => int_q,
	 	  reset => int_qBar,
		  enable => int_Clk,
		  q => int_hold,
		  qBar => qBar
	);

	-- Concurrent Signal Assignment
	rstD <= rstBar AND d;
	int_notD <= NOT d;
	q <= int_hold;
	int_Clk <= clk;
	int_notClk <= NOT int_Clk;
END struct;
