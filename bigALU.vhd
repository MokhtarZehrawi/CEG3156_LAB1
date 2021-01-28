LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bigALU IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (15 downto 0);
		Op : IN STD_LOGIC;
		Result : OUT STD_LOGIC_VECTOR (15 downto 0)
	);
END;

ARCHITECTURE struct OF bigALU IS

SIGNAL int_B : STD_LOGIC_VECTOR (15 downto 0);
SIGNAL int_P, int_G : STD_LOGIC_VECTOR (3 downto 0);
SIGNAL int_C : STD_LOGIC_VECTOR (3 downto 1);

COMPONENT complementer_16bit IS
	PORT (
		input : IN STD_LOGIC_VECTOR (15 downto 0);
		cin : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR (15 downto 0)
	);
END COMPONENT;

COMPONENT adderCLA_4bit IS
	PORT (
		a, b : IN STD_LOGIC_VECTOR (3 downto 0);
		cin : IN STD_LOGIC;
		sum : OUT STD_LOGIC_VECTOR (3 downto 0);
		P, G : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT unitCLA_16bit IS
	PORT (
		P, G : IN STD_LOGIC_VECTOR (3 downto 0);
		Cin : IN STD_LOGIC;
		C : OUT STD_LOGIC_VECTOR (3 downto 1);
		Cout : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN
	--Component Instantiation--
	COMP1s: complementer_16bit
	PORT MAP (input => B,
		  cin => Op,
		  output => int_B
	);

	ALU0: adderCLA_4bit
	PORT MAP (a => A(3 downto 0),
		  b => int_B(3 downto 0),
		  cin => Op,
		  sum => Result(3 downto 0),
		  P => int_P(0),
		  G => int_G(0)
	);

	ALU1: adderCLA_4bit
	PORT MAP (a => A(7 downto 4),
		  b => int_B(7 downto 4),
		  cin => int_C(1),
		  sum => Result(7 downto 4),
		  P => int_P(1),
		  G => int_G(1)
	);

	ALU2: adderCLA_4bit
	PORT MAP (a => A(11 downto 8),
		  b => int_B(11 downto 8),
		  cin => int_C(2),
		  sum => Result(11 downto 8),
		  P => int_P(2),
		  G => int_G(2)
	);

	ALU3: adderCLA_4bit
	PORT MAP (a => A(15 downto 12),
		  b => int_B(15 downto 12),
		  cin => int_C(3),
		  sum => Result(15 downto 12),
		  P => int_P(3),
		  G => int_G(3)
	);

	CLAblock: unitCLA_16bit
	PORT MAP (P => int_P,
		  G => int_G,
		  Cin => Op,
		  C => int_C,
  		  Cout => OPEN
	);
END struct;

		  
