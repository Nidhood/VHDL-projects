---------------------------------------------------------------------------------
--    Description: Mux 4 to 1 with 4-bit select using when else                --
--    Author: David Villalobos                                                 --
--    Date: 11/03/2025                                                         --
---------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------------------------------
ENTITY mux4_1_when_else IS
    PORT (
        A : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        C : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        D : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        OUTPUT : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );

END ENTITY mux4_1_when_else;

ARCHITECTURE mux4_1_when_elseArch OF mux4_1_when_else IS

BEGIN

    OUTPUT <= A WHEN sel = "00" ELSE
        B WHEN sel = "01" ELSE
        C WHEN sel = "10" ELSE
        D WHEN sel = "11" ELSE
        "0000";

END mux4_1_when_elseArch;