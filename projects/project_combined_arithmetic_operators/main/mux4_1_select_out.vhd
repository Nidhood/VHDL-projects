LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4_1_select_out IS
    PORT (
        signal3 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal7 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal1 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal8 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal9 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal11 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        signal12 : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        OUTPUT : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );

END ENTITY mux4_1_select_out;

ARCHITECTURE mux4_1_select_outArch OF mux4_1_select_out IS

BEGIN

    OUTPUT <=
        signal7 WHEN sel = "0000" ELSE
        signal7 WHEN sel = "0001" ELSE
        signal7 WHEN sel = "0010" ELSE
        signal8 WHEN sel = "0011" ELSE
        signal8 WHEN sel = "0100" ELSE
        signal1 WHEN sel = "0101" ELSE
        signal7 WHEN sel = "0110" ELSE
        signal9 WHEN sel = "0111" ELSE
        signal11 WHEN sel = "1001" ELSE
        signal11 WHEN sel = "1000" ELSE
        "0000000000";

END mux4_1_select_outArch;

------------------------------------------------------------------------------------------
--BlockN: ENTITY WORK.mux4_1_select_out(mux4_1_select_outArch)
--PORT MAP   (signal3 => SLV,
--            signal7 => SLV,
--            signal1 => SLV,
--            signal8 => SLV,
--            sel => SLV,
--            OUTPUT => SLV
--           );