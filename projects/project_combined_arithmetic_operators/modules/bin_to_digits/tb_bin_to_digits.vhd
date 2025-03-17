LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_bin_to_digits IS
END ENTITY test_bin_to_digits;

ARCHITECTURE test_bin_to_digits_Arch OF test_bin_to_digits IS

    -- Señales de prueba
    SIGNAL R_tb : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B1_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL B2_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL B3_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL H1_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL H2_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL H3_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL S_tb : STD_LOGIC;

BEGIN

    -- Instanciación del DUT (Device Under Test)
    DUT : ENTITY WORK.bin_to_digits(bin_to_digits_Arch)
        PORT MAP(
            R => R_tb,
            B1 => B1_tb,
            B2 => B2_tb,
            B3 => B3_tb,
            H1 => H1_tb,
            H2 => H2_tb,
            H3 => H3_tb,
            S => S_tb
        );

    -- Asignaciones con `AFTER` para pruebas
    R_tb <= "0000000000" AFTER 0 ns, -- 0
        "1111110110" AFTER 20 ns, -- -10
        "0000011001" AFTER 40 ns, -- 25
        "0000110010" AFTER 60 ns, -- 50
        "0001001011" AFTER 80 ns, -- 75
        "0001100100" AFTER 100 ns, -- 100
        "1110000011" AFTER 120 ns, -- -125
        "0010101111" AFTER 140 ns, -- 175
        "0011001000" AFTER 160 ns, -- 200
        "0011111010" AFTER 180 ns; -- 250
END ARCHITECTURE test_bin_to_digits_Arch;