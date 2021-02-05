LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY roundAdder_8bit IS
	PORT (
		A, B : IN STD_LOGIC_VECTOR (7 downto 0);
		Cin : IN STD_LOGIC;
		S : OUT STD_LOGIC_VECTOR (7 downto 0);
		Cout : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF roundAdder_8bit IS

COMPONENT adderCLA_4bit IS
	PORT (
		a, b : IN STD_LOGIC_VECTOR (3 downto 0);
		cin : IN STD_LOGIC;
		sum : OUT STD_LOGIC_VECTOR (3 downto 0);
		P, G : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT unitCLA_8bit IS
	PORT (
		P, G : IN STD_LOGIC_VECTOR (1 downto 0);
		Cin : IN STD_LOGIC;
		C : OUT STD_LOGIC;
		Cout : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL int_P, int_G : STD_LOGIC_VECTOR (1 downto 0);
SIGNAL int_C : STD_LOGIC;

BEGIN
	-- Component Instantiation --
	HighNibble: adderCLA_4bit
	PORT MAP (a => A(7 downto 4),
		  b => B(7 downto 4),
		  cin => int_C,
		  sum => S(7 downto 4),
		  P => int_P(1),
		  G => int_G(1)
	);

	LowNibble: adderCLA_4bit
	PORT MAP (a => A(3 downto 0),
		  b => B(3 downto 0),
		  cin => Cin,
		  sum => S(3 downto 0),
		  P => int_P(0),
		  G => int_G(0)
	);

	predC: unitCLA_8bit
	PORT MAP (P => int_P,
		  G => int_G,
		  Cin => Cin,
		  C => int_C,
		  Cout => Cout
	);

END struct;
