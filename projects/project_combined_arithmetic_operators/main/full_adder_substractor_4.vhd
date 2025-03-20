---------------------------------------------------------------------------------
--    Description: Full adder/substractor for 4-bit numbers                    --
--    Authors: Ivan Dario Orozco Ibanez & Jeronimo Rueda                       --
--    Date: 11/03/2025                                                         --
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY FULL_ADDER_SUBSTRACTOR_4 IS
    PORT (
        OP : IN STD_LOGIC;
        A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        R : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        CARRY : OUT STD_LOGIC;
        OVERFLOW : OUT STD_LOGIC
    );
END ENTITY FULL_ADDER_SUBSTRACTOR_4;
---------------------------------------------------------------------------------
ARCHITECTURE STRUCT OF FULL_ADDER_SUBSTRACTOR_4 IS

    COMPONENT FULL_ADDER IS
        PORT (
            A, B, Cin : IN STD_LOGIC;
            S, Cout : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL C : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL TMP : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL R_int : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL OP_vec : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN

    OP_vec <= (OTHERS => OP);
    TMP <= B XOR OP_vec;

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

    R <= R_int;

    CARRY <= C(3) WHEN OP = '0' ELSE
        NOT C(3);

    OVERFLOW <= C(2) XOR C(3);

END ARCHITECTURE STRUCT;