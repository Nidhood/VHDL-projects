LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY univ_bin_counter IS
    GENERIC (N : INTEGER := 4);
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        syn_clr : IN STD_LOGIC;
        load : IN STD_LOGIC;--
        up : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        max_val : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        max_tick : OUT STD_LOGIC;--
        min_tick : OUT STD_LOGIC;--
        counter : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END univ_bin_counter;

ARCHITECTURE rtl OF univ_bin_counter IS
    CONSTANT zeros : unsigned(N - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL count_s : unsigned(N - 1 DOWNTO 0);
    SIGNAL count_next : unsigned(N - 1 DOWNTO 0);
    SIGNAL max_u : unsigned(N - 1 DOWNTO 0);

BEGIN
    -- Convertir max_val a formato unsigned
    max_u <= unsigned(max_val);

    -- NEXT STATE LOGIC    
    count_next <=
        (OTHERS => '0') WHEN syn_clr = '1' ELSE
        unsigned(d) WHEN load = '1' ELSE
        (zeros) WHEN (ena = '1' AND up = '1' AND count_s = max_u) ELSE
        (count_s + 1) WHEN (ena = '1' AND up = '1') ELSE
        (count_s - 1) WHEN (ena = '1' AND up = '0' AND count_s > zeros) ELSE
        count_s;

    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            count_s <= (OTHERS => '0');
        ELSIF (rising_edge(clk)) THEN
            IF (ena = '1') THEN
                count_s <= count_next;
            END IF;
        END IF;
    END PROCESS;

    -- Asignacion de salida
    counter <= STD_LOGIC_VECTOR(count_s);

    -- Activacion de max_tick cuando se alcanza el valor máximo
    max_tick <= '1' WHEN (count_s = max_u) ELSE
        '0';

    -- Activacion de min_tick cuando el contador está en 0
    min_tick <= '1' WHEN (count_s = zeros) ELSE
        '0';

END ARCHITECTURE;