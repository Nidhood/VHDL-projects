LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_full_adder_substractor_4 IS
END ENTITY test_full_adder_substractor_4;

ARCHITECTURE tb OF test_full_adder_substractor_4 IS

    -- Señales de prueba para operaciones en 4 bits
    SIGNAL OP_tb : STD_LOGIC; -- 0 = suma, 1 = resta
    SIGNAL A_tb, B_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL R_tb : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Resultado (4 bits en 2's complement)
    SIGNAL CARRY_tb : STD_LOGIC; -- Carry (extra, que indica el signo según la operación)
    SIGNAL OVERFLOW_tb : STD_LOGIC; -- Indicador de overflow

    -- Función para convertir un vector de 4 bits (en 2's complement) a entero
    FUNCTION slv_to_integer(slv : STD_LOGIC_VECTOR) RETURN INTEGER IS
    BEGIN
        RETURN TO_INTEGER(SIGNED(slv));
    END slv_to_integer;

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
        -- Caso 1: Prueba de suma: 7 + 7 = 14 
        -- (En 4 bits en 2's complement el rango positivo es de 0 a 7, por lo que 7+7 produce overflow)
        OP_tb <= '0';
        A_tb <= "0111"; -- 7
        B_tb <= "0111"; -- 7
        WAIT FOR 40 ns;

        -- Caso 2: Prueba de suma: 10 + 4 = 14
        -- Nota: En 4 bits, "1010" se interpreta como -6 en 2's complement.
        -- Se asume que se desea observar el comportamiento, ya que 10 no es representable en 4 bits sin signo.
        A_tb <= "1010"; -- Representación en 4 bits (10 en decimal no es representable; este valor se interpreta en 2's complement)
        B_tb <= "0100"; -- 4
        WAIT FOR 40 ns;

        -- Caso 3: Prueba de resta: 10 - 3 = 7
        OP_tb <= '1';
        A_tb <= "1010"; -- Nuevamente, "1010" se usa para la operación (interpretada en complemento a 2 para resta)
        B_tb <= "0011"; -- 3
        WAIT FOR 40 ns;

        -- Caso 4: Prueba de resta con underflow: 5 - 8 = -3
        A_tb <= "0101"; -- 5
        B_tb <= "1000"; -- 8
        WAIT FOR 40 ns;

        WAIT;
    END PROCESS stim;

END ARCHITECTURE tb;