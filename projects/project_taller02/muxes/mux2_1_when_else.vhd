LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY mux2_1_when_else IS
    PORT (
        x1 : IN STD_LOGIC;
        x2 : IN STD_LOGIC;
        sel : IN STD_LOGIC;
        y : OUT STD_LOGIC
    );
END ENTITY mux2_1_when_else;
---------------------------------------------------------------------------------
ARCHITECTURE functional OF mux2_1_when_else IS
BEGIN
    y <= x1 WHEN sel = '0' ELSE
        x2;

END ARCHITECTURE functional;