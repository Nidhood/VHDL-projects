LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_Full_Adder4 IS
END ENTITY test_Full_Adder4;

ARCHITECTURE test_Full_Adder4_Arch OF test_Full_Adder4 IS

    SIGNAL A_tb, B_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Cin_tb : STD_LOGIC;
    SIGNAL S_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Cout_tb : STD_LOGIC;

BEGIN

    X1 : ENTITY work.Full_Adder4
        PORT MAP(
            A0 => A_tb(0), A1 => A_tb(1), A2 => A_tb(2), A3 => A_tb(3),
            B0 => B_tb(0), B1 => B_tb(1), B2 => B_tb(2), B3 => B_tb(3),
            Cin => Cin_tb,
            S0 => S_tb(0), S1 => S_tb(1), S2 => S_tb(2), S3 => S_tb(3),
            Cout => Cout_tb
        );

    A_tb <=
        "0000" AFTER 0 ns,
        "0001" AFTER 10 ns,
        "0010" AFTER 20 ns,
        "0100" AFTER 30 ns,
        "0110" AFTER 40 ns,
        "0111" AFTER 50 ns,
        "1000" AFTER 60 ns,
        "1100" AFTER 70 ns,
        "1110" AFTER 80 ns,
        "1111" AFTER 90 ns;

    B_tb <=
        "0000" AFTER 0 ns,
        "0001" AFTER 10 ns,
        "0011" AFTER 20 ns,
        "0101" AFTER 30 ns,
        "0010" AFTER 40 ns,
        "0111" AFTER 50 ns,
        "0110" AFTER 60 ns,
        "1011" AFTER 70 ns,
        "1101" AFTER 80 ns,
        "1111" AFTER 90 ns;

    Cin_tb <=
        '0' AFTER 0 ns,
        '0' AFTER 10 ns,
        '0' AFTER 20 ns,
        '0' AFTER 30 ns,
        '1' AFTER 40 ns,
        '1' AFTER 50 ns,
        '0' AFTER 60 ns,
        '1' AFTER 70 ns,
        '1' AFTER 80 ns,
        '1' AFTER 90 ns;

END ARCHITECTURE test_Full_Adder4_Arch;