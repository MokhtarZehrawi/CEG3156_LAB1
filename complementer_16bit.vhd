LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY complementer_16bit IS
	PORT (
		input : IN STD_LOGIC_VECTOR (15 downto 0);
		cin : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR (15 downto 0)
	);
END;

ARCHITECTURE struct OF complementer_16bit IS

BEGIN
	output(15) <= input(15) XOR cin;
	output(14) <= input(14) XOR cin;
	output(13) <= input(13) XOR cin;
	output(12) <= input(12) XOR cin;
	output(11) <= input(11) XOR cin;
	output(10) <= input(10) XOR cin;
	output(9) <= input(9) XOR cin;
	output(8) <= input(8) XOR cin;
	output(7) <= input(7) XOR cin;
	output(6) <= input(6) XOR cin;
	output(5) <= input(5) XOR cin;
	output(4) <= input(4) XOR cin;
	output(3) <= input(3) XOR cin;
	output(2) <= input(2) XOR cin;
	output(1) <= input(1) XOR cin;
	output(0) <= input(0) XOR cin;

END struct;

