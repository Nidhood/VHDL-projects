------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: Decoder 2:4 con when/else (test)                                           --
--  Date: 20/02/2025                                                                    --
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------------------------------------------------------------
ENTITY test_pnt1_decorder2_4 IS
END ENTITY test_pnt1_decorder2_4;
------------------------------------------------------------------------------------------
ARCHITECTURE test_pnt1_decorder2_4_arch OF test_pnt1_decorder2_4 IS

    SIGNAL x_tb : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL en_tb : STD_LOGIC;
    SIGNAL y_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    X1 : ENTITY work.pnt1_decorder2_4
        PORT MAP(
            x => x_tb,
            en => en_tb,
            y => y_tb
        );

    x_tb <=
        "00" AFTER 0 ns,
        "01" AFTER 20 ns,
        "10" AFTER 40 ns,
        "11" AFTER 60 ns;

    en_tb <=
        '1' AFTER 0 ns,
        '1' AFTER 20 ns,
        '1' AFTER 40 ns,
        '1' AFTER 60 ns;

END ARCHITECTURE test_pnt1_decorder2_4_arch;