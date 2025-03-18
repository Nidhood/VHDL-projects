LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

------------------------------------------------------------------------
-- Entidad: power_3cases
-- Descripción: Calcula X^Y SOLO para Y = 0, 1 o 2. 
--              Para otros valores de Y, la salida es "1111111111".
-- Entradas: 
--   - X: 4 bits (unsigned)
--   - Y: 4 bits (unsigned) 
-- Salida:
--   - S: 10 bits
------------------------------------------------------------------------
ENTITY power_3cases IS
    PORT (
        X : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        S : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END ENTITY power_3cases;

------------------------------------------------------------------------
-- Arquitectura: sin for ni if
-- Se emplea 'with ... select' y la multiplicación directa para X^2.
------------------------------------------------------------------------
ARCHITECTURE no_if_for_arch OF power_3cases IS

    -- Convertimos X a 'unsigned' de 10 bits para concatenarlo sin if.
    SIGNAL x_10 : unsigned(9 DOWNTO 0);
    SIGNAL x2_10 : unsigned(9 DOWNTO 0);

BEGIN
    -- 1) Expandimos X a 10 bits sin signo.
    x_10 <= resize(unsigned(X), 10);

    -- 2) Calculamos X^2 => (X * X), también en 10 bits.
    x2_10 <= resize(unsigned(X) * unsigned(X), 10);

    --------------------------------------------------------------------
    -- 3) Con Y, se selecciona la salida:
    --    - "0000" => X^0 = 1  (10 bits: "0000000001")
    --    - "0001" => X^1 = X  (10 bits, expandido)
    --    - "0010" => X^2
    --    - others => "1111111111"
    --------------------------------------------------------------------
    WITH Y SELECT
        S <= "0000000001" WHEN "0000", -- X^0 = 1
        STD_LOGIC_VECTOR(x_10) WHEN "0001", -- X^1 = X
        STD_LOGIC_VECTOR(x2_10) WHEN "0010", -- X^2 = X*X
        "1111111111" WHEN OTHERS; -- Valor por defecto

END ARCHITECTURE no_if_for_arch;