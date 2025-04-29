LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY TestProtocol IS
END ENTITY TestProtocol;

ARCHITECTURE TestProtocolArch OF TestProtocol IS

    SIGNAL In0_tb : STD_LOGIC;
    SIGNAL In1_tb : STD_LOGIC;
    SIGNAL Eq_tb : STD_LOGIC;

BEGIN

    X1 : ENTITY work.oneBitEquality

        PORT MAP(
            In0 => In0_tb,
            In1 => In1_tb,
            Eq => Eq_tb
        );

    In0_tb <=
        '0' AFTER 20 ns,
        '1' AFTER 40 ns,
        '0' AFTER 60 ns,
        '1' AFTER 80 ns,
        '0' AFTER 100 ns;

    In1_tb <=
        '0' AFTER 20 ns,
        '1' AFTER 60 ns,
        '0' AFTER 100 ns;

END TestProtocolArch;
