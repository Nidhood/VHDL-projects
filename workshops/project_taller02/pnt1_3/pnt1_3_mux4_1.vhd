------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --    
--  Project: Multiplexor 4:1 con 2:1                                                    --
--  Date: 18/02/2025                                                                    --         
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------------
ENTITY pnt1_3_mux4_1 IS
    PORT (
        x1 : IN STD_LOGIC;
        x2 : IN STD_LOGIC;
        x3 : IN STD_LOGIC;
        x4 : IN STD_LOGIC;
        s0 : IN STD_LOGIC;
        s1 : IN STD_LOGIC;
        y : OUT STD_LOGIC
    );
END ENTITY;
------------------------------------------------------------------------------------------
ARCHITECTURE pnt1_3_mux4_1_arch OF pnt1_3_mux4_1 IS
    SIGNAL m1, m2 : STD_LOGIC;
BEGIN
    Mux0 : ENTITY WORK.mux2_1_with_select PORT MAP(s0, x1, x2, m1);
    Mux1 : ENTITY WORK.mux2_1_with_select PORT MAP(s0, x3, x4, m2);
    Mux2 : ENTITY WORK.mux2_1_with_select PORT MAP(s1, m1, m2, y);
END pnt1_3_mux4_1_arch;

