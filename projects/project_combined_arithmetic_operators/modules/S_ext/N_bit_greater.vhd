LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ===============================
-- COMPARADOR "MAYOR QUE" CON SIGNO
-- ===============================
ENTITY N_bit_greater IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Entradas de 10 bits
        GT : OUT STD_LOGIC -- '1' si A >= B, '0' en caso contrario
    );
END N_bit_greater;

ARCHITECTURE N_bit_greater_Arch OF N_bit_greater IS
BEGIN
    GT <= '1' WHEN (signed(A) >= signed(B)) ELSE
        '0';
END N_bit_greater_Arch;