LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

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
        D WHEN sel = "11";

END mux4_1_when_elseArch;