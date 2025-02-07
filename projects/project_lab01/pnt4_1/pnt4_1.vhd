LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
--                                                                             -- 
--    Point 4.1: Designing a logic circuit with the conditions:                --
--    - Function will be '1' if the amount of '1's is two.                     --
--    Author: Ivan Dario Orozco Ibanez                                         --
--                                                                             --
---------------------------------------------------------------------------------
ENTITY pnt4_1 IS
    PORT (
        x1 : IN STD_LOGIC;
        x2 : IN STD_LOGIC;
        x3 : IN STD_LOGIC;
        f : OUT STD_LOGIC
    );
END ENTITY pnt4_1;
---------------------------------------------------------------------------------
ARCHITECTURE GateLevel OF pnt4_1 IS
BEGIN

    f <= (
        ((NOT x1) AND x2 AND x3) OR
        (x1 AND (NOT x2) AND x3) OR
        (x1 AND x2 AND (NOT x3))
        );

END ARCHITECTURE GateLevel;