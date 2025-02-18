------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --    
--  Project: Logical function                                                           --
--  Date: 18/02/2025                                                                    --         
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------------
ENTITY pnt2_1_logical_function IS

    PORT (
        x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        y : OUT STD_LOGIC
    );

END ENTITY;
------------------------------------------------------------------------------------------
ARCHITECTURE pnt2_1_logical_function_arch OF pnt2_1_logical_function IS
BEGIN

    y <=
        (
        ((NOT x(0)) AND (NOT x(2))) OR
        ((NOT x(0)) AND (NOT x(3))) OR
        ((NOT x(1)) AND (NOT x(2))) OR
        ((NOT x(1)) AND (NOT x(3)))
        );

END pnt2_1_logical_function_arch;