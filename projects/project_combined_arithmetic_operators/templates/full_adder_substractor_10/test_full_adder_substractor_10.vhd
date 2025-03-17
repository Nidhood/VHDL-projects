LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_full_adder_substractor_10 IS
END ENTITY test_full_adder_substractor_10;

ARCHITECTURE tb OF test_full_adder_substractor_10 IS

    -- Señales de prueba para operaciones en 10 bits (números con signo)
    SIGNAL OP_tb : STD_LOGIC; -- 0 = suma, 1 = resta
    SIGNAL A_tb, B_tb : STD_LOGIC_VECTOR(9 DOWNTO 0); -- Entradas de 10 bits en complemento a 2
    SIGNAL R_tb : STD_LOGIC_VECTOR(8 DOWNTO 0); -- Resultado (9 bits: 8 bits + signo)
    SIGNAL COUT_tb, OVERFLOW_tb : STD_LOGIC;

    -- Función para convertir un vector con signo a entero (para 10 bits)
    FUNCTION slv_to_integer(slv : STD_LOGIC_VECTOR) RETURN INTEGER IS
    BEGIN
        RETURN TO_INTEGER(SIGNED(slv));
    END slv_to_integer;

BEGIN

    --------------------------------------------------------------------
    -- Instanciación del DUT (FULL_ADDER_SUBSTRACTOR_10)
    --------------------------------------------------------------------
    UUT : ENTITY work.FULL_ADDER_SUBSTRACTOR_10(STRUCT)
        PORT MAP(
            OP => OP_tb,
            A => A_tb,
            B => B_tb,
            R => R_tb,
            COUT => COUT_tb,
            OVERFLOW => OVERFLOW_tb
        );

    --------------------------------------------------------------------
    -- Estímulos de prueba
    --------------------------------------------------------------------
    stim : PROCESS
    BEGIN
        -- Prueba de suma: +50 + +10 = +60
        OP_tb <= '0';
        A_tb <= "0000110010"; -- +50
        B_tb <= "0000001010"; -- +10
        WAIT FOR 40 ns;

        -- Prueba de suma: -30 + -15 = -45
        A_tb <= "1111000010"; -- -30 (10-bit 2's complement)
        B_tb <= "1111010001"; -- -15
        WAIT FOR 40 ns;

        -- Prueba de resta: +50 - +20 = +30
        OP_tb <= '1';
        A_tb <= "0000110010"; -- +50
        B_tb <= "0000010100"; -- +20
        WAIT FOR 40 ns;

        -- Prueba de resta: +20 - +50 = -30
        A_tb <= "0000010100"; -- +20
        B_tb <= "0000110010"; -- +50
        WAIT FOR 40 ns;

        WAIT;
    END PROCESS stim;

END ARCHITECTURE tb;