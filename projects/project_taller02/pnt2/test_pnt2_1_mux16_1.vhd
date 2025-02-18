LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_pnt2_1_mux16_1 IS
END ENTITY test_pnt2_1_mux16_1;

ARCHITECTURE test_pnt2_1_mux16_1_arch OF test_pnt2_1_mux16_1 IS

    SIGNAL s_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL y_tb : STD_LOGIC;

BEGIN

    X1 : ENTITY work.pnt2_1_mux16_1
        PORT MAP(
            s => s_tb,
            y => y_tb
        );

    s_tb <=
        "0000" AFTER 0 ns, -- Esperado: '1'
        "0001" AFTER 20 ns, -- Esperado: '1'
        "0010" AFTER 40 ns, -- Esperado: '1'
        "0011" AFTER 60 ns, -- Esperado: '0'
        "0100" AFTER 80 ns, -- Esperado: '1'
        "0101" AFTER 100 ns, -- Esperado: '1'
        "0110" AFTER 120 ns, -- Esperado: '1'
        "0111" AFTER 140 ns, -- Esperado: '0'
        "1000" AFTER 160 ns, -- Esperado: '1'
        "1001" AFTER 180 ns, -- Esperado: '1'
        "1010" AFTER 200 ns, -- Esperado: '1'
        "1011" AFTER 220 ns, -- Esperado: '0'
        "1100" AFTER 240 ns, -- Esperado: '0'
        "1101" AFTER 260 ns, -- Esperado: '0'
        "1110" AFTER 280 ns, -- Esperado: '0'
        "1111" AFTER 300 ns; -- Esperado: '0'

END ARCHITECTURE test_pnt2_1_mux16_1_arch;

