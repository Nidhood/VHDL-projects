LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_Full_Adder IS
END ENTITY test_Full_Adder;

ARCHITECTURE test_Full_Adder_Arch OF test_Full_Adder IS

    -- Señales de prueba
    SIGNAL A_tb, B_tb, Cin_tb : STD_LOGIC;
    SIGNAL Sum_tb, Cout_tb    : STD_LOGIC;

BEGIN

    -- Instanciación del DUT (Full_Adder)
    X1 : ENTITY work.Full_Adder
        PORT MAP(
            X    => A_tb,
            Y    => B_tb,
            Cin  => Cin_tb,
            Sum  => Sum_tb,
            Cout => Cout_tb
        );

    -- Secuencia de valores para A_tb
    A_tb <=
        '0' AFTER 0 ns,
        '0' AFTER 20 ns,
        '0' AFTER 40 ns,
        '0' AFTER 60 ns,
        '1' AFTER 80 ns,
        '1' AFTER 100 ns,
        '1' AFTER 120 ns,
        '1' AFTER 140 ns;

    -- Secuencia de valores para B_tb
    B_tb <=
        '0' AFTER 0 ns,
        '0' AFTER 20 ns,
        '1' AFTER 40 ns,
        '1' AFTER 60 ns,
        '0' AFTER 80 ns,
        '0' AFTER 100 ns,
        '1' AFTER 120 ns,
        '1' AFTER 140 ns;

    -- Secuencia de valores para Cin_tb
    Cin_tb <=
        '0' AFTER 0 ns,
        '1' AFTER 20 ns,
        '0' AFTER 40 ns,
        '1' AFTER 60 ns,
        '0' AFTER 80 ns,
        '1' AFTER 100 ns,
        '0' AFTER 120 ns,
        '1' AFTER 140 ns;

END ARCHITECTURE test_Full_Adder_Arch;
