LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; -- Se agrega esta librería para usar TO_UNSIGNED

ENTITY tb_Multiplier IS
END ENTITY tb_Multiplier;

ARCHITECTURE behavior OF tb_Multiplier IS

    -- Declaración de señales
    SIGNAL x : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL y : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL s : STD_LOGIC_VECTOR(7 DOWNTO 0);

    -- Instanciación de la entidad Multiplier
    COMPONENT Multiplier
        PORT(
            x : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            y : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
            s : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    -- Instancia de la unidad Multiplier
    uut: Multiplier
        PORT MAP (
            x => x,
            y => y,
            s => s
        );

    -- Proceso de estímulos
    stimulus_process : PROCESS
    BEGIN
        -- Bucle para probar todas las combinaciones de 1*1 hasta 15*15
        FOR i IN 1 TO 15 LOOP
            FOR j IN 1 TO 15 LOOP
                x <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, x'length)); -- Convierte i a 4 bits
                y <= STD_LOGIC_VECTOR(TO_UNSIGNED(j, y'length)); -- Convierte j a 4 bits
                WAIT FOR 10 ns; -- Espera 10 ns por cada multiplicación
            END LOOP;
        END LOOP;

        -- Finaliza la simulación
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;
