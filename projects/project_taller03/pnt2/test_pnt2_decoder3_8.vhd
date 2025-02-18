------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: Decoder 3:8 (test)                                                         --
--  Date: 20/02/2025                                                                    --
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------------------------------------------------------------
ENTITY test_pnt2_decoder3_8 IS
END ENTITY test_pnt2_decoder3_8;
------------------------------------------------------------------------------------------
ARCHITECTURE test_pnt2_decoder3_8_arch OF test_pnt2_decoder3_8 IS

    SIGNAL x_tb : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL en_tb : STD_LOGIC;
    SIGNAL y_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    X1 : ENTITY work.pnt2_decoder3_8
        PORT MAP(
            x => x_tb,
            en => en_tb,
            y => y_tb
        );

    x_tb <=
        "000" AFTER 0 ns,
        "001" AFTER 20 ns,
        "010" AFTER 40 ns,
        "011" AFTER 60 ns,
        "100" AFTER 80 ns,
        "101" AFTER 100 ns,
        "110" AFTER 120 ns,
        "111" AFTER 140 ns;

    en_tb <=
        '1' AFTER 0 ns,
        '1' AFTER 20 ns,
        '1' AFTER 40 ns,
        '1' AFTER 60 ns,
        '1' AFTER 80 ns,
        '1' AFTER 100 ns,
        '1' AFTER 120 ns,
        '1' AFTER 140 ns;

END ARCHITECTURE test_pnt2_decoder3_8_arch;