LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_full_adder_substractor IS
END ENTITY test_full_adder_substractor;

ARCHITECTURE test_full_adder_substractor_Arch OF test_full_adder_substractor IS

    -- Señales de prueba
    SIGNAL A_or_S_tb : STD_LOGIC;
    SIGNAL X_tb, Y_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL S_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Cout_tb, Overflow_tb : STD_LOGIC;

BEGIN

    -- Instanciación del DUT (Full_Adder_Subtractor)
    X1 : ENTITY work.full_adder_substractor
        PORT MAP(
            A_or_S => A_or_S_tb,
            X => X_tb,
            Y => Y_tb,
            S => S_tb,
            Cout => Cout_tb,
            OVERFLOW => Overflow_tb
        );

    -- Control de la operación (Suma = 0, Resta = 1)
    A_or_S_tb <= '0' AFTER 0 ns,
        '1' AFTER 100 ns;

    -- Secuencia de valores para A_tb
    X_tb <=
        "0001" AFTER 0 ns, -- 1
        "0011" AFTER 20 ns, -- 3
        "0101" AFTER 40 ns, -- 5
        "0110" AFTER 60 ns, -- 6
        "1001" AFTER 80 ns, -- 9
        "0011" AFTER 120 ns, -- 3
        "0100" AFTER 140 ns, -- 4
        "1000" AFTER 160 ns, -- 8
        "0111" AFTER 180 ns, -- 7
        "1010" AFTER 200 ns; -- 10

    -- Secuencia de valores para B_tb
    Y_tb <=
        "0010" AFTER 0 ns, -- 2
        "0001" AFTER 20 ns, -- 1
        "0011" AFTER 40 ns, -- 3
        "0110" AFTER 60 ns, -- 6
        "0111" AFTER 80 ns, -- 7
        "0001" AFTER 120 ns, -- 1
        "0010" AFTER 140 ns, -- 2
        "0011" AFTER 160 ns, -- 3
        "0110" AFTER 180 ns, -- 6
        "0101" AFTER 200 ns; -- 5
END ARCHITECTURE test_full_adder_substractor_Arch;