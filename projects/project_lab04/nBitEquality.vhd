LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nBitEquality IS
    GENERIC (MAX_WIDTH : INTEGER := 4);
    PORT (
        x : IN STD_LOGIC_VECTOR(MAX_WIDTH - 1 DOWNTO 0);
        y : IN STD_LOGIC_VECTOR(MAX_WIDTH - 1 DOWNTO 0);
        eq : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE structural OF nBitEquality IS
    SIGNAL eqs : STD_LOGIC_VECTOR(MAX_WIDTH - 1 DOWNTO 0);
BEGIN

    --=========================================
    -- Instantiate N 1-bit Comparators
    --=========================================
    comparators : FOR i IN 0 TO MAX_WIDTH - 1 GENERATE
        comp : ENTITY work.oneBitEquality
            PORT MAP(
                input_0 => x(i),
                input_1 => y(i),
                eq => eqs(i));
    END GENERATE;

    --=========================================
    -- Instantiate andReduction
    --=========================================
    andRed : ENTITY work.andReduction
        GENERIC MAP(MAX_WIDTH => MAX_WIDTH)
        PORT MAP(
            inVector => eqs,
            q => eq);

END ARCHITECTURE;