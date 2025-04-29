
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY test_7seg_4counter IS
END test_7seg_4counter;

ARCHITECTURE test_7seg_4counter_arch OF test_7seg_4counter IS

    SIGNAL in_7seg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL en : STD_LOGIC;
    SIGNAL out_7seg : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    X1 : ENTITY WORK.7seg_4counter

        PORT MAP(
            in_7seg => in_7seg,
            en => en,
            out_7seg => out_7seg
        );

    in_7seg <=
        "0000" AFTER 0 ns,
        "0001" AFTER 20 ns,
        "0010" AFTER 40 ns,
        "0011" AFTER 60 ns,
        "0100" AFTER 80 ns,
        "0101" AFTER 100 ns,
        "0110" AFTER 120 ns,
        "0111" AFTER 140 ns,
        "1000" AFTER 160 ns,
        "1001" AFTER 180 ns;

END test_7seg_4counter_arch;