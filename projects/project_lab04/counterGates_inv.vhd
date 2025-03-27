LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------
ENTITY counterGates IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        ena : IN STD_LOGIC;
        q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        s : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) -- salida a display 7 segmentos
    );
END counterGates;
-------------------------------
ARCHITECTURE gateLevel OF counterGates IS
    SIGNAL q0 : STD_LOGIC;
    SIGNAL q1 : STD_LOGIC;
    SIGNAL q2 : STD_LOGIC;
    SIGNAL q3 : STD_LOGIC;

    SIGNAL d0 : STD_LOGIC;
    SIGNAL d1 : STD_LOGIC;
    SIGNAL d2 : STD_LOGIC;
    SIGNAL d3 : STD_LOGIC;

    SIGNAL ena2 : STD_LOGIC;
    SIGNAL ena3 : STD_LOGIC;

    SIGNAL q_internal : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL q_inv : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    -- Data signal is q negated
    d0 <= NOT(q0);
    d1 <= NOT(q1);
    d2 <= NOT(q2);
    d3 <= NOT(q3);

    -- Logic to obtain the enable signals
    ena2 <= q1 AND q0;
    ena3 <= q2 AND q1 AND q0;

    -- Output concatenation
    q_internal <= q3 & q2 & q1 & q0;
    q <= q_internal;

    -- DFF instantiation
    bit0 : ENTITY work.my_dff
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => ena,
            d => d0,
            q => q0);

    bit1 : ENTITY work.my_dff
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => q0,
            d => d1,
            q => q1);

    bit2 : ENTITY work.my_dff
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => ena2,
            d => d2,
            q => q2);

    bit3 : ENTITY work.my_dff
        PORT MAP(
            clk => clk,
            rst => rst,
            ena => ena3,
            d => d3,
            q => q3);

    q_neg <= NOT q_internal;

    -- Instancia del codificador a display de 7 segmentos
    sseg_inst : ENTITY work.bin_to_7seg
        PORT MAP(
            x => q_neg,
            sseg => s
        );

END ARCHITECTURE;