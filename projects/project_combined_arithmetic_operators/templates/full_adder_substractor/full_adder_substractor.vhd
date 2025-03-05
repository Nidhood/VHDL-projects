LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- ==========================
-- ENTIDAD DEL SUMADOR-RESTADOR
-- ==========================
ENTITY full_adder_substractor IS
    PORT (
        A_or_S : IN STD_LOGIC; -- 0 = Suma, 1 = Resta
        X, Y : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Entradas de 4 bits
        S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- Resultado de la operación
        COUT, OVERFLOW : OUT STD_LOGIC -- Carry y Overflow
    );
END ENTITY full_adder_substractor;

-- ==========================
-- ARQUITECTURA DEL SUMADOR-RESTADOR
-- ==========================
ARCHITECTURE full_adder_substractor_arch OF full_adder_substractor IS

    -- Declaración del componente Full Adder
    COMPONENT full_adder IS
        PORT (
            A, B, Cin : IN STD_LOGIC; -- Entradas
            S, Cout : OUT STD_LOGIC -- Suma y Carry out
        );
    END COMPONENT;

    -- Señales internas
    SIGNAL C1, C2, C3, C4 : STD_LOGIC; -- Acarreos internos
    SIGNAL TMP : STD_LOGIC_VECTOR(3 DOWNTO 0); -- XOR para suma/resta
    SIGNAL S_int : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Señal interna para R

BEGIN

    -- ==========================
    -- OPERACIÓN: SUMA O RESTA
    -- ==========================
    TMP <= Y XOR (A_or_S & A_or_S & A_or_S & A_or_S); -- Si OP=1, invierte B (Complemento a 2)

    -- ==========================
    -- INSTANCIAS DE FULL ADDER (SUMADOR EN CASCADA)
    -- ==========================

    -- Bit 0 (LSB)
    FA0 : full_adder PORT MAP(
        X(0), TMP(0), A_or_S,
        S_int(0), C1
    );

    -- Bit 1
    FA1 : full_adder PORT MAP(
        X(1), TMP(1), C1,
        S_int(1), C2
    );

    -- Bit 2
    FA2 : full_adder PORT MAP(
        X(2), TMP(2), C2,
        S_int(2), C3
    );

    -- Bit 3 (MSB)
    FA3 : full_adder PORT MAP(
        X(3), TMP(3), C3,
        S_int(3), C4
    );

    -- ==========================
    -- ASIGNACIÓN DE LA SALIDA R
    -- ==========================
    S <= S_int; -- Asigna la señal interna a la salida

    -- ==========================
    -- CORRECCIÓN DE OVERFLOW Y COUT
    -- ==========================
    OVERFLOW <= (X(3) XOR TMP(3)) AND (X(3) XOR S_int(3)); -- Detección de Overflow en suma/resta
    COUT <= C4 WHEN A_or_S = '0' ELSE
        NOT C4; -- Carry correcto en suma/resta

END ARCHITECTURE full_adder_substractor_arch;