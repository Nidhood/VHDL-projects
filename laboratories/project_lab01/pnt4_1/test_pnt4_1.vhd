LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_pnt4_1 IS
END ENTITY test_pnt4_1;

ARCHITECTURE test_pnt4_1_Arch OF test_pnt4_1 IS

    SIGNAL x1_tb : STD_LOGIC;
    SIGNAL x2_tb : STD_LOGIC;
    SIGNAL x3_tb : STD_LOGIC;
    SIGNAL f_tb : STD_LOGIC;

BEGIN

    X1 : ENTITY work.pnt4_1

        PORT MAP(
            x1 => x1_tb,
            x2 => x2_tb,
            x3 => x3_tb,
            f => f_tb
        );

    x1_tb <=
        '0' AFTER 0 ns,
        '0' AFTER 20 ns,
        '0' AFTER 40 ns,
        '0' AFTER 60 ns,
        '1' AFTER 80 ns,
        '1' AFTER 100 ns,
        '1' AFTER 120 ns,
        '1' AFTER 140 ns;

    x2_tb <=
        '0' AFTER 0 ns,
        '0' AFTER 20 ns,
        '1' AFTER 40 ns,
        '1' AFTER 60 ns,
        '0' AFTER 80 ns,
        '0' AFTER 100 ns,
        '1' AFTER 120 ns,
        '1' AFTER 140 ns;

    x3_tb <=
        '0' AFTER 0 ns,
        '1' AFTER 20 ns,
        '0' AFTER 40 ns,
        '1' AFTER 60 ns,
        '0' AFTER 80 ns,
        '1' AFTER 100 ns,
        '0' AFTER 120 ns,
        '1' AFTER 140 ns;

END test_pnt4_1_Arch;

