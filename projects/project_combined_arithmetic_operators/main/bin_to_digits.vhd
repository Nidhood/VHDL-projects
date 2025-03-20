--------------------------------------------------------------------------------- 
--    Descripcion: Converts a 10-bit binary number to 3 4-bit binary numbers.  --
--    Author: Jeronimo Rueda                                                   --
--    Date: 11/03/2025                                                         --
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------------------------------
ENTITY bin_to_digits IS
    PORT (
        R : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        B1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        B2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        B3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        H1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        H2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        H3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        S : OUT STD_LOGIC
    );
END ENTITY bin_to_digits;

ARCHITECTURE bin_to_digits_Arch OF bin_to_digits IS

    SIGNAL P0, P1, P2, P3, P4, P5, P6, P7, P8, P9 : STD_LOGIC_VECTOR(9 DOWNTO 0);

    SIGNAL Sum1, Sum2, Sum3, Sum4, Sum5, Sum6, Sum7, Sum8, Sum9, Sum10 : STD_LOGIC_VECTOR(3 DOWNTO 0);

    SIGNAL GT1, GT2, GT3, GT4, GT5, GT6, GT7, GT8, GT9, GT10 : STD_LOGIC;

    SIGNAL Cent, Dec1, Dec2, Dec, Un1, Un2, Un : STD_LOGIC_VECTOR(9 DOWNTO 0);

    SIGNAL Carry1, Carry2, Carry3, Carry4, Carry5, Carry6, Carry7 : STD_LOGIC;

    SIGNAL Sum1e, Sum2e, Sum3e, Sum4e, Sum5e, Sum6e, Sum7e, Sum8e, Sum9e, Sum10e : STD_LOGIC_VECTOR(9 DOWNTO 0); -- Variable extendida a 10 bits

    SIGNAL Rf : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN
    S <= '1' WHEN (R(9) = '1') ELSE
        '0';

    Rf <= STD_LOGIC_VECTOR(-SIGNED(R)) WHEN R(9) = '1' ELSE
        STD_LOGIC_VECTOR(SIGNED(R));
    -- ==========================================================================================================
    --                                            BIN_TO_HEX_DIGITS 
    -- ==========================================================================================================

    H1 <= "000" & R(8);
    H2 <= R(7 DOWNTO 4);
    H3 <= R(3 DOWNTO 0);

    Comp1 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => Rf,
            Comp => "0011001000",
            Val_out => P0,
            Val_sum => Sum1,
            GT_out => GT1
        );

    Comp2 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => P0,
            Comp => "0001100100",
            Val_out => P1,
            Val_sum => Sum2,
            GT_out => GT2
        );
    Sum1e <= "000000" & Sum1;
    Sum2e <= "000000" & Sum2;

    Sumador1 : ENTITY WORK.full_adder_substractor_10(STRUCT)
        PORT MAP(
            OP => '0',
            A => Sum1e,
            B => Sum2e,
            R => Cent,
            COUT => Carry1
        );

    B1 <= Cent(3 DOWNTO 0);

    Comp3 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => P1, -- Resultado 
            Comp => "0001000110", -- Comparación 70
            Val_out => P2, -- Valor que continua en operacion
            Val_sum => Sum3, -- Valor que se suma para decenas
            GT_out => GT3 -- Bit Greater Than 
        );
    Comp4 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => P2, -- Resultado 
            Comp => "0000101000", -- Comparación 40
            Val_out => P3, -- Valor que continua en operacion
            Val_sum => Sum4, -- Valor que se suma para decenas
            GT_out => GT4 -- Bit Greater Than 
        );

    Comp5 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => P3, -- Resultado 
            Comp => "0000010100", -- Comparación 20
            Val_out => P4, -- Valor que continua en operacion
            Val_sum => Sum5, -- Valor que se suma para decenas
            GT_out => GT5 -- Bit Greater Than 
        );
    Comp6 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => P4, -- Resultado 
            Comp => "0000001010", -- Comparación 10
            Val_out => P5, -- Valor que continua en operacion
            Val_sum => Sum6, -- Valor que se suma para decenas
            GT_out => GT6 -- Bit Greater Than 
        );
    Sum3e <= "000000" & Sum3;
    Sum4e <= "000000" & Sum4;
    Sum5e <= "000000" & Sum5;
    Sum6e <= "000000" & Sum6;

    -- SUMAS DECENAS 
    --SUMA 1
    Sumador2 : ENTITY WORK.full_adder_substractor_10(STRUCT)
        PORT MAP(
            OP => '0', -- Operación de Suma
            A => Sum3e, -- Entrada de 10 bits
            B => Sum4e, -- Entrada de 10 bits
            R => Dec1, -- Resultado de la resta (10 bits)
            COUT => Carry2 -- Bit de acarreo
        );
    --SUMA 2
    Sumador3 : ENTITY WORK.full_adder_substractor_10(STRUCT)
        PORT MAP(
            OP => '0', -- Operación de Suma
            A => Dec1, -- Entrada de 10 bits
            B => Sum5e, -- Entrada de 10 bits
            R => Dec2, -- Resultado de la resta (10 bits)
            COUT => Carry3 -- Bit de acarreo
        );
    --SUMA 3
    Sumador4 : ENTITY WORK.full_adder_substractor_10(STRUCT)
        PORT MAP(
            OP => '0', -- Operación de Suma
            A => Dec2, -- Entrada de 10 bits
            B => Sum6e, -- Entrada de 10 bits
            R => Dec, -- Resultado de la resta (10 bits)
            COUT => Carry4 -- Bit de acarreo
        );

    B2 <= Dec(3 DOWNTO 0);
    -- =====================================================
    --                  UNIDADES
    -- =====================================================

    Comp7 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => P5, -- Resultado 
            Comp => "0000000111", -- Comparación 7
            Val_out => P6, -- Valor que continua en operacion
            Val_sum => Sum7, -- Valor que se suma para unidades
            GT_out => GT7 -- Bit Greater Than 
        );
    Comp8 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => P6, -- Resultado 
            Comp => "0000000100", -- Comparación 4
            Val_out => P7, -- Valor que continua en operacion
            Val_sum => Sum8, -- Valor que se suma para unidades
            GT_out => GT8 -- Bit Greater Than 
        );

    Comp9 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => P7, -- Resultado 
            Comp => "0000000010", -- Comparación 2
            Val_out => P8, -- Valor que continua en operacion
            Val_sum => Sum9, -- Valor que se suma para unidades
            GT_out => GT9 -- Bit Greater Than 
        );
    Comp10 : ENTITY WORK.comp_bin2dig(comp_bin2dig_Arch)
        PORT MAP(
            Ans => P8, -- Resultado 
            Comp => "0000000001", -- Comparación 1
            Val_out => P9, -- Valor que continua en operacion
            Val_sum => Sum10, -- Valor que se suma para unidades
            GT_out => GT10 -- Bit Greater Than 
        );

    Sum7e <= "000000" & Sum7;
    Sum8e <= "000000" & Sum8;
    Sum9e <= "000000" & Sum9;
    Sum10e <= "000000" & Sum10;

    -- SUMAS UNIDADES 
    --SUMA 1
    Sumador5 : ENTITY WORK.full_adder_substractor_10(STRUCT)
        PORT MAP(
            OP => '0', -- Operación de Suma
            A => Sum7e, -- Entrada de 10 bits
            B => Sum8e, -- Entrada de 10 bits
            R => Un1, -- Resultado de la resta (10 bits)
            COUT => Carry5 -- Bit de acarreo
        );
    --SUMA 2
    Sumador6 : ENTITY WORK.full_adder_substractor_10(STRUCT)
        PORT MAP(
            OP => '0', -- Operación de Suma
            A => Un1, -- Entrada de 10 bits
            B => Sum9e, -- Entrada de 10 bits
            R => Un2, -- Resultado de la resta (10 bits)
            COUT => Carry6 -- Bit de acarreo
        );
    --SUMA 3
    Sumador7 : ENTITY WORK.full_adder_substractor_10(STRUCT)
        PORT MAP(
            OP => '0', -- Operación de Suma
            A => Un2, -- Entrada de 10 bits
            B => Sum10e, -- Entrada de 10 bits
            R => Un, -- Resultado de la resta (10 bits)
            COUT => Carry7 -- Bit de acarreo
        );

    B3 <= Un(3 DOWNTO 0);

END ARCHITECTURE bin_to_digits_Arch;