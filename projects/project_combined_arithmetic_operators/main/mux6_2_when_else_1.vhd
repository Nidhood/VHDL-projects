LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux6_2_when_else_1 IS
    PORT (
        signal1 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal2 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal3 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal4 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal5 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal6 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        X : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        Y : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );

END ENTITY mux6_2_when_else_1;

ARCHITECTURE mux6_2_when_else_1Arch OF mux6_2_when_else_1 IS

BEGIN

    X <= signal1 WHEN sel = "000" ELSE
        signal3 WHEN sel = "001" ELSE
        signal5 WHEN sel = "010" ELSE
        signal1 WHEN sel = "011" ELSE
        -- FALTA DEFINIR LOS CASOS 10, 11, 18
        "0000000000";

    Y <= signal2 WHEN sel = "000" ELSE
        signal4 WHEN sel = "001" ELSE
        signal6 WHEN sel = "010" ELSE
        signal6 WHEN sel = "011" ELSE
        -- FALTA DEFINIR LOS CASOS 10, 11, 18
        "0000000000";

END mux6_2_when_else_1Arch;

------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.mux6_2_when_else_1(mux6_2_when_else_1Arch)
--PORT MAP   (signal1 => SLV,
--            signal2 => SLV,
--            signal3 => SLV,
--            signal4 => SLV,
--            signal5 => SLV,
--            signal6 => SLV,
--            sel => SLV,
--            X => SLV,
--			  Y => SLV
--           );