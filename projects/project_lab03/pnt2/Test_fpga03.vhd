LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Test_fpga03 IS
END Test_fpga03;

ARCHITECTURE Test_fpga03Arch OF Test_fpga03 IS
    SIGNAL bin : STD_LOGIC_VECTOR(10 DOWNTO 0);
    SIGNAL led : STD_LOGIC_VECTOR(9 DOWNTO 0);

BEGIN
    DUT : ENTITY WORK.fpga03
        PORT MAP(
            bin => bin,
            led => led
        );

    bin <=
        "10000000001" AFTER 0 ns,
        "00000000010" AFTER 20 ns,
        "10000000100" AFTER 40 ns,
        "00000001000" AFTER 60 ns,
        "10000010000" AFTER 80 ns,
        "00000100000" AFTER 100 ns,
        "10001000000" AFTER 120 ns,
        "00010000000" AFTER 140 ns,
        "10100000000" AFTER 160 ns,
        "01000000000" AFTER 180 ns;
END Test_fpga03Arch;