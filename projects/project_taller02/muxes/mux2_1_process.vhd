LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
--                                                                             -- 
--    'oneBitEquality' compares two bits to determine if their value is equal  --
--               The output eq is set to one if thath is true                  -- 
--                                                                             -- 
---------------------------------------------------------------------------------
ENTITY mux2_1_process IS
    PORT (
        x1 : IN STD_LOGIC;
        x2 : IN STD_LOGIC;
        sel : IN STD_LOGIC;
        y : OUT STD_LOGIC
    );
END ENTITY mux2_1_process;
---------------------------------------------------------------------------------
ARCHITECTURE behaviour OF mux2_1_process IS
BEGIN

    mux_process : PROCESS (x1, x2, sel)
    BEGIN
        IF sel = '0' THEN
            y <= x1;
        ELSE
            y <= x2;
        END IF;
    END PROCESS mux_process;

END ARCHITECTURE behaviour;