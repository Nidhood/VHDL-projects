LIBRARY IEEE; -- Is the library that contains the standard logic package
USE IEEE.STD_LOGIC_1164.ALL; -- Is the package that contains the standard logic types and subprograms
USE IEEE.numeric_std.ALL; -- Is the package that contains the numeric types and subprograms

-- TestProtocol is a testbench for the Protocol entity
ENTITY TestProtocol IS -- The entity declaration
END ENTITY TestProtocol; -- The end of the entity declaration

ARCHITECTURE TestProtocolArch OF TestProtocol IS -- The architecture declaration

    SIGNAL In0_tb : STD_LOGIC; -- The signal declaration for the input In0
    SIGNAL In1_tb : STD_LOGIC; -- The signal declaration for the input In1
    SIGNAL Eq_tb : STD_LOGIC; -- The signal declaration for the output Eq

BEGIN

    x1 : ENTITY work.oneBitEquality
        PORT MAP(
            In0 => In0_tb,
            In1 => In1_tb,
            Eq => Eq_tb
        );
-- Stimulus process for the TestProtocol testbench
In0_tb <=
    '0' AFTER 20 ns,
    '1' AFTER 40 ns,
    '0' AFTER 60 ns,
    '1' AFTER 80 ns,
    '0' AFTER 100 ns;

In1_tb <=
    '0' AFTER 20 ns,
    '0' AFTER 40 ns,
    '1' AFTER 60 ns,
    '1' AFTER 80 ns,
    '0' AFTER 100 ns;

END TestProtocolArch;