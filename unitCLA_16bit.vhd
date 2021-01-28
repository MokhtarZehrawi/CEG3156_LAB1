LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY unitCLA_16bit IS
	PORT (
		P, G : IN STD_LOGIC_VECTOR (3 downto 0);
		Cin : IN STD_LOGIC;
		C : OUT STD_LOGIC_VECTOR (3 downto 1);
		Cout : OUT STD_LOGIC
	);
END;

ARCHITECTURE struct OF unitCLA_16bit IS

BEGIN
	C(1) <= G(0) OR (P(0) AND Cin);
	C(2) <= G(1) OR (P(1) AND G(0)) OR (P(1) AND P(0) AND Cin);
	C(3) <= G(2) OR (P(2) AND G(1)) OR (P(2) AND P(1) AND G(0)) OR (P(3) AND P(2) AND P(1) AND P(0) AND Cin);
	Cout <= G(3) OR (P(3) AND G(2)) OR (P(3) AND P(2) AND G(1)) OR (P(3) AND P(2) AND P(1) AND P(0) AND G(0)) OR (P(3) AND P(2) AND P(1) AND P(0) AND Cin);
END struct;

