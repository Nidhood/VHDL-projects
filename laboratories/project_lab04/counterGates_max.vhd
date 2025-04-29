LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counterGates_max IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        max_val : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        n : IN STD_LOGIC; -- '0' = incremento, '1' = decremento (invertido en display)
        q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        s : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END counterGates_max;

ARCHITECTURE gateLevel OF counterGates_max IS
    SIGNAL q0, q1, q2, q3 : STD_LOGIC;
    SIGNAL d0, d1, d2, d3 : STD_LOGIC;
    SIGNAL ena2, ena3 : STD_LOGIC;
    SIGNAL q_internal : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL q_neg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL sseg_data : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL eq, eq_d : STD_LOGIC := '0';
    SIGNAL rst_internal : STD_LOGIC;
    SIGNAL max_int : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    -- Entradas D de los FF tipo T
    d0 <= NOT(q0);
    d1 <= NOT(q1);
    d2 <= NOT(q2);
    d3 <= NOT(q3);

    -- Habilitaciones
    ena2 <= q1 AND q0;
    ena3 <= q2 AND q1 AND q0;

    -- Construcción de salida
    q_internal <= q3 & q2 & q1 & q0;
    q <= q_internal;

    -- Prevenir que max_val sea 0000
    PROCESS (max_val)
    BEGIN
        IF max_val = "0000" THEN
            max_int <= "0001"; -- evita bloqueo
        ELSE
            -- Inversión de bits si switches están al revés (SW0 = MSB)
            max_int(3) <= max_val(0);
            max_int(2) <= max_val(1);
            max_int(1) <= max_val(2);
            max_int(0) <= max_val(3);
        END IF;
    END PROCESS;

    -- Comparación directa con max_int
    comparacion : ENTITY work.FourBitEquality(FourBitEquality_Arch)
        PORT MAP(
            x => q_internal,
            y => max_int,
            eq => eq
        );

    -- Retardo de un ciclo para permitir visualizar el máximo
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            eq_d <= eq;
        END IF;
    END PROCESS;

    rst_internal <= rst OR eq_d;

    -- Flip-flops tipo T usando D flip-flops
    bit0 : ENTITY work.my_dff
        PORT MAP(clk => clk, rst => rst_internal, ena => ena, d => d0, q => q0);

    bit1 : ENTITY work.my_dff
        PORT MAP(clk => clk, rst => rst_internal, ena => q0, d => d1, q => q1);

    bit2 : ENTITY work.my_dff
        PORT MAP(clk => clk, rst => rst_internal, ena => ena2, d => d2, q => q2);

    bit3 : ENTITY work.my_dff
        PORT MAP(clk => clk, rst => rst_internal, ena => ena3, d => d3, q => q3);

    -- Conteo negado para visualización decreciente
    q_neg <= NOT q_internal;

    -- Multiplexor: escoge entre conteo normal o invertido para el display
    PROCESS (q_internal, q_neg, n)
    BEGIN
        IF n = '1' THEN
            sseg_data <= q_neg; -- modo decremental
        ELSE
            sseg_data <= q_internal; -- modo incremental
        END IF;
    END PROCESS;

    -- Display de 7 segmentos
    sseg_inst : ENTITY work.bin_to_7seg
        PORT MAP(x => sseg_data, sseg => s);

END ARCHITECTURE;