------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: Binary code to Gray code (test)                                            --
--  Date: 20/02/2025                                                                    --
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------------------------------------------------------------------------
ENTITY test_pnt3_bin_to_gray IS
END ENTITY test_pnt3_bin_to_gray;
------------------------------------------------------------------------------------------
ARCHITECTURE test_pnt3_bin_to_gray_arch OF test_pnt3_bin_to_gray IS

    SIGNAL x_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL en_tb : STD_LOGIC;
    SIGNAL y_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    X1 : ENTITY work.pnt3_bin_to_gray
        PORT MAP(
            x => x_tb,
            en => en_tb,
            y => y_tb
        );

    x_tb <=
        "0000" AFTER 0 ns,
        "0001" AFTER 20 ns,
        "0010" AFTER 40 ns,
        "0011" AFTER 60 ns,
        "0100" AFTER 80 ns,
        "0101" AFTER 100 ns,
        "0110" AFTER 120 ns,
        "0111" AFTER 140 ns,
        "1000" AFTER 160 ns,
        "1001" AFTER 180 ns,
        "1010" AFTER 200 ns,
        "1011" AFTER 220 ns,
        "1100" AFTER 240 ns,
        "1101" AFTER 260 ns,
        "1110" AFTER 280 ns,
        "1111" AFTER 300 ns;

    en_tb <=
        '1' AFTER 0 ns,
        '1' AFTER 20 ns,
        '1' AFTER 40 ns,
        '1' AFTER 60 ns,
        '1' AFTER 80 ns,
        '1' AFTER 100 ns,
        '1' AFTER 120 ns,
        '1' AFTER 140 ns,
        '1' AFTER 160 ns,
        '1' AFTER 180 ns,
        '1' AFTER 200 ns,
        '1' AFTER 220 ns,
        '1' AFTER 240 ns,
        '1' AFTER 260 ns,
        '1' AFTER 280 ns,
        '1' AFTER 300 ns;

END ARCHITECTURE test_pnt3_bin_to_gray_arch;