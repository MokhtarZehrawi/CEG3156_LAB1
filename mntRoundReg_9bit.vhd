LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mntRoundReg_9bit IS
	PORT (
		D : IN STD_LOGIC_VECTOR (8 downto 0);
		Clk, Rst, En : IN STD_LOGIC;
		Q, QBar : OUT STD_LOGIC_VECTOR (8 downto 0)
	);
END;

ARCHITECTURE struct OF mntRoundReg_9bit IS

COMPONENT EnDFF IS
	PORT (
		d, en, clk, rstBar : IN STD_LOGIC;
		q, qBar : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN
	-- Component Instantiation --
	MSB: EnDFF
	PORT MAP (d => D(8),
		  en => En,
		  clk => Clk,
		  rstBar => Rst,
		  q => Q(8),
	  	  qBar => QBar(8)
	);

	Bit7: EnDFF
	PORT MAP (d => D(7),
		  en => En,
		  clk => Clk,
		  rstBar => Rst,
		  q => Q(7),
	  	  qBar => QBar(7)
	);

	Bit6: EnDFF
	PORT MAP (d => D(6),
		  en => En,
		  clk => Clk,
		  rstBar => Rst,
		  q => Q(6),
	  	  qBar => QBar(6)
	);

	Bit5: EnDFF
	PORT MAP (d => D(5),
		  en => En,
		  clk => Clk,
		  rstBar => Rst,
		  q => Q(5),
	  	  qBar => QBar(5)
	);

	Bit4: EnDFF
	PORT MAP (d => D(4),
		  en => En,
		  clk => Clk,
		  rstBar => Rst,
		  q => Q(4),
	  	  qBar => QBar(4)
	);

	Bit3: EnDFF
	PORT MAP (d => D(3),
		  en => En,
		  clk => Clk,
		  rstBar => Rst,
		  q => Q(3),
	  	  qBar => QBar(3)
	);	

	Bit2: EnDFF
	PORT MAP (d => D(2),
		  en => En,
		  clk => Clk,
		  rstBar => Rst,
		  q => Q(2),
	  	  qBar => QBar(2)
	);

	Bit1: EnDFF
	PORT MAP (d => D(1),
		  en => En,
		  clk => Clk,
		  rstBar => Rst,
		  q => Q(1),
	  	  qBar => QBar(1)
	);

	Bit0: EnDFF
	PORT MAP (d => D(0),
		  en => En,
		  clk => Clk,
		  rstBar => Rst,
		  q => Q(0),
	  	  qBar => QBar(0)
	);

END struct;