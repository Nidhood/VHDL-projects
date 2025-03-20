---------------------------------------------------------------------------------
--    Description: Mux 6 to 2 with 4-bit select using when else                --
--    Author: David Villalobos                                                 --
--    Date: 11/03/2025                                                         --
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY mux6_2_when_else_2 IS
    PORT (
        signal2 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal7 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        X : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        Y : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );

END ENTITY mux6_2_when_else_2;

ARCHITECTURE mux6_2_when_else_2Arch OF mux6_2_when_else_2 IS

BEGIN

    X <= signal7 WHEN sel = "0000" ELSE
        signal2 WHEN sel = "0001" ELSE
        signal2 WHEN sel = "0011" ELSE
        signal7 WHEN sel = "0100" ELSE
        "0000000000";

    Y <= signal2 WHEN sel = "0000" ELSE
        signal7 WHEN sel = "0001" ELSE
        signal7 WHEN sel = "0011" ELSE
        signal2 WHEN sel = "0100" ELSE
        "0000000000";

END mux6_2_when_else_2Arch;