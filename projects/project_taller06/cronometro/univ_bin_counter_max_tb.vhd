-- run 400ns
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY univ_bin_counter_max_tb IS
END univ_bin_counter_max_tb;

ARCHITECTURE behavior OF univ_bin_counter_max_tb IS

    CONSTANT N : INTEGER := 4;

    -- Señales de prueba
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL ena : STD_LOGIC := '0';
    SIGNAL syn_clr : STD_LOGIC := '0';
    SIGNAL load : STD_LOGIC := '0';
    SIGNAL up : STD_LOGIC := '0';
    SIGNAL d : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL max_val : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := "1010"; -- Máximo en 10 (1010 bin)
    SIGNAL max_tick : STD_LOGIC;
    SIGNAL min_tick : STD_LOGIC;
    SIGNAL counter : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instancia del contador
    uut : ENTITY work.univ_bin_counter_max
        GENERIC MAP(N => N)
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => ena,
            syn_clr => syn_clr,
            load => load,
            up => up,
            d => d,
            max_val => max_val,
            max_tick => max_tick,
            min_tick => min_tick,
            counter => counter
        );

    -- Generador de reloj
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR clk_period / 2;
            clk <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    -- Estímulos para verificar el funcionamiento
    stim_proc : PROCESS
    BEGIN
        -- 1️⃣ Reset inicial
        rst <= '1';
        WAIT FOR 2 * clk_period;
        rst <= '0';

        -- 2️⃣ Iniciar conteo ascendente con límite en 10
        ena <= '1';
        up <= '1';
        WAIT FOR 12 * clk_period; -- Esperar más de 10 ciclos (para ver si se reinicia)

        -- 3️⃣ Pausa del contador
        ena <= '0';
        WAIT FOR 5 * clk_period;

        -- 4️⃣ Conteo descendente
        ena <= '1';
        up <= '0';
        WAIT FOR 5 * clk_period;

        -- 5️⃣ Clear síncrono
        syn_clr <= '1';
        WAIT FOR clk_period;
        syn_clr <= '0';

        -- 6️⃣ Carga un valor inicial (Ejemplo: 5)
        load <= '1';
        d <= "0101"; -- Cargar el valor 5
        WAIT FOR clk_period;
        load <= '0';

        -- 7️⃣ Continuar conteo ascendente desde 5
        ena <= '1';
        up <= '1';
        WAIT FOR 7 * clk_period;

        -- 8️⃣ Fin de la simulación
        ena <= '0';
        WAIT FOR 5 * clk_period;
        REPORT "Simulación finalizada" SEVERITY NOTE;
        WAIT;
    END PROCESS;

END ARCHITECTURE;