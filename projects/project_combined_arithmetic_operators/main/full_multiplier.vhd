LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Multiplier IS
    PORT (
        x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        s : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ENTITY Multiplier;

ARCHITECTURE MultiplierArch OF Multiplier IS

    SIGNAL Carry1, Carry2, Carry3, Carry4, Carry5, Carry6, Carry7, Carry8, Carry9, Carry10, Carry11 : STD_LOGIC;
    SIGNAL Temp1, Temp2, Temp3, Temp4, Temp5, Temp6 : STD_LOGIC;

    -- SeÃƒÂ±ales intermedias para almacenar los productos parciales
    SIGNAL P0, P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, P11, P12, P13, P14, P15 : STD_LOGIC;

BEGIN

    -- AsignaciÃƒÂ³n de productos parciales
    P0 <= x(0) AND y(0);
    P1 <= x(1) AND y(0);
    P2 <= x(0) AND y(1);
    P3 <= x(1) AND y(1);
    P4 <= x(2) AND y(0);
    P5 <= x(0) AND y(2);
    P6 <= x(2) AND y(1);
    P7 <= x(3) AND y(0);
    P8 <= x(1) AND y(2);
    P9 <= x(0) AND y(3);
    P10 <= x(3) AND y(1);
    P11 <= x(2) AND y(2);
    P12 <= x(1) AND y(3);
    P13 <= x(3) AND y(2);
    P14 <= x(2) AND y(3);
    P15 <= x(3) AND y(3);

    s(0) <= P0;

    Sum1 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P1,
            B => P2,
            Cin => '0',
            S => s(1),
            Cout => Carry1
        );

    Sum2 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P3,
            B => P4,
            Cin => Carry1,
            S => Temp1,
            Cout => Carry2
        );

    Sum3 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P5,
            B => Temp1,
            Cin => '0',
            S => s(2),
            Cout => Carry3
        );

    Sum4 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P6,
            B => P7,
            Cin => Carry2,
            S => Temp2,
            Cout => Carry4
        );

    Sum5 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P8,
            B => Temp2,
            Cin => Carry3,
            S => Temp3,
            Cout => Carry5
        );

    Sum6 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P9,
            B => Temp3,
            Cin => '0',
            S => s(3),
            Cout => Carry6
        );

    Sum7 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P10,
            B => P11,
            Cin => Carry4,
            S => Temp4,
            Cout => Carry7
        );

    Sum8 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P12,
            B => Temp4,
            Cin => Carry5,
            S => Temp5,
            Cout => Carry8
        );

    Sum9 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => '0',
            B => Temp5,
            Cin => Carry6,
            S => s(4),
            Cout => Carry9
        );

    Sum10 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P13,
            B => P14,
            Cin => Carry7,
            S => Temp6,
            Cout => Carry10
        );

    Sum11 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => Carry8,
            B => Temp6,
            Cin => Carry9,
            S => s(5),
            Cout => Carry11
        );

    Sum12 : ENTITY WORK.Full_Adder(Full_AdderArch)
        PORT MAP(
            A => P15,
            B => Carry10,
            Cin => Carry11,
            S => s(6),
            Cout => s(7)
        );

END MultiplierArch;