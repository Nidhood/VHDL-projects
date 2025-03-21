---------------------------------------------------------------------------------
--    Description: Mux 6 to 2 with 4-bit select using when else                --
--    Author: David Villalobos                                                 --
--    Date: 11/03/2025                                                         --
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY mux6_2_when_else_1 IS
    PORT (
        signal1 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal2 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal3 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal4 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal5 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal6 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        X : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        Y : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );

END ENTITY mux6_2_when_else_1;

ARCHITECTURE mux6_2_when_else_1Arch OF mux6_2_when_else_1 IS

BEGIN

    X <= signal1 WHEN sel = "0000" ELSE
        signal3 WHEN sel = "0001" ELSE
        signal5 WHEN sel = "0010" ELSE
        signal1 WHEN sel = "0011" ELSE
        signal5 WHEN sel = "0100" ELSE
        "0000000000";

    Y <= signal2 WHEN sel = "0000" ELSE
        signal4 WHEN sel = "0001" ELSE
        signal6 WHEN sel = "0010" ELSE
        signal6 WHEN sel = "0011" ELSE
        signal6 WHEN sel = "0100" ELSE
        "0000000000";

END mux6_2_when_else_1Arch;