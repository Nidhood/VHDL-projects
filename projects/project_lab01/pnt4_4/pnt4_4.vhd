LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
--                                                                             -- 
--          Point 4.4: Designing a logic circuit with the conditions:          --
--          - Function will be '1' if x1 = 1 and x2 = x3.                      --
--          - Function will be '1' if x1 = 0 and x2 != x3.                     --  
--          Author: Ivan Dario Orozco Ibanez                                   --
--                                                                             --
---------------------------------------------------------------------------------
ENTITY pnt4_4 IS
    PORT (
        x1 : IN STD_LOGIC;
        x2 : IN STD_LOGIC;
        x3 : IN STD_LOGIC;
        f : OUT STD_LOGIC
    );
END ENTITY pnt4_4;
---------------------------------------------------------------------------------
ARCHITECTURE GateLevel OF pnt4_4 IS
BEGIN

    f <= (
        ((NOT x1) AND (NOT x2) AND x3) OR
        ((NOT x1) AND x2 AND (NOT x3)) OR
        (x1 AND (NOT x2) AND (NOT x3)) OR
        (x1 AND x2 AND x3)
        );

END ARCHITECTURE GateLevel;

