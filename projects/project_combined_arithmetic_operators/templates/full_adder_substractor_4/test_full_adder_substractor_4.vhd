LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_full_adder_substractor_4 IS
END ENTITY test_full_adder_substractor_4;

ARCHITECTURE tb OF test_full_adder_substractor_4 IS

    -- Señales de prueba para operaciones en 4 bits
    SIGNAL OP_tb : STD_LOGIC; -- '0' = suma, '1' = resta
    SIGNAL A_tb, B_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL R_tb : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Resultado (4 bits, 2's complement)
    SIGNAL CARRY_tb : STD_LOGIC; -- Carry extra
    SIGNAL OVERFLOW_tb : STD_LOGIC; -- Indicador de overflow

    -- Función para convertir un vector de 4 bits (en 2's complement) a entero
    FUNCTION to_integer_4(slv : STD_LOGIC_VECTOR(3 DOWNTO 0)) RETURN INTEGER IS
    BEGIN
        RETURN to_integer(signed(slv));
    END to_integer_4;

BEGIN

    --------------------------------------------------------------------
    -- Instanciación del DUT (FULL_ADDER_SUBSTRACTOR_4)
    --------------------------------------------------------------------
    UUT : ENTITY work.FULL_ADDER_SUBSTRACTOR_4(STRUCT)
        PORT MAP(
            OP => OP_tb,
            A => A_tb,
            B => B_tb,
            R => R_tb,
            CARRY => CARRY_tb,
            OVERFLOW => OVERFLOW_tb
        );

    --------------------------------------------------------------------
    -- Estímulos de prueba
    --------------------------------------------------------------------
    stim : PROCESS
    BEGIN
        ----------------------------------------------------------------
        -- Caso 1: Suma: 3 + 2 = 5
        ----------------------------------------------------------------
        OP_tb <= '0';
        A_tb <= "0011"; -- 3
        B_tb <= "0010"; -- 2
        WAIT FOR 40 ns;
        REPORT "Suma 3+2: R = " & INTEGER'image(to_integer_4(R_tb)) &
            ", CARRY = " & STD_LOGIC'image(CARRY_tb) &
            ", OVERFLOW = " & STD_LOGIC'image(OVERFLOW_tb);

        ----------------------------------------------------------------
        -- Caso 2: Suma: 7 + 7 = (overflow esperado)
        -- 7 = "0111"; 7+7=14, fuera de rango en 4 bits, se espera R = "1110" (-2) y OVERFLOW = '1'
        ----------------------------------------------------------------
        OP_tb <= '0';
        A_tb <= "0111"; -- 7
        B_tb <= "0111"; -- 7
        WAIT FOR 40 ns;
        REPORT "Suma 7+7: R = " & INTEGER'image(to_integer_4(R_tb)) &
            ", CARRY = " & STD_LOGIC'image(CARRY_tb) &
            ", OVERFLOW = " & STD_LOGIC'image(OVERFLOW_tb);

        ----------------------------------------------------------------
        -- Caso 3: Resta: 7 - 2 = 5
        ----------------------------------------------------------------
        OP_tb <= '1';
        A_tb <= "0111"; -- 7
        B_tb <= "0010"; -- 2
        WAIT FOR 40 ns;
        REPORT "Resta 7-2: R = " & INTEGER'image(to_integer_4(R_tb)) &
            ", CARRY = " & STD_LOGIC'image(CARRY_tb) &
            ", OVERFLOW = " & STD_LOGIC'image(OVERFLOW_tb);

        ----------------------------------------------------------------
        -- Caso 4: Resta: 3 - 5 = -2
        ----------------------------------------------------------------
        OP_tb <= '1';
        A_tb <= "0001"; -- 3
        B_tb <= "0010"; -- 5
        WAIT FOR 40 ns;
        REPORT "Resta 3-5: R = " & INTEGER'image(to_integer_4(R_tb)) &
            ", CARRY = " & STD_LOGIC'image(CARRY_tb) &
            ", OVERFLOW = " & STD_LOGIC'image(OVERFLOW_tb);

        WAIT;
    END PROCESS stim;

END ARCHITECTURE tb;