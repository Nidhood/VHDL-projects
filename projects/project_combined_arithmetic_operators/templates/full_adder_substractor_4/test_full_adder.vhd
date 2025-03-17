LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_full_adder IS
END ENTITY test_full_adder;

ARCHITECTURE test_full_adder_arch OF test_full_adder IS

    -- Señales de prueba
    SIGNAL A_tb, B_tb, Cin_tb : STD_LOGIC;
    SIGNAL S_tb, Cout_tb : STD_LOGIC;
BEGIN

    -- Instanciación del DUT (Full_Adder)
    X1 : ENTITY work.Full_Adder
        PORT MAP(
            A => A_tb,
            B => B_tb,
            Cin => Cin_tb,
            S => S_tb,
            Cout => Cout_tb
        );

    -- Secuencia de valores para X_tb
    A_tb <=
        '0' AFTER 0 ns,
        '0' AFTER 20 ns,
        '0' AFTER 40 ns,
        '0' AFTER 60 ns,
        '1' AFTER 80 ns,
        '1' AFTER 100 ns,
        '1' AFTER 120 ns,
        '1' AFTER 140 ns;

    -- Secuencia de valores para Y_tb
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