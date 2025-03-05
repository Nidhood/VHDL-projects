LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_shift_left IS
END ENTITY test_shift_left;

ARCHITECTURE test_shift_left_arch OF test_shift_left IS

    SIGNAL X_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL S_tb : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

    X1 : ENTITY work.bit_shift_left

        PORT MAP(
            X => X_tb,
            S => S_tb
        );

    X_tb <=
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

END ARCHITECTURE test_shift_left_arch;