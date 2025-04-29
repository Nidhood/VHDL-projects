LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY tb_univ_bin_counter_max IS
END ENTITY tb_univ_bin_counter_max;

ARCHITECTURE sim OF tb_univ_bin_counter_max IS

    CONSTANT N : INTEGER := 4;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC;
    SIGNAL ena : STD_LOGIC;
    SIGNAL syn_clr : STD_LOGIC;
    SIGNAL load : STD_LOGIC;
    SIGNAL up : STD_LOGIC;
    SIGNAL d : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL max_val : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL max_tick : STD_LOGIC;
    SIGNAL min_tick : STD_LOGIC;
    SIGNAL counter : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

BEGIN

    -- Instantiation of the controlled counter (univ_bin_counter_max)
    X : ENTITY WORK.univ_bin_counter_max(rtl)
        GENERIC MAP(
            N => N
        )
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

    -- Clock generation: period = 10 ns (5 ns high, 5 ns low)
    clk <= NOT clk AFTER 5 ns;

    -- Test 1: Reset pulse (active high) from 0 ns to 15 ns
    rst <= '1' AFTER 0 ns, '0' AFTER 15 ns;

    -- Test 2: Enable signal active; then pause and resume
    ena <= '1' AFTER 0 ns,
        '0' AFTER 70 ns,
        '1' AFTER 90 ns;

    -- Test 3: Synchronous clear pulse (syn_clr) active for one cycle at 150 ns
    syn_clr <= '0' AFTER 0 ns,
        '1' AFTER 150 ns,
        '0' AFTER 160 ns;

    -- Test 4: Load pulse to load a specific value
    load <= '0' AFTER 0 ns,
        '1' AFTER 110 ns, -- Activate load at 110 ns
        '0' AFTER 120 ns;

    -- Value to load (d): changes at 110 ns for load operation
    d <= "0011" AFTER 0 ns,
        "1010" AFTER 110 ns;

    -- Test 5: Counting direction: initially ascending, then descending
    up <= '1' AFTER 0 ns,
        '0' AFTER 200 ns; -- Change to descending at 200 ns

    -- Test 6: Controlled maximum value assignment
    -- Initially, maximum value is set to "0101" (5 decimal)
    -- Then changed to "0011" (3 decimal) and later to "1000" (8 decimal)
    max_val <= "0101" AFTER 0 ns,
        "0011" AFTER 250 ns,
        "1000" AFTER 350 ns;
END ARCHITECTURE sim;