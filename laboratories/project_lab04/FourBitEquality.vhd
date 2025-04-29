LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FourBitEquality IS
    PORT (
        x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        eq : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE FourBitEquality_Arch OF FourBitEquality IS
    SIGNAL eqs : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    --=========================================
    -- Instantiate N 1-bit Comparators
    --=========================================
    comp0 : ENTITY work.oneBitEquality
        PORT MAP(
            In0 => x(0),
            In1 => y(0),
            eq => eqs(0));

    comp1 : ENTITY work.oneBitEquality
        PORT MAP(
            In0 => x(1),
            In1 => y(1),
            eq => eqs(1));

    comp2 : ENTITY work.oneBitEquality
        PORT MAP(
            In0 => x(2),
            In1 => y(2),
            eq => eqs(2));

    comp3 : ENTITY work.oneBitEquality
        PORT MAP(
            In0 => x(3),
            In1 => y(3),
            eq => eqs(3));

    WITH eqs SELECT
        eq <= '1' WHEN "1111",
        '0' WHEN OTHERS;

END ARCHITECTURE FourBitEquality_Arch;