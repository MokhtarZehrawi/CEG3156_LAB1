LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EnSRLatch IS
	PORT (
		set, reset, enable : IN STD_LOGIC;
		q, qBar : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF EnSRLatch IS
SIGNAL int_q, int_qBar, int_set, int_reset : STD_LOGIC;
BEGIN
	int_set <= set NAND enable;
	int_reset <= enable NAND reset;
	int_q <= int_set NAND int_qBar;
	int_qBar <= int_q NAND int_reset;

	q <= int_q;
	qBar <= int_qBar;
END struct;