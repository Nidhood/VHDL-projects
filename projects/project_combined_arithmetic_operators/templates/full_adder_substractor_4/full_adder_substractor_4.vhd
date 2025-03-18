LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FULL_ADDER_SUBSTRACTOR_4 IS
    PORT (
        OP : IN STD_LOGIC; -- 0 = Suma, 1 = Resta
        A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Entradas de 4 bits (sin signo)
        R : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- Resultado (4 bits en 2’s complement)
        CARRY : OUT STD_LOGIC; -- Carry extra que representa el signo (según la operación)
        OVERFLOW : OUT STD_LOGIC -- Indicador de desbordamiento (overflow)
    );
END ENTITY FULL_ADDER_SUBSTRACTOR_4;

ARCHITECTURE STRUCT OF FULL_ADDER_SUBSTRACTOR_4 IS

    COMPONENT FULL_ADDER IS
        PORT (
            A, B, Cin : IN STD_LOGIC;
            S, Cout : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Señales internas
    SIGNAL C : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Acarreos internos: de FA0 a FA3
    SIGNAL TMP : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Para invertir B en caso de resta
    SIGNAL R_int : STD_LOGIC_VECTOR(3 DOWNTO 0);-- Resultado interno de 4 bits
    SIGNAL OP_vec : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Vector de 4 bits con cada elemento = OP
BEGIN

    -- Convertir OP (un bit) en un vector de 4 bits
    OP_vec <= (OTHERS => OP);

    -- Para suma (OP = '0'): TMP = B; para resta (OP = '1'): TMP = NOT B.
    TMP <= B XOR OP_vec;

    FA0 : FULL_ADDER PORT MAP(
        A => A(0),
        B => TMP(0),
        Cin => OP, -- en suma: OP = '0'; en resta: OP = '1' (se suma 1)
        S => R_int(0),
        Cout => C(0)
    );

    FA1 : FULL_ADDER PORT MAP(
        A => A(1),
        B => TMP(1),
        Cin => C(0),
        S => R_int(1),
        Cout => C(1)
    );

    FA2 : FULL_ADDER PORT MAP(
        A => A(2),
        B => TMP(2),
        Cin => C(1),
        S => R_int(2),
        Cout => C(2)
    );

    FA3 : FULL_ADDER PORT MAP(
        A => A(3),
        B => TMP(3),
        Cin => C(2),
        S => R_int(3),
        Cout => C(3)
    );

    -- Se asigna la salida interna (4 bits) al puerto R.
    R <= R_int;

    -- Para el puerto CARRY:
    -- En suma (OP = '0') se usa directamente el carry final C(3);
    -- en resta (OP = '1') se invierte C(3) (ya que en resta, sin borrow, C(3) = '1').
    CARRY <= C(3) WHEN OP = '0' ELSE
        NOT C(3);

    -- El flag OVERFLOW se calcula como XOR entre C(2) y C(3)
    OVERFLOW <= C(2) XOR C(3);

END ARCHITECTURE STRUCT;