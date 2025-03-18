LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Test bench para la entidad complement2_10bits
ENTITY tb_complement2_10bits IS
END ENTITY tb_complement2_10bits;

ARCHITECTURE tb OF tb_complement2_10bits IS

    -- Señales para conectar al DUT
    SIGNAL X_tb : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL S_tb : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN

    --------------------------------------------------------------------
    -- Instanciación del DUT (complement2_10bits)
    --------------------------------------------------------------------
    UUT : ENTITY work.complement2_10bits(ripple_adder)
        PORT MAP(
            X => X_tb,
            S => S_tb
        );

    --------------------------------------------------------------------
    -- Proceso de estímulo (sin usar for ni if)
    --------------------------------------------------------------------
    stim_proc : PROCESS
    BEGIN
        -- Caso 1: X = 0000000000
        X_tb <= "0000000000";
        WAIT FOR 20 ns;
        REPORT "Case 1: X=0000000000 aplicado";

        -- Caso 2: X = 0000000001
        X_tb <= "0000000001";
        WAIT FOR 20 ns;
        REPORT "Case 2: X=0000000001 aplicado";

        -- Caso 3: X = 0000001010
        X_tb <= "0000001010";
        WAIT FOR 20 ns;
        REPORT "Case 3: X=0000001010 aplicado";

        -- Caso 4: X = 1111111111
        X_tb <= "1111111111";
        WAIT FOR 20 ns;
        REPORT "Case 4: X=1111111111 aplicado";

        -- Caso 5: X = 1000000000
        X_tb <= "1000000000";
        WAIT FOR 20 ns;
        REPORT "Case 5: X=1000000000 aplicado";

        WAIT; -- Final de la simulación
    END PROCESS stim_proc;

END ARCHITECTURE tb;