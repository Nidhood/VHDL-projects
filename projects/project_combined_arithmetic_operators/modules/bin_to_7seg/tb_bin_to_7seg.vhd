------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: tb_hex_to_7seg                                                             --
--  Date: 11/03/2025                                                                    --
------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_hex_to_7seg IS
END tb_hex_to_7seg;

ARCHITECTURE behavior OF tb_hex_to_7seg IS

    -- Declaración del componente a testear (UUT)
    COMPONENT hex_to_7seg
        PORT (
            x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            sseg : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    -- Señales internas para la simulación
    SIGNAL x : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sseg : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    -- Instanciación del UUT
    uut : hex_to_7seg
    PORT MAP(
        x => x,
        sseg => sseg
    );

    -- Proceso para generar estímulos
    stim_proc : PROCESS
    BEGIN
        -- Se recorre desde 0 hasta 15 (valores hexadecimales de 4 bits)
        FOR i IN 0 TO 15 LOOP
            x <= STD_LOGIC_VECTOR(to_unsigned(i, 4));
            WAIT FOR 20 ns;
        END LOOP;
        WAIT;
    END PROCESS;

END behavior;