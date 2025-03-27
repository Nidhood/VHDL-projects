LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
--                                                                             -- 
--    'oneBitEquality' compares two bits to determine if their value is equal  --
--               The output eq is set to one if thath is true                  -- 
--                                                                             -- 
---------------------------------------------------------------------------------
ENTITY oneBitEquality IS
    PORT (
        In0 : IN STD_LOGIC;
        In1 : IN STD_LOGIC;
        Eq : OUT STD_LOGIC
    );
END ENTITY oneBitEquality;
---------------------------------------------------------------------------------
ARCHITECTURE GateLevel OF oneBitEquality IS
BEGIN
    Eq <= In0 XNOR In1;
END ARCHITECTURE GateLevel;