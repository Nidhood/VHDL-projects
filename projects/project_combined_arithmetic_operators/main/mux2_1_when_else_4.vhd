LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux2_1_when_else_4 IS
    PORT (
        signal9 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal10 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        OUTPUT : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END ENTITY mux2_1_when_else_4;

ARCHITECTURE mux2_1_when_else_4Arch OF mux2_1_when_else_4 IS
BEGIN

    OUTPUT <=
        signal9 WHEN sel = "1001" ELSE
        signal10 WHEN sel = "1000" ELSE
        "0000000000";

END ARCHITECTURE mux2_1_when_else_4Arch;