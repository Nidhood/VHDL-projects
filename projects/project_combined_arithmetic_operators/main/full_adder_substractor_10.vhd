LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FULL_ADDER_SUBSTRACTOR_10 IS
    PORT (
        OP : IN STD_LOGIC; -- 0 = Suma, 1 = Resta
        A, B : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Entradas de 10 bits con signo (MSB = signo)
        R : OUT STD_LOGIC_VECTOR(9 DOWNTO 0); -- Resultado: 1 bit de signo (MSB) + 9 bits de valor
        COUT : OUT STD_LOGIC -- Carry, que se usará como signo
    );
END ENTITY FULL_ADDER_SUBSTRACTOR_10;

ARCHITECTURE STRUCT OF FULL_ADDER_SUBSTRACTOR_10 IS

    COMPONENT FULL_ADDER IS
        PORT (
            A, B, Cin : IN STD_LOGIC;
            S, Cout : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL C : STD_LOGIC_VECTOR(9 DOWNTO 0); -- Acarreos internos para 10 bits
    SIGNAL TMP : STD_LOGIC_VECTOR(9 DOWNTO 0); -- Señal para invertir B en caso de resta
    SIGNAL R_int : STD_LOGIC_VECTOR(9 DOWNTO 0); -- Resultado interno (10 bits)

BEGIN

    -- Para suma (OP = '0') se usa B directamente;
    -- para resta (OP = '1') se invierte B utilizando XOR con una máscara de OP repetido 10 veces.
    TMP <= B XOR (OP & OP & OP & OP & OP & OP & OP & OP & OP & OP);

    FA0 : FULL_ADDER PORT MAP(
        A => A(0),
        B => TMP(0),
        Cin => OP, -- En suma: Cin = '0'; en resta: Cin = '1'
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
    FA4 : FULL_ADDER PORT MAP(
        A => A(4),
        B => TMP(4),
        Cin => C(3),
        S => R_int(4),
        Cout => C(4)
    );
    FA5 : FULL_ADDER PORT MAP(
        A => A(5),
        B => TMP(5),
        Cin => C(4),
        S => R_int(5),
        Cout => C(5)
    );
    FA6 : FULL_ADDER PORT MAP(
        A => A(6),
        B => TMP(6),
        Cin => C(5),
        S => R_int(6),
        Cout => C(6)
    );
    FA7 : FULL_ADDER PORT MAP(
        A => A(7),
        B => TMP(7),
        Cin => C(6),
        S => R_int(7),
        Cout => C(7)
    );
    FA8 : FULL_ADDER PORT MAP(
        A => A(8),
        B => TMP(8),
        Cin => C(7),
        S => R_int(8),
        Cout => C(8)
    );
    FA9 : FULL_ADDER PORT MAP(
        A => A(9),
        B => TMP(9),
        Cin => C(8),
        S => R_int(9),
        Cout => C(9)
    );

    -- Se asigna el resultado completo (10 bits) a la salida R,
    -- donde R(9) es el bit de signo y R(8 DOWNTO 0) la parte numérica.
    R <= R_int;

    -- El puerto COUT se utiliza para reflejar el acarreo final.
    -- Para suma se usa directamente C(9); para resta se invierte C(9) para reflejar la convención de borrow en complemento a 2.
    COUT <= C(9) WHEN OP = '0' ELSE
        NOT C(9);

END ARCHITECTURE STRUCT;