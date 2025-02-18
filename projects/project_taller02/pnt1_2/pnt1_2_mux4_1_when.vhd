------------------------------------------------------------------------------------------
--                              Ivan Dario Orozco Ibanez                                --
--                                                                                      --
--  Project: Multiplexor 4:1 con when/else                                              --
--  Date: 18/02/2025                                                                    --
------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------------------------------------------------
ENTITY pnt1_2_mux4_1_when IS
       PORT (
              x1 : IN STD_LOGIC;
              x2 : IN STD_LOGIC;
              x3 : IN STD_LOGIC;
              x4 : IN STD_LOGIC;
              s0 : IN STD_LOGIC;
              s1 : IN STD_LOGIC;
              y : OUT STD_LOGIC
       );
END ENTITY pnt1_2_mux4_1_when;
------------------------------------------------------------------------------------------
ARCHITECTURE pnt1_2_mux4_1_when_arch OF pnt1_2_mux4_1_when IS
       SIGNAL concat : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN

       concat <= s1 & s0;

       y <=
              x1 WHEN concat = "00" ELSE
              x2 WHEN concat = "01" ELSE
              x3 WHEN concat = "10" ELSE
              x4;
END pnt1_2_mux4_1_when_arch;