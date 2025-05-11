LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY mux2_1_gates IS
    PORT (
        x1 : IN STD_LOGIC;
        x2 : IN STD_LOGIC;
        sel : IN STD_LOGIC;
        y : OUT STD_LOGIC
    );
END ENTITY mux2_1_gates;
---------------------------------------------------------------------------------
ARCHITECTURE GateLevel OF mux2_1_gates IS
    SIGNAL p0 : STD_LOGIC;
    SIGNAL p1 : STD_LOGIC;
BEGIN
    -- Sum of products
    sumOfProducts : y <= p0 OR p1;

    -- Product terms
    bothHigh : p0 <= x1 AND (NOT sel);
    bothLow : p1 <= NOT x2 AND sel;

END ARCHITECTURE GateLevel;