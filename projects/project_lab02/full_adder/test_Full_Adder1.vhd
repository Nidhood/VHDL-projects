LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_Full_Adder1 IS
END ENTITY test_Full_Adder1;

ARCHITECTURE test_Full_Adder1_Arch OF test_Full_Adder1 IS

    SIGNAL A_tb, B_tb, Cin_tb : STD_LOGIC;
    SIGNAL S_tb, Cout_tb : STD_LOGIC;

BEGIN

    X1 : ENTITY work.Full_Adder1

        PORT MAP(
            A => A_tb,
            B => B_tb,
            Cin => Cin_tb,
            S => S_tb,
            Cout => Cout_tb
        );

    A_tb <=
        '0' AFTER 0 ns,
        '0' AFTER 20 ns,
        '0' AFTER 40 ns,
        '0' AFTER 60 ns,
        '1' AFTER 80 ns,
        '1' AFTER 100 ns,
        '1' AFTER 120 ns,
        '1' AFTER 140 ns;

    B_tb <=
        '0' AFTER 0 ns,
        '0' AFTER 20 ns,
        '1' AFTER 40 ns,
        '1' AFTER 60 ns,
        '0' AFTER 80 ns,
        '0' AFTER 100 ns,
        '1' AFTER 120 ns,
        '1' AFTER 140 ns;

    Cin_tb <=
        '0' AFTER 0 ns,
        '1' AFTER 20 ns,
        '0' AFTER 40 ns,
        '1' AFTER 60 ns,
        '0' AFTER 80 ns,
        '1' AFTER 100 ns,
        '0' AFTER 120 ns,
        '1' AFTER 140 ns;

END ARCHITECTURE test_Full_Adder1_Arch;