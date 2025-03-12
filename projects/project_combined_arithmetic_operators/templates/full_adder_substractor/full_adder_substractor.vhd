LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- ==========================
-- ENTIDAD DEL SUMADOR-RESTADOR DE 9 BITS
-- ==========================
ENTITY FULL_ADDER_SUBSTRACTOR IS
    PORT ( 
        OP        : IN  STD_LOGIC;                      -- 0 = Suma, 1 = Resta
        A, B      : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Entradas de 9 bits
        R         : OUT STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Resultado de la operación
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
    SIGNAL C : STD_LOGIC_VECTOR(8 DOWNTO 0);  -- Acarreos internos
    SIGNAL TMP : STD_LOGIC_VECTOR(8 DOWNTO 0); -- XOR para suma/resta
    SIGNAL R_int : STD_LOGIC_VECTOR(8 DOWNTO 0); -- Señal interna para R

BEGIN

    -- ==========================
    -- OPERACIÓN: SUMA O RESTA
    -- ==========================
    TMP <= B XOR (OP & OP & OP & OP & OP & OP & OP & OP & OP);  -- Si OP=1, invierte B (Complemento a 2)
    
    -- ==========================
    -- INSTANCIAS DE FULL ADDER (SUMADOR EN CASCADA)
    -- ==========================

    FA0 : FULL_ADDER PORT MAP (A(0), TMP(0), OP, R_int(0), C(0));
    
    FA1 : FULL_ADDER PORT MAP (A(1), TMP(1), C(0), R_int(1), C(1));
    FA2 : FULL_ADDER PORT MAP (A(2), TMP(2), C(1), R_int(2), C(2));
    FA3 : FULL_ADDER PORT MAP (A(3), TMP(3), C(2), R_int(3), C(3));
    FA4 : FULL_ADDER PORT MAP (A(4), TMP(4), C(3), R_int(4), C(4));
    FA5 : FULL_ADDER PORT MAP (A(5), TMP(5), C(4), R_int(5), C(5));
    FA6 : FULL_ADDER PORT MAP (A(6), TMP(6), C(5), R_int(6), C(6));
    FA7 : FULL_ADDER PORT MAP (A(7), TMP(7), C(6), R_int(7), C(7));
    FA8 : FULL_ADDER PORT MAP (A(8), TMP(8), C(7), R_int(8), C(8));

    -- ==========================
    -- ASIGNACIÓN DE LA SALIDA R
    -- ==========================
    R <= R_int;  -- Asigna la señal interna a la salida

    -- ==========================
    -- CORRECCIÓN DE OVERFLOW Y COUT
    -- ==========================
    OVERFLOW <= (A(8) XOR TMP(8)) AND (A(8) XOR R_int(8));  -- Detección de Overflow en suma/resta
    COUT <= C(8) WHEN OP = '0' ELSE NOT C(8);  -- Carry correcto en suma/resta

END ARCHITECTURE STRUCT;
