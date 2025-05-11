LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_anti_debouncing IS
END ENTITY tb_anti_debouncing;

ARCHITECTURE sim OF tb_anti_debouncing IS

    CONSTANT N : INTEGER := 4;  -- Contador pequeño para simular rápido
    CONSTANT MAX_COUNT : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := "1010";  -- 10 ticks para validación

    SIGNAL clk        : STD_LOGIC := '0';
    SIGNAL rst        : STD_LOGIC;
    SIGNAL button_in  : STD_LOGIC;
    SIGNAL button_out : STD_LOGIC;

BEGIN

    -- Instancia del anti-debouncing
    UUT : ENTITY WORK.anti_debouncing
        GENERIC MAP (
            N => N,
            MAX_COUNT => MAX_COUNT
        )
        PORT MAP (
            clk        => clk,
            rst        => rst,
            button_in  => button_in,
            button_out => button_out
        );

    -- Generador de reloj: período de 10 ns
    clk <= NOT clk AFTER 5 ns;

    -- Reset: activo entre 0 y 15 ns
    rst <= '1' AFTER 0 ns, '0' AFTER 15 ns;

    -- Simulación de rebote en el botón de entrada
    button_in <= '0' AFTER 0 ns,
                 '1' AFTER 30 ns,     -- rebote: on
                 '0' AFTER 35 ns,     -- off
                 '1' AFTER 40 ns,     -- on
                 '0' AFTER 45 ns,     -- off
                 '1' AFTER 50 ns,     -- on (estable)
                 '0' AFTER 100 ns,    -- off (estable)
                 '1' AFTER 150 ns;    -- nuevo pulso

END ARCHITECTURE;
