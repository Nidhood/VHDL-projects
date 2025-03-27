LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY counterGates IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        max_val : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- nuevo puerto
        q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        s : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- salida a display 7 segmentos
    );
END counterGates;

ARCHITECTURE gateLevel OF counterGates IS
    SIGNAL q0, q1, q2, q3 : STD_LOGIC;
    SIGNAL d0, d1, d2, d3 : STD_LOGIC;
    SIGNAL ena2, ena3 : STD_LOGIC;
    SIGNAL q_internal : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL q_neg : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL eq : STD_LOGIC; -- salida del comparador
    SIGNAL rst_internal : STD_LOGIC; -- reset generado internamente

BEGIN

    -- Negación de las salidas para formar las entradas D
    d0 <= NOT(q0);
    d1 <= NOT(q1);
    d2 <= NOT(q2);
    d3 <= NOT(q3);

    -- Lógica de habilitación
    ena2 <= q1 AND q0;
    ena3 <= q2 AND q1 AND q0;

    -- Construcción del vector de salida
    q_internal <= q3 & q2 & q1 & q0;
    q <= q_internal;

    -- Reset interno cuando el conteo alcanza el valor máximo
    rst_internal <= rst OR eq; -- combinación de reset externo con reset por igualdad

    -- Comparador: si q_internal = max_val => eq = '1'
    eq_comp : ENTITY work.FourBitEquality(FourBitEquality_Arch)
        GENERIC MAP(MAX_WIDTH => 4)
        PORT MAP(
            x => q_internal,
            y => max_val,
            eq => eq
        );

    -- Flip-flops
    bit0 : ENTITY work.my_dff
        PORT MAP(clk => clk, rst => rst_internal, ena => ena, d => d0, q => q0);

    bit1 : ENTITY work.my_dff
        PORT MAP(clk => clk, rst => rst_internal, ena => q0, d => d1, q => q1);

    bit2 : ENTITY work.my_dff
        PORT MAP(clk => clk, rst => rst_internal, ena => ena2, d => d2, q => q2);

    bit3 : ENTITY work.my_dff
        PORT MAP(clk => clk, rst => rst_internal, ena => ena3, d => d3, q => q3);

    -- Negación para el display
    q_neg <= NOT q_internal;

    -- Display de 7 segmentos
    sseg_inst : ENTITY work.bin_to_7seg
        PORT MAP(x => q_internal, sseg => s);

END ARCHITECTURE;