LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_univ_bin_counter IS
END ENTITY tb_univ_bin_counter;

ARCHITECTURE tb_univ_bin_counter_arch OF tb_univ_bin_counter IS

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC;
    SIGNAL ena : STD_LOGIC;
    SIGNAL syn_clr : STD_LOGIC;
    SIGNAL load : STD_LOGIC;
    SIGNAL up : STD_LOGIC;
    SIGNAL d : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL max_tick : STD_LOGIC;
    SIGNAL min_tick : STD_LOGIC;
    SIGNAL counter : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    X : ENTITY WORK.univ_bin_counter(rtl)
        GENERIC MAP(
            N => 4
        )
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => ena,
            syn_clr => syn_clr,
            load => load,
            up => up,
            d => d,
            max_tick => max_tick,
            min_tick => min_tick,
            counter => counter
        );

    -- Generacion del reloj: periodo de 10 ns (5 ns alto, 5 ns bajo)
    clk <= NOT clk AFTER 5 ns;

    -- Prueba 1: Inicialización y contar en orden ascendente
    -- Se activa el reset asincrono desde 0 ns hasta 15 ns.
    rst <= '1' AFTER 0 ns, '0' AFTER 15 ns;

    -- Se inicia con enable activo para contar ascendentemente.
    ena <= '1' AFTER 0 ns,
        -- Prueba 3: Hacer pausa; deshabilitar enable de 60 ns a 80 ns.
        '0' AFTER 60 ns,
        '1' AFTER 80 ns;

    -- Prueba 4: Cargar un valor específico (load) cuando enable este en '1'
    -- Se activa load por un ciclo entre 90 ns y 100 ns.
    load <= '0' AFTER 0 ns,
        '1' AFTER 90 ns,
        '0' AFTER 100 ns;

    -- Para la operacion de carga, el valor de 'd' cambia de "0110" a "1010" en el mismo instante.
    d <= "0110" AFTER 0 ns,
        "1010" AFTER 90 ns;

    -- Prueba 5: Senal clear sincrono (syn_clr) activa por un ciclo en 150 ns.
    syn_clr <= '0' AFTER 0 ns,
        '1' AFTER 150 ns,
        '0' AFTER 160 ns;

    -- Prueba 2: Cambiar la direccion de conteo.
    -- Inicialmente, se cuenta en orden ascendente (up = '1') y luego se cambia a descendente en 200 ns.
    up <= '1' AFTER 0 ns,
        '0' AFTER 200 ns;

END ARCHITECTURE tb_univ_bin_counter_arch;