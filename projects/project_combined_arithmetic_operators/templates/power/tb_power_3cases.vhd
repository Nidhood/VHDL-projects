LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_power_3cases IS
END ENTITY tb_power_3cases;

ARCHITECTURE tb OF tb_power_3cases IS

    --------------------------------------------------------------------
    -- Señales para conectar al DUT
    --------------------------------------------------------------------
    SIGNAL X_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Y_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL S_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);

    --------------------------------------------------------------------
    -- Función para convertir la salida (10 bits) a entero
    --------------------------------------------------------------------
    FUNCTION to_int_10bits(slv : STD_LOGIC_VECTOR(9 DOWNTO 0)) RETURN INTEGER IS
    BEGIN
        RETURN TO_INTEGER(UNSIGNED(slv));
    END FUNCTION to_int_10bits;

BEGIN

    --------------------------------------------------------------------
    -- Instanciación del DUT (Device Under Test)
    --------------------------------------------------------------------
    UUT : ENTITY work.power_3cases(no_if_for_arch)
        PORT MAP(
            X => X_tb,
            Y => Y_tb,
            S => S_tb
        );

    --------------------------------------------------------------------
    -- Proceso de estimulación
    --------------------------------------------------------------------
    stim_proc : PROCESS
    BEGIN
        ----------------------------------------------------------------
        -- Test 1: X=1, Y=0 => 1^0 = 1
        ----------------------------------------------------------------
        X_tb <= "0001"; -- 1
        Y_tb <= "0000"; -- 0
        WAIT FOR 20 ns;
        REPORT "Test1: X=1, Y=0 => S=" & INTEGER'IMAGE(to_int_10bits(S_tb));

        ----------------------------------------------------------------
        -- Test 2: X=2, Y=1 => 2^1 = 2
        ----------------------------------------------------------------
        X_tb <= "0010"; -- 2
        Y_tb <= "0001"; -- 1
        WAIT FOR 20 ns;
        REPORT "Test2: X=2, Y=1 => S=" & INTEGER'IMAGE(to_int_10bits(S_tb));

        ----------------------------------------------------------------
        -- Test 3: X=3, Y=2 => 3^2 = 9
        ----------------------------------------------------------------
        X_tb <= "0011"; -- 3
        Y_tb <= "0010"; -- 2
        WAIT FOR 20 ns;
        REPORT "Test3: X=3, Y=2 => S=" & INTEGER'IMAGE(to_int_10bits(S_tb));

        ----------------------------------------------------------------
        -- Test 4: X=15, Y=2 => 15^2 = 225
        ----------------------------------------------------------------
        X_tb <= "1111"; -- 15
        Y_tb <= "0010"; -- 2
        WAIT FOR 20 ns;
        REPORT "Test4: X=15, Y=2 => S=" & INTEGER'IMAGE(to_int_10bits(S_tb));

        ----------------------------------------------------------------
        -- Test 5: Caso con Y distinto de 0,1,2 => "1111111111"
        ----------------------------------------------------------------
        X_tb <= "0100"; -- 4
        Y_tb <= "0101"; -- 5
        WAIT FOR 20 ns;
        REPORT "Test5: X=4, Y=5 => S=" & INTEGER'IMAGE(to_int_10bits(S_tb))
            & " (esperado 1023)";

        WAIT;
    END PROCESS stim_proc;

END ARCHITECTURE tb;