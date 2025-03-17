LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test_N_bit_greater IS
END ENTITY test_N_bit_greater;

ARCHITECTURE test_N_bit_greater_Arch OF test_N_bit_greater IS

    -- Señales de prueba
    SIGNAL A_tb, B_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL GT_tb : STD_LOGIC;

BEGIN

    -- Instanciación del DUT (Device Under Test)
    DUT : ENTITY WORK.N_bit_greater
        PORT MAP(
            A => A_tb,
            B => B_tb,
            GT => GT_tb
        );

    -- Proceso de estímulos
    stimulus_process : PROCESS
    BEGIN
        -- Prueba 1: A > B
        A_tb <= "00000010"; -- 2
        B_tb <= "00000001"; -- 1
        WAIT FOR 10 ns; -- Esperar

        -- Prueba 2: A < B
        A_tb <= "00000001"; -- 1
        B_tb <= "00000010"; -- 2
        WAIT FOR 10 ns;

        -- Prueba 3: A = B
        A_tb <= "00000100"; -- 4
        B_tb <= "00000100"; -- 4
        WAIT FOR 10 ns;

        -- Prueba 4: A > B (valores grandes)
        A_tb <= "10000001"; -- 129
        B_tb <= "01111111"; -- 127
        WAIT FOR 10 ns;

        -- Prueba 5: A < B (valores grandes)
        A_tb <= "01111111"; -- 127
        B_tb <= "10000001"; -- 129
        WAIT FOR 10 ns;

        -- Prueba 6: A > B (cercanos)
        A_tb <= "11111111"; -- 255
        B_tb <= "11111110"; -- 254
        WAIT FOR 10 ns;

        -- Prueba 7: A < B (cercanos)
        A_tb <= "11111110"; -- 254
        B_tb <= "11111111"; -- 255
        WAIT FOR 10 ns;

        WAIT; -- Mantener la simulación activa
    END PROCESS stimulus_process;

END ARCHITECTURE test_N_bit_greater_Arch;