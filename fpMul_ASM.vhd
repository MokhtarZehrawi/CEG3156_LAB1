LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpMul_ASM IS
	PORT (
		MUL, mntB_Z, lsbB, mntRnd_NORM, mntRes_NORM, norm9, norm8, Kz : IN STD_LOGIC;
		CLK, RST : IN STD_LOGIC;
		expRes_EN, mntRes_EN, mntRnd_EN, expOut_EN, mntOut_EN, sgnOut_EN, ovrFlow_EN : OUT STD_LOGIC;
		expOp, mntA_SEL, mntB_SEL, expMUL_SEL, mntRnd_SEL, expA_SEL, expB_SEL : OUT STD_LOGIC;
		ovrFlow, expInc, expDec, mntA_SL, mntB_SR, mntNorm_SR, mntNorm_SL : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF fpMul_ASM IS

SIGNAL int_S : STD_LOGIC_VECTOR (9 downto 0);
SIGNAL int_D : STD_LOGIC_VECTOR (9 downto 0);

COMPONENT EnDFF IS
	PORT (
		d, en, clk, rstBar : IN STD_LOGIC;
		q, qBar : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN
	-- Input Equations --
	int_D(0) <= MUL;
	int_D(1) <= int_S(0);
	int_D(2) <= (NOT int_D(3)) AND (NOT mntB_Z) AND lsbB AND int_S(1);
	int_D(3) <= (NOT int_S(4)) AND int_S(1) AND ((NOT lsbB) OR int_S(2));
	int_D(4) <= mntB_Z AND int_S(0) AND int_S(1);
	int_D(5) <= (NOT int_S(9)) AND mntRes_NORM AND int_S(4);
	int_D(6) <= mntRnd_NORM AND int_S(5);
	int_D(7) <= int_S(4) AND (NOT mntRes_NORM) AND (NOT norm9) AND (NOT norm8) AND (NOT Kz);
	int_D(8) <= int_S(4) AND (NOT mntRes_NORM) AND (norm9 OR norm8 OR Kz);
	int_D(9) <= (NOT mntRnd_NORM) AND int_S(5);

	-- Component Instantiation --
	DFF0: EnDFF
	PORT MAP (d => int_D(0),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(0),
		  qBar => OPEN
	);

	DFF1: EnDFF
	PORT MAP (d => int_D(1),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(1),
		  qBar => OPEN
	);

	DFF2: EnDFF
	PORT MAP (d => int_D(2),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(2),
		  qBar => OPEN
	);

	DFF3: EnDFF
	PORT MAP (d => int_D(3),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(3),
		  qBar => OPEN
	);

	DFF4: EnDFF
	PORT MAP (d => int_D(4),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(4),
		  qBar => OPEN
	);

	DFF5: EnDFF
	PORT MAP (d => int_D(5),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(5),
		  qBar => OPEN
	);

	DFF6: EnDFF
	PORT MAP (d => int_D(6),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(6),
		  qBar => OPEN
	);

	DFF7: EnDFF
	PORT MAP (d => int_D(7),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(7),
		  qBar => OPEN
	);

	DFF8: EnDFF
	PORT MAP (d => int_D(8),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(8),
		  qBar => OPEN
	);

	DFF9: EnDFF
	PORT MAP (d => int_D(9),
		  en => '1',
		  clk => CLK,
		  rstBar => RST,
		  q => int_S(9),
		  qBar => OPEN
	);

	-- Output Equations --
	expRes_EN <= (NOT int_S(4)) AND (int_S(0) OR int_S(1)) AND (NOT (int_S(2) OR int_S(3)));
	expOp <= int_S(0) AND int_S(1);
	expA_SEL <= int_S(0) XOR int_S(1);
	expB_SEL <= int_S(0) XOR int_S(1);
	mntRes_EN <= (NOT int_S(3)) AND int_S(2);
	mntA_SEL <= (NOT int_S(3)) AND int_S(2);
	mntB_SEL <= '0';
	mntA_SL <= int_S(3);
	mntB_SR <= int_S(3);
	mntNorm_SL <= int_S(7);
	mntNorm_SR <= int_S(8);
	mntRnd_SEL <= int_S(9);
	expMul_SEL <= int_S(4);
	mntRnd_EN <= (NOT int_S(6)) AND int_S(5);
	ovrFlow_EN <= (NOT mntRes_NORM);
	ovrFlow <= int_S(8);
	expInc <= int_S(8);
	expDec <= int_S(7);
	expOut_EN <= int_S(6);
	mntOut_EN <= int_S(6);
	sgnOut_EN <= int_S(6);
	mntRnd_SEL <= int_S(9);
	
END struct;