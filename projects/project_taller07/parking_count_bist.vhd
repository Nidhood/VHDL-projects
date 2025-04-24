LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY parking_count_bist IS
    GENERIC (delay_pulses : INTEGER := 8);
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        car_enter : IN STD_LOGIC;
        car_exit : IN STD_LOGIC;
        parking_full : IN STD_LOGIC;
        s0 : OUT STD_LOGIC;
        s1 : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE bist_arch OF parking_count_bist IS

    TYPE state IS (ini, inc_sequence, s0_st, s1_st, s0s1_st);
    SIGNAL state_pr, state_next : state;
    SIGNAL SEQUENCE : UNSIGNED (2 DOWNTO 0);
    SIGNAL go_counter : STD_LOGIC;
    SIGNAL sync_reset_counter : STD_LOGIC;
    SIGNAL max_tick : STD_LOGIC;
    SIGNAL increment_tick : STD_LOGIC;
    SIGNAL delay_counter_signal : INTEGER;
BEGIN

    --=========================================================================
    -- Delay Counter Process
    --=========================================================================

    delay_counter : PROCESS (clk, rst, go_counter, sync_reset_counter)
    BEGIN
        IF (rst = '1') THEN
            max_tick <= '0';
            delay_counter_signal <= 0;
        ELSIF (RISING_EDGE(clk)) THEN
            IF (sync_reset_counter = '1') THEN
                max_tick <= '0';
                delay_counter_signal <= 0;
            ELSIF (go_counter = '1') THEN
                IF (delay_counter_signal < delay_pulses - 1) THEN
                    delay_counter_signal <= delay_counter_signal + 1;
                    max_tick <= '0';
                ELSE
                    delay_counter_signal <= 0;
                    max_tick <= '1';
                END IF;
            END IF;
        END IF;
    END PROCESS;

    --=========================================================================
    -- Sequence Counter Process
    --=========================================================================

    sequence_counter : PROCESS (clk, rst, increment_tick, SEQUENCE)
    BEGIN
        IF (rst = '1') THEN
            SEQUENCE <= "000";
        ELSIF (RISING_EDGE(clk)) THEN
            IF (increment_tick = '1') THEN
                IF (SEQUENCE < 3) THEN
                    SEQUENCE <= SEQUENCE +1;
                ELSE
                    SEQUENCE <= "000";
                END IF;
            ELSE
                SEQUENCE <= SEQUENCE;
            END IF;
        END IF;
    END PROCESS;
    --=========================================================================
    -- Sequential Part FSM
    --=========================================================================
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            state_pr <= ini;
        ELSIF rising_edge(clk) THEN
            state_pr <= state_next;
        END IF;
    END PROCESS;

    --=========================================================================
    -- Combinational Part FSM
    --=========================================================================

    combinational : PROCESS (state_pr, car_enter, car_exit, max_tick, SEQUENCE, parking_full)
    BEGIN
        CASE state_pr IS
            WHEN ini =>
                go_counter <= '1';
                sync_reset_counter <= '0';
                s0 <= '0';
                s1 <= '0';
                increment_tick <= '0';
                IF (max_tick = '1') THEN
                    IF (SEQUENCE = 0) THEN
                        state_next <= s0_st;
                    ELSIF (SEQUENCE = 1) THEN
                        state_next <= s1_st;
                    ELSIF (SEQUENCE = 2) THEN
                        state_next <= s0_st;
                    ELSIF (SEQUENCE = 3) THEN
                        state_next <= s1_st;
                    ELSE
                        state_next <= ini;
                    END IF;
                ELSE
                    state_next <= ini;
                END IF;

            WHEN inc_sequence =>
                go_counter <= '0';
                sync_reset_counter <= '0';
                s0 <= '0';
                s1 <= '1';
                increment_tick <= '1';
                state_next <= ini;
            WHEN s0_st =>
                go_counter <= '0';
                sync_reset_counter <= '1';
                s0 <= '1';
                s1 <= '0';
                increment_tick <= '0';
                IF ((parking_full = '1') AND (SEQUENCE = 0)) THEN
                    state_next <= inc_sequence;
                ELSIF (SEQUENCE = 0) THEN
                    state_next <= s0s1_st;
                ELSIF (SEQUENCE = 2) THEN
                    state_next <= inc_sequence;
                ELSE
                    state_next <= ini;
                END IF;

            WHEN s1_st =>
                go_counter <= '0';
                sync_reset_counter <= '1';
                s0 <= '0';
                s1 <= '1';
                increment_tick <= '0';
                IF ((parking_full = '0') AND (SEQUENCE /= 0)) THEN
                    state_next <= inc_sequence;
                ELSIF (SEQUENCE = 1) THEN
                    state_next <= s0s1_st;
                ELSIF (SEQUENCE = 3) THEN
                    state_next <= inc_sequence;
                ELSE
                    state_next <= ini;
                END IF;

            WHEN s0s1_st =>
                go_counter <= '0';
                sync_reset_counter <= '1';
                s0 <= '1';
                s1 <= '1';
                increment_tick <= '0';
                IF (SEQUENCE = 0) THEN
                    state_next <= s1_st;
                ELSIF (SEQUENCE = 1) THEN
                    state_next <= s0_st;
                ELSE
                    state_next <= s0s1_st;
                END IF;
        END CASE;
    END PROCESS;

END ARCHITECTURE;