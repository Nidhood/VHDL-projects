LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_cronometro IS
END tb_cronometro;

ARCHITECTURE behavior OF tb_cronometro IS

    -- Señales para conectar con el DUT
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL go : STD_LOGIC := '0';
    SIGNAL sync_rst : STD_LOGIC := '0';
    SIGNAL dec : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL un : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mili : STD_LOGIC_VECTOR(3 DOWNTO 0);

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- ✅ Generador de reloj con AFTER
    clk <= NOT clk AFTER clk_period / 2;

    -- ✅ Proceso de estímulos
    stim_proc : PROCESS
    BEGIN
        -- 🔁 Reset inicial
        rst <= '1';
        WAIT FOR 20 ns;
        rst <= '0';

        -- ✅ Activar conteo continuo
        go <= '1';

        WAIT FOR 60 us;

        -- Fin de simulación
        go <= '0';
        REPORT "Simulación finalizada correctamente (dec:un:mili)" SEVERITY NOTE;
        WAIT;
    END PROCESS;

    -- ✅ Instancia del DUT
    uut : ENTITY work.cronometro
        PORT MAP(
            clk => clk,
            rst => rst,
            go => go,
            sync_rst => sync_rst,
            dec => dec,
            un => un,
            mili => mili
        );

END ARCHITECTURE;