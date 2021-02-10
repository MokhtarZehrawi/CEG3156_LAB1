LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_2x1_4bit IS
	PORT (
		input0, input1 : IN STD_LOGIC_VECTOR (3 downto 0);
		SEL : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR (3 downto 0)
	);
END;

ARCHITECTURE struct OF MUX_2x1_4bit IS

COMPONENT MUX_2x1 IS
	PORT (
		input : IN STD_LOGIC_VECTOR (1 downto 0);
		sel : IN STD_LOGIC;
		output : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN
	MSB: MUX_2x1
	PORT MAP (
		  input(0) => input0(3),
		  input(1) => input1(3),
		  sel => SEL,
		  output => output(3)
	);

	ThirdBit: MUX_2x1
	PORT MAP (
		  input(0) => input0(2),
		  input(1) => input1(2),
		  sel => SEL,
		  output => output(2)
	);

	SecondBit: MUX_2x1
	PORT MAP (
		  input(0) => input0(1),
		  input(1) => input1(1),
		  sel => SEL,
		  output => output(1)
	);

	LSB: MUX_2x1
	PORT MAP (
		  input(0) => input0(0),
		  input(1) => input1(0),
		  sel => SEL,
		  output => output(0)
	);

END struct;
