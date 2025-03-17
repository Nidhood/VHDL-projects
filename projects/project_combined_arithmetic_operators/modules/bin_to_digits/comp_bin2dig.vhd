LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- ==============================================================================================
-- COMPARADOR BINARIO A DÍGITOS (AHORA PARA 10 BITS)
-- ==============================================================================================
ENTITY comp_bin2dig IS
    PORT (
        Ans : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Entrada de 10 bits
        Comp : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Valor con el que se compara
        Val_out : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- Valor de salida (10 bits)
        Val_sum : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- Valor ajustado según comparación
        GT_out : OUT STD_LOGIC
    );
END ENTITY comp_bin2dig;

-- ==============================================================================================
-- ARQUITECTURA COMPARADOR BINARIO A DÍGITOS (10 BITS)
-- ==============================================================================================
ARCHITECTURE comp_bin2dig_Arch OF comp_bin2dig IS
    SIGNAL Temp1 : STD_LOGIC_VECTOR(9 DOWNTO 0); -- Resultado de la resta (10 bits)
    SIGNAL Carry1 : STD_LOGIC; -- Bit de acarreo (1 bit)
    SIGNAL GT1 : STD_LOGIC; -- Bit de comparación (1 bit)
BEGIN

    -- ============================
    -- RESTA ENTRE "Ans" Y "Comp"
    -- ============================
    Sum2 : ENTITY WORK.full_adder_substractor(full_adder_substractor_Arch)
        PORT MAP(
            OP => '1', -- Operación de resta
            A => Ans, -- Entrada de 10 bits
            B => Comp, -- Entrada de 10 bits
            R => Temp1, -- Resultado de la resta (10 bits)
            COUT => Carry1 -- Bit de acarreo
        );

    -- ============================
    -- COMPARADOR MAYOR O MENOR A 0 
    -- ============================
    Comp1 : ENTITY WORK.N_bit_greater(N_bit_greater_Arch)
        PORT MAP(
            A => Temp1, -- Ahora 11 bits (Carry1 + Temp1)
            B => "0000000000", -- Comparación con 0 (11 bits de ceros)
            GT => GT1 -- Resultado de la comparación
        );

    -- ============================
    -- SELECCIÓN DE VALOR DE SALIDA
    -- ============================
    Val_out <= Temp1 WHEN (GT1 = '1') ELSE
        Ans;
    GT_out <= GT1;
    -- ===========================================
    -- ASIGNACIÓN PARA LA SUMA SEGUN VALOR DE COMP
    -- ===========================================
    Val_sum <= "0111" WHEN (GT1 = '1' AND (Comp = "0001000110" OR Comp = "0000000111")) ELSE
        "0100" WHEN (GT1 = '1' AND (Comp = "0000101000" OR Comp = "0000000100")) ELSE
        "0010" WHEN (GT1 = '1' AND (Comp = "0011001000" OR Comp = "0000010100" OR Comp = "0000000010")) ELSE
        "0001" WHEN (GT1 = '1' AND (Comp = "0001100100" OR Comp = "0000001010" OR Comp = "0000000001")) ELSE
        "0000"; -- Si GT1 = '0', Val_sum es 0

END ARCHITECTURE comp_bin2dig_Arch;