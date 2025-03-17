LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ===============================
-- SIGN EXTENDED
-- ===============================
ENTITY S_ext IS
    PORT (
        S : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Resultado 4 Bits
        C : IN STD_LOGIC;
        OP : IN STD_LOGIC;
        R : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) -- Salida con signo de 9 bits                      
    );
END ENTITY S_ext;

ARCHITECTURE S_ext_Arch OF S_ext IS
    SIGNAL sum : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL res : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL GT1 : STD_LOGIC;
    SIGNAL aux : STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN

    aux <= "000000" & S(3 DOWNTO 0) WHEN S(3) = '0' ELSE
        "111111" & S(3 DOWNTO 0);

    Comp1 : ENTITY WORK.N_bit_greater(N_bit_greater_Arch)
        PORT MAP(
            A => aux,
            B => "0000000000", -- Comparación con 0 (11 bits de ceros)
            GT => GT1 -- Resultado de la comparación
        );

    res <= ("000000" & S) WHEN (GT1 = '1') ELSE
        ("111111" & S);

    sum <= "00000" & C & S;

    R <= sum WHEN Op = '0' ELSE
        res;
END ARCHITECTURE S_ext_Arch;