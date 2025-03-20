---------------------------------------------------------------------------------
--    Description: Full adder/substractor for 10-bit numbers                   --
--    Authors: Ivan Dario Orozco Ibanez & Jeronimo Rueda                       --
--    Date: 11/03/2025                                                          --
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY FULL_ADDER_SUBSTRACTOR_10 IS
    PORT (
        OP : IN STD_LOGIC;
        A, B : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        R : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        COUT : OUT STD_LOGIC
    );
END ENTITY FULL_ADDER_SUBSTRACTOR_10;
---------------------------------------------------------------------------------
ARCHITECTURE STRUCT OF FULL_ADDER_SUBSTRACTOR_10 IS

    COMPONENT FULL_ADDER IS
        PORT (
            A, B, Cin : IN STD_LOGIC;
            S, Cout : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL C : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL TMP : STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL R_int : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN

    TMP <= B XOR (OP & OP & OP & OP & OP & OP & OP & OP & OP & OP);

    FA0 : FULL_ADDER PORT MAP(
        A => A(0),
        B => TMP(0),
        Cin => OP,
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

    R <= R_int;

    COUT <= C(9) WHEN OP = '0' ELSE
        NOT C(9);

END ARCHITECTURE STRUCT;