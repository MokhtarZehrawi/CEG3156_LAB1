
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY MUX_2x1_11bit IS
	PORT (
		input0, input1  : IN STD_LOGIC_VECTOR (10 downto 0);
		SEL 		: IN STD_LOGIC;
		output 		: OUT STD_LOGIC_VECTOR (10 downto 0)
	);
END;

ARCHITECTURE struct OF MUX_2x1_11bit IS

COMPONENT MUX_2x1 IS
	PORT (
		input : IN STD_LOGIC_VECTOR (1 downto 0);
		sel : IN STD_LOGIC;
		output : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN

	MUX_0: MUX_2x1
	PORT MAP (
		  input(0) => input0(0),
		  input(1) => input1(0),
		  sel => SEL,
		  output => output(0) );

	MUX_1: MUX_2x1
	PORT MAP (
		  input(0) => input0(1),
		  input(1) => input1(1),
		  sel => SEL,
		  output => output(1) );

	MUX_2: MUX_2x1
	PORT MAP (
		  input(0) => input0(2),
		  input(1) => input1(2),
		  sel => SEL,
		  output => output(2) );

	MUX_3: MUX_2x1
	PORT MAP (
		  input(0) => input0(3),
		  input(1) => input1(3),
		  sel => SEL,
		  output => output(3) );

	MUX_4: MUX_2x1
	PORT MAP (
		  input(0) => input0(4),
		  input(1) => input1(4),
		  sel => SEL,
		  output => output(4) );

	MUX_5: MUX_2x1
	PORT MAP (
		  input(0) => input0(5),
		  input(1) => input1(5),
		  sel => SEL,
		  output => output(5) );
	
	MUX_6: MUX_2x1
	PORT MAP (
		  input(0) => input0(6),
		  input(1) => input1(6),
		  sel => SEL,
		  output => output(6) );

	MUX_7: MUX_2x1
	PORT MAP (
		  input(0) => input0(8),
		  input(1) => input1(7),
		  sel => SEL,
		  output => output(7) );

	MUX_8: MUX_2x1
	PORT MAP (
		  input(0) => input0(8),
		  input(1) => input1(8),
		  sel => SEL,
		  output => output(8) );

	MUX_9: MUX_2x1
	PORT MAP (
		  input(0) => input0(9),
		  input(1) => input1(9),
		  sel => SEL,
		  output => output(9) );

	MUX_10: MUX_2x1
	PORT MAP (
		  input(0) => input0(10),
		  input(1) => input1(10),
		  sel => SEL,
		  output => output(10) );

END struct;
