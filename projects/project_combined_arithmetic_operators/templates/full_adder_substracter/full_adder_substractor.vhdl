LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- ==========================
-- ENTIDAD DEL SUMADOR-RESTADOR
-- ==========================
ENTITY FULL_ADDER_SUBSTRACTOR IS
    PORT ( 
        OP        : IN  STD_LOGIC;                      -- 0 = Suma, 1 = Resta
        A, B      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Entradas de 4 bits
        R         : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Resultado de la operación
        COUT, OVERFLOW : OUT STD_LOGIC                 -- Carry y Overflow
    );
END ENTITY FULL_ADDER_SUBSTRACTOR;

-- ==========================
-- ARQUITECTURA DEL SUMADOR-RESTADOR
-- ==========================
ARCHITECTURE STRUCT OF FULL_ADDER_SUBSTRACTOR IS

    -- Declaración del componente Full Adder
    COMPONENT FULL_ADDER IS
        PORT ( 
            X, Y, CIN  : IN  STD_LOGIC;  -- Entradas
            SUM, COUT  : OUT STD_LOGIC   -- Suma y Carry out
        );
    END COMPONENT;

    -- Señales internas
    SIGNAL C1, C2, C3, C4 : STD_LOGIC;                   -- Acarreos internos
    SIGNAL TMP            : STD_LOGIC_VECTOR(3 DOWNTO 0); -- XOR para suma/resta
    SIGNAL R_int          : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Señal interna para R

BEGIN

    -- ==========================
    -- OPERACIÓN: SUMA O RESTA
    -- ==========================
    TMP <= B XOR (OP & OP & OP & OP);  -- Si OP=1, invierte B (Complemento a 2)
    
    -- ==========================
    -- INSTANCIAS DE FULL ADDER (SUMADOR EN CASCADA)
    -- ==========================

    -- Bit 0 (LSB)
    FA0 : FULL_ADDER PORT MAP ( 
        A(0), TMP(0), OP, 
        R_int(0), C1
    );

    -- Bit 1
    FA1 : FULL_ADDER PORT MAP ( 
        A(1), TMP(1), C1, 
        R_int(1), C2
    );

    -- Bit 2
    FA2 : FULL_ADDER PORT MAP ( 
        A(2), TMP(2), C2, 
        R_int(2), C3
    );

    -- Bit 3 (MSB)
    FA3 : FULL_ADDER PORT MAP ( 
        A(3), TMP(3), C3, 
        R_int(3), C4
    );

    -- ==========================
    -- ASIGNACIÓN DE LA SALIDA R
    -- ==========================
    R <= R_int;  -- Asigna la señal interna a la salida

    -- ==========================
    -- CORRECCIÓN DE OVERFLOW Y COUT
    -- ==========================
    OVERFLOW <= (A(3) XOR TMP(3)) AND (A(3) XOR R_int(3));  -- Detección de Overflow en suma/resta
    COUT <= C4 WHEN OP = '0' ELSE NOT C4;  -- Carry correcto en suma/resta

END ARCHITECTURE STRUCT;
