LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- ===============================
-- COMPARADOR "MAYOR QUE" CON SIGNO
-- ===============================
ENTITY N_bit_greater IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Entrada de 10 bits
        GT : OUT STD_LOGIC -- Salida: 1 si A > B, 0 en caso contrario
    );
END ENTITY N_bit_greater;

ARCHITECTURE N_bit_greater_Arch OF N_bit_greater IS
BEGIN
    -- Convierte A y B a tipo SIGNED y realiza la comparación
    GT <= '1' WHEN (SIGNED(A) >= SIGNED(B)) ELSE
        '0';
END ARCHITECTURE N_bit_greater_Arch;