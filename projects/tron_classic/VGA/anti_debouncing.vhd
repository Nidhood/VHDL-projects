LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY anti_debouncing IS
    GENERIC (
        N : INTEGER := 20; -- Tamaño del contador (ajustable)
        MAX_COUNT : STD_LOGIC_VECTOR(19 DOWNTO 0) := "11111001100100100000"  -- Aprox. 10 ms con clk de 50 MHz
    );
    PORT (
        clk        : IN STD_LOGIC;
        rst        : IN STD_LOGIC;
        button_in  : IN STD_LOGIC;
        button_out : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE anti_debouncing_Arch OF anti_debouncing IS
    SIGNAL tick       : STD_LOGIC;
    SIGNAL count_val  : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL clean_btn  : STD_LOGIC := '0';
BEGIN

    -- Instancia del contador universal
    CounterInst : ENTITY work.univ_bin_counter
        GENERIC MAP(N => N)
        PORT MAP (
            clk       => clk,
            rst       => rst,
            ena       => '1',
            syn_clr   => '0',
            load      => '0',
            up        => '1',
            d         => (OTHERS => '0'),
            max_val   => MAX_COUNT,
            max_tick  => tick,
            min_tick  => OPEN,
            counter   => count_val
        );

    -- Proceso para muestrear el botón solo en el tick
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            clean_btn <= '1';
        ELSIF rising_edge(clk) THEN
            IF tick = '1' THEN
                clean_btn <= button_in;
            END IF;
        END IF;
    END PROCESS;

    button_out <= clean_btn;

END ARCHITECTURE;
