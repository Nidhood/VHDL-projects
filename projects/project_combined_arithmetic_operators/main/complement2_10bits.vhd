LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY complement2_10bits IS
    PORT (
        X : IN STD_LOGIC_VECTOR(9 DOWNTO 0); -- Entrada
        S : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) -- -(X) en 2’s complement
    );
END ENTITY complement2_10bits;

ARCHITECTURE ripple_adder OF complement2_10bits IS

    COMPONENT Full_Adder IS
        PORT (
            A, B, Cin : IN STD_LOGIC;
            S, Cout : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL notX : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL sum : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL c : STD_LOGIC_VECTOR(9 DOWNTO 0); -- Acarreos internos

BEGIN

    ----------------------------------------------------------------
    -- 1) Invertir bits de X:  notX <= NOT X
    ----------------------------------------------------------------
    notX <= NOT X;

    ----------------------------------------------------------------
    -- 2) Suma bit 0: (NOT X)(0) + '1' + '0'
    ----------------------------------------------------------------
    FA0 : Full_Adder
    PORT MAP(
        A => notX(0),
        B => '1', -- Se agrega el +1 en el bit 0
        Cin => '0',
        S => sum(0),
        Cout => c(0)
    );

    ----------------------------------------------------------------
    -- 3) Suma bits 1..9: (NOT X)(i) + '0' + carry anterior
    ----------------------------------------------------------------
    FA1 : Full_Adder
    PORT MAP(
        A => notX(1),
        B => '0',
        Cin => c(0),
        S => sum(1),
        Cout => c(1)
    );

    FA2 : Full_Adder
    PORT MAP(
        A => notX(2),
        B => '0',
        Cin => c(1),
        S => sum(2),
        Cout => c(2)
    );

    FA3 : Full_Adder
    PORT MAP(
        A => notX(3),
        B => '0',
        Cin => c(2),
        S => sum(3),
        Cout => c(3)
    );

    FA4 : Full_Adder
    PORT MAP(
        A => notX(4),
        B => '0',
        Cin => c(3),
        S => sum(4),
        Cout => c(4)
    );

    FA5 : Full_Adder
    PORT MAP(
        A => notX(5),
        B => '0',
        Cin => c(4),
        S => sum(5),
        Cout => c(5)
    );

    FA6 : Full_Adder
    PORT MAP(
        A => notX(6),
        B => '0',
        Cin => c(5),
        S => sum(6),
        Cout => c(6)
    );

    FA7 : Full_Adder
    PORT MAP(
        A => notX(7),
        B => '0',
        Cin => c(6),
        S => sum(7),
        Cout => c(7)
    );

    FA8 : Full_Adder
    PORT MAP(
        A => notX(8),
        B => '0',
        Cin => c(7),
        S => sum(8),
        Cout => c(8)
    );

    FA9 : Full_Adder
    PORT MAP(
        A => notX(9),
        B => '0',
        Cin => c(8),
        S => sum(9),
        Cout => c(9)
    );

    ----------------------------------------------------------------
    -- 4) Asignar la salida final
    ----------------------------------------------------------------
    S <= sum;

END ARCHITECTURE ripple_adder;