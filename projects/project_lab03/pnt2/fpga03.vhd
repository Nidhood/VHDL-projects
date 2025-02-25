LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY fpga03 IS
    PORT (
        bin  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
        led : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END ENTITY fpga03;

ARCHITECTURE functional OF fpga03 IS
BEGIN

WITH bin SELECT
    led <=
    "00" WHEN "000",
    "10" WHEN "001",
    "10" WHEN "010",
    "01" WHEN "011",
    "10" WHEN "100",
    "01" WHEN "101",
    "01" WHEN "110",
    "11" WHEN "111",
    "00" WHEN OTHERS;


END ARCHITECTURE functional;
