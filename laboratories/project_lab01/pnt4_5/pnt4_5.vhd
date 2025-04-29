LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
--                                                                             -- 
--    Point 4.5: Designing a logic circuit with the conditions:                --
--    - Function will be '1' if the amount of '1' is two.                      --
--    - Function will be '0' if x1 = '0'.                                      --
--    Author: Ivan Dario Orozco Ibanez                                         --
--                                                                             --
---------------------------------------------------------------------------------
ENTITY pnt4_5 IS
    PORT (
        x1 : IN STD_LOGIC;
        x2 : IN STD_LOGIC;
        x3 : IN STD_LOGIC;
        f : OUT STD_LOGIC
    );
END ENTITY pnt4_5;
---------------------------------------------------------------------------------
ARCHITECTURE GateLevel OF pnt4_5 IS
BEGIN

    f <= (
        (x1 AND (NOT x2) AND x3) OR
        (x1 AND x2 AND (NOT x3))
        );

END ARCHITECTURE GateLevel;

