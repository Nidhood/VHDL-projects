LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY anti_debouncing IS
    GENERIC (
        N : INTEGER := 21; -- TamaÃƒÂ±o del contador (ajustable)
        MAX_COUNT : STD_LOGIC_VECTOR(20 DOWNTO 0) := "111111111111111100000" -- Aprox. 10 ms con clk de 50 MHz
    );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        btn_in : IN STD_LOGIC;
        signal_out : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE anti_debouncing_Arch OF anti_debouncing IS
    SIGNAL tick : STD_LOGIC;
    SIGNAL count_val : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL pulse_counter : INTEGER RANGE 0 TO 5 := 0;
    SIGNAL pulse_active : STD_LOGIC := '0';
BEGIN

    -- Instancia del contador universal
    CounterInst : ENTITY work.univ_bin_counter
        GENERIC MAP(N => N)
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => btn_in,
            syn_clr => '0',
            load => '0',
            up => '1',
            d => (OTHERS => '0'),
            max_val => MAX_COUNT,
            max_tick => tick,
            min_tick => OPEN,
            counter => count_val
        );

    -- GeneraciÃƒÂ³n del pulso de 5 ciclos
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            pulse_counter <= 0;
            pulse_active <= '0';
        ELSIF rising_edge(clk) THEN
            IF tick = '1' THEN
                pulse_counter <= 1;
                pulse_active <= '1';
            ELSIF pulse_counter > 0 THEN
                pulse_counter <= pulse_counter + 1;
                IF pulse_counter = 5 THEN
                    pulse_counter <= 0;
                    pulse_active <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;

    signal_out <= pulse_active;

END ARCHITECTURE;