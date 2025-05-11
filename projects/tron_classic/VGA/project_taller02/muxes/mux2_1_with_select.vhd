LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY mux2_1_with_select IS
    PORT (
        x1 : IN STD_LOGIC;
        x2 : IN STD_LOGIC;
        sel : IN STD_LOGIC;
        y : OUT STD_LOGIC
    );
END ENTITY mux2_1_with_select;
---------------------------------------------------------------------------------
ARCHITECTURE functional OF mux2_1_with_select IS
BEGIN
    WITH sel SELECT
        y <= x1 WHEN '0',
        x2 WHEN OTHERS;

END ARCHITECTURE functional;